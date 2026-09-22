-- =====================================================================
-- MASTERY B2C — DATA LAYER
-- PostgreSQL DDL — Version 2.0 (pure data layer, no embedded business logic)
--
-- This schema intentionally holds NO business rules:
--   - No ENUM types (state/type values are plain TEXT, validated in the
--     backend application layer, not the database).
--   - No CHECK constraints (value validation happens in the backend).
--   - No workflow-decision DEFAULT values (initial status, flags, limits,
--     counters are always set explicitly by the backend on insert).
--   - The only DEFAULTs kept are mechanical, not business decisions:
--     gen_random_uuid() for primary keys, and now() for audit timestamps.
--
-- What the database still enforces (structural, not business logic):
--   - Primary keys / foreign keys (referential integrity)
--   - NOT NULL where a value is structurally required to identify or
--     relate a row (e.g. an order must reference a customer)
--   - UNIQUE constraints where two rows referring to the same real-world
--     identity would corrupt data (email, slug, idempotency keys)
--   - Indexes for query performance
--
-- Sections:
--   00. Extensions
--   01. Geo, Currency, Locale, Tax (source of truth for landing page + pricing)
--   02. Customer & Identity
--   03. Catalog & Resource (LMS abstraction)
--   04. Commerce Engine (Pricing, Cart, Orders, Payments, Promotions)
--   05. Entitlement & Fulfillment
--   06. Subscription Engine
--   07. Consultation Marketplace
--   08. Community
--   09. Growth & Loyalty (Referral / Wallet / Rewards)
--   10. Reviews
--   11. Landing Pages & Merchandising (CMS, geo-targeted content)
--   12. AI / RAG (embeddings, conversations, recommendation logs)
--   13. Platform: Audit Log, Webhooks Inbox, Sync/Observability
-- =====================================================================


-- =====================================================================
-- 00. EXTENSIONS
-- =====================================================================
CREATE EXTENSION IF NOT EXISTS pgcrypto;   -- gen_random_uuid()
CREATE EXTENSION IF NOT EXISTS citext;     -- case-insensitive email
CREATE EXTENSION IF NOT EXISTS vector;     -- pgvector, for RAG embeddings


-- =====================================================================
-- 01. GEO, CURRENCY, LOCALE, TAX
--     Source of truth for geo-routing / pricing / landing page localization.
-- =====================================================================
CREATE TABLE countries (
  country_code      CHAR(2) PRIMARY KEY,         -- ISO 3166-1 alpha-2
  name              TEXT NOT NULL,
  default_currency  CHAR(3) NOT NULL,
  default_locale    TEXT NOT NULL,
  is_active         BOOLEAN NOT NULL
);

CREATE TABLE currencies (
  currency_code   CHAR(3) PRIMARY KEY,           -- ISO 4217
  symbol          TEXT NOT NULL,
  decimal_places  SMALLINT NOT NULL
);

CREATE TABLE locales (
  locale_code   TEXT PRIMARY KEY,                -- 'ar', 'ar-SA', 'en'
  name          TEXT NOT NULL,
  is_rtl        BOOLEAN NOT NULL,
  is_active     BOOLEAN NOT NULL
);

-- tax_type / applies_to are free text, e.g. 'vat' | 'gst' | 'sales_tax',
-- 'all' | 'digital_goods' — validated in the backend, not here.
CREATE TABLE tax_rules (
  id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  country_code       CHAR(2) NOT NULL REFERENCES countries(country_code),
  tax_type           TEXT NOT NULL,
  rate_percentage    NUMERIC(5,2) NOT NULL,
  applies_to         TEXT NOT NULL,
  valid_from         DATE NOT NULL,
  valid_to           DATE,
  UNIQUE (country_code, tax_type, valid_from)
);

-- gateway is free text, e.g. 'stripe' | 'tabby' | 'tamara'
CREATE TABLE payment_gateway_availability (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  country_code   CHAR(2) NOT NULL REFERENCES countries(country_code),
  gateway        TEXT NOT NULL,
  is_enabled     BOOLEAN NOT NULL,
  UNIQUE (country_code, gateway)
);


-- =====================================================================
-- 02. CUSTOMER & IDENTITY
-- =====================================================================
-- status is free text, e.g. 'active' | 'suspended' — backend-controlled.
CREATE TABLE customers (
  customer_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lms_user_id        TEXT UNIQUE,                     -- link to learning identity, nullable until provisioned
  email               CITEXT UNIQUE NOT NULL,
  phone               TEXT,
  country_code        CHAR(2) REFERENCES countries(country_code),
  preferred_currency  CHAR(3) REFERENCES currencies(currency_code),
  preferred_locale    TEXT REFERENCES locales(locale_code),
  status              TEXT NOT NULL,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Identity Linking Engine: multiple login channels resolving to one customer.
-- provider is free text, e.g. 'google' | 'email_otp' | 'mobile_otp'
CREATE TABLE customer_auth_identities (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id     UUID NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
  provider        TEXT NOT NULL,
  provider_uid    TEXT NOT NULL,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (provider, provider_uid)
);

-- Smart Onboarding -> Skill Graph, feeds the AI Layer (not the LMS).
CREATE TABLE customer_learning_profiles (
  customer_id             UUID PRIMARY KEY REFERENCES customers(customer_id) ON DELETE CASCADE,
  goal                    TEXT,
  domain                  TEXT,
  target_skills           JSONB NOT NULL,          -- e.g. ["React","TypeScript","UX/UI"]
  current_level           TEXT,
  daily_study_minutes     INTEGER,
  onboarding_completed_at TIMESTAMPTZ,
  updated_at              TIMESTAMPTZ NOT NULL DEFAULT now()
);


-- =====================================================================
-- 03. CATALOG & RESOURCE (LMS abstraction)
-- =====================================================================
CREATE TABLE instructors (
  instructor_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lms_instructor_id TEXT,                           -- reference only
  display_name      TEXT NOT NULL,
  bio               TEXT,
  avatar_url        TEXT,
  expertise         JSONB NOT NULL,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE categories (
  category_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  parent_id     UUID REFERENCES categories(category_id),
  slug          TEXT UNIQUE NOT NULL,
  sort_order    INTEGER NOT NULL
);

CREATE TABLE category_translations (
  category_id   UUID NOT NULL REFERENCES categories(category_id) ON DELETE CASCADE,
  locale_code   TEXT NOT NULL REFERENCES locales(locale_code),
  name          TEXT NOT NULL,
  PRIMARY KEY (category_id, locale_code)
);

-- Commerce entity. NOT the course itself.
-- product_type is free text, e.g. 'course' | 'diploma' | 'bundle' |
--   'subscription' | 'live_program' | 'consultation' | 'community' | 'add_on'
-- status is free text, e.g. 'draft' | 'published' | 'archived'
CREATE TABLE products (
  product_id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_type             TEXT NOT NULL,
  slug                     TEXT UNIQUE NOT NULL,
  status                   TEXT NOT NULL,
  base_currency            CHAR(3) NOT NULL REFERENCES currencies(currency_code),
  base_price               NUMERIC(10,2) NOT NULL,
  compare_at_price         NUMERIC(10,2),
  access_duration_days     INTEGER,                 -- default access window (e.g. 365)
  extension_enabled        BOOLEAN NOT NULL,
  extension_duration_days  INTEGER,
  extension_price          NUMERIC(10,2),
  cpd_eligible              BOOLEAN NOT NULL,
  instructor_id             UUID REFERENCES instructors(instructor_id),
  created_at                TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at                TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE product_translations (
  product_id         UUID NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
  locale_code        TEXT NOT NULL REFERENCES locales(locale_code),
  title               TEXT NOT NULL,
  short_description   TEXT,
  description          TEXT,
  seo_meta             JSONB NOT NULL,               -- title tag, meta description, schema markup
  PRIMARY KEY (product_id, locale_code)
);

CREATE TABLE product_categories (
  product_id    UUID NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
  category_id   UUID NOT NULL REFERENCES categories(category_id) ON DELETE CASCADE,
  PRIMARY KEY (product_id, category_id)
);

-- Lightweight reference/cache over an LMS learning entity. Owns NO learning logic.
-- resource_type is free text, e.g. 'course' | 'diploma_module' | 'live_session' | 'exam_reference'
CREATE TABLE resources (
  resource_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  resource_type            TEXT NOT NULL,
  lms_reference_id         TEXT NOT NULL,             -- LMS course_id
  cached_title              TEXT,
  cached_instructor_name    TEXT,
  cached_duration_minutes   INTEGER,
  cached_modules_count      INTEGER,
  publishing_status         TEXT,                     -- mirrors LMS publish state
  last_synced_at             TIMESTAMPTZ,
  UNIQUE (resource_type, lms_reference_id)
);

-- Many-to-many: a Resource can back multiple Products, a Product (Diploma/Bundle)
-- can bundle multiple Resources.
CREATE TABLE product_resources (
  product_id    UUID NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
  resource_id   UUID NOT NULL REFERENCES resources(resource_id) ON DELETE CASCADE,
  sort_order    INTEGER NOT NULL,
  PRIMARY KEY (product_id, resource_id)
);

-- Bundle composition: which products make up a bundle product.
-- (bundle_product_id != member_product_id is validated in the backend.)
CREATE TABLE bundle_items (
  bundle_product_id   UUID NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
  member_product_id   UUID NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
  PRIMARY KEY (bundle_product_id, member_product_id)
);

CREATE TABLE customer_wishlists (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id  UUID NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
  product_id   UUID NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
  added_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (customer_id, product_id)
);


-- =====================================================================
-- 04. COMMERCE ENGINE
-- =====================================================================

-- Geo/segment-aware pricing. NULL country_code = global default price.
CREATE TABLE prices (
  price_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id           UUID NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
  country_code         CHAR(2) REFERENCES countries(country_code),
  currency_code        CHAR(3) NOT NULL REFERENCES currencies(currency_code),
  amount                NUMERIC(10,2) NOT NULL,
  compare_at_amount     NUMERIC(10,2),
  valid_from            TIMESTAMPTZ NOT NULL,
  valid_to              TIMESTAMPTZ,
  UNIQUE (product_id, country_code, currency_code, valid_from)
);

-- promotion_type is free text, e.g. 'percentage' | 'fixed' | 'bundle_discount' |
--   'buy_x_get_y' | 'free_product' | 'free_consultation'
CREATE TABLE promotions (
  promotion_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code               TEXT UNIQUE,                     -- NULL for automatic/campaign promotions
  promotion_type     TEXT NOT NULL,
  value               NUMERIC(10,2),                    -- percentage or fixed amount
  conditions           JSONB NOT NULL,                   -- cart_threshold, new_customers_only, category_ids...
  usage_limit           INTEGER,
  per_customer_limit    INTEGER,
  starts_at              TIMESTAMPTZ,
  ends_at                 TIMESTAMPTZ,
  is_active                BOOLEAN NOT NULL,
  created_at                TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE promotion_redemptions (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  promotion_id   UUID NOT NULL REFERENCES promotions(promotion_id),
  customer_id    UUID NOT NULL REFERENCES customers(customer_id),
  order_id       UUID,                               -- FK added after orders table
  redeemed_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- cart status is free text, e.g. 'active' | 'converted' | 'abandoned'
CREATE TABLE carts (
  cart_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id    UUID REFERENCES customers(customer_id),   -- nullable: pre-login cart
  currency_code  CHAR(3) NOT NULL REFERENCES currencies(currency_code),
  status         TEXT NOT NULL,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE cart_items (
  cart_item_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  cart_id        UUID NOT NULL REFERENCES carts(cart_id) ON DELETE CASCADE,
  product_id     UUID NOT NULL REFERENCES products(product_id),
  unit_price     NUMERIC(10,2) NOT NULL,
  quantity       INTEGER NOT NULL,
  added_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (cart_id, product_id)
);

-- order status is free text, e.g. 'pending' | 'paid' | 'payment_failed' |
--   'refunded' | 'partially_refunded' | 'cancelled'
CREATE TABLE orders (
  order_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id            UUID NOT NULL REFERENCES customers(customer_id),
  status                  TEXT NOT NULL,
  currency_code            CHAR(3) NOT NULL REFERENCES currencies(currency_code),
  subtotal_amount           NUMERIC(10,2) NOT NULL,
  discount_amount            NUMERIC(10,2) NOT NULL,
  tax_amount                  NUMERIC(10,2) NOT NULL,
  total_amount                  NUMERIC(10,2) NOT NULL,
  applied_promotion_id             UUID REFERENCES promotions(promotion_id),
  placed_at                          TIMESTAMPTZ,
  created_at                           TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE promotion_redemptions
  ADD CONSTRAINT fk_promo_redemption_order FOREIGN KEY (order_id) REFERENCES orders(order_id);

CREATE TABLE order_items (
  order_item_id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id         UUID NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
  product_id       UUID NOT NULL REFERENCES products(product_id),
  unit_price       NUMERIC(10,2) NOT NULL,
  quantity         INTEGER NOT NULL,
  product_snapshot JSONB NOT NULL                     -- title/price captured at purchase time
);

-- provider is free text, e.g. 'stripe' | 'tabby' | 'tamara' | 'wallet'
-- status is free text, e.g. 'pending' | 'succeeded' | 'failed' | 'refunded' | 'partially_refunded'
CREATE TABLE payments (
  payment_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id               UUID NOT NULL REFERENCES orders(order_id),
  provider                 TEXT NOT NULL,
  provider_payment_id       TEXT,
  external_event_id          TEXT UNIQUE,               -- idempotency key from provider webhook
  status                       TEXT NOT NULL,
  amount                         NUMERIC(10,2) NOT NULL,
  currency_code                    CHAR(3) NOT NULL REFERENCES currencies(currency_code),
  wallet_amount_used                 NUMERIC(10,2) NOT NULL,   -- mixed payment: wallet + gateway
  processed_at                         TIMESTAMPTZ,
  created_at                             TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE invoices (
  invoice_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id             UUID NOT NULL REFERENCES orders(order_id),
  provider_invoice_id  TEXT,                          -- Stripe invoice id
  pdf_url              TEXT,
  issued_at            TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- refund status is free text, e.g. 'pending' | 'succeeded' | 'failed'
CREATE TABLE refunds (
  refund_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id       UUID NOT NULL REFERENCES orders(order_id),
  payment_id     UUID NOT NULL REFERENCES payments(payment_id),
  amount         NUMERIC(10,2) NOT NULL,
  reason         TEXT,
  status         TEXT NOT NULL,
  processed_by   UUID,                                  -- admin user id
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);


-- =====================================================================
-- 05. ENTITLEMENT & FULFILLMENT
--     Purchase != Access. This is the single source of truth for "can this
--     customer access this product right now" — evaluated by the backend
--     from these rows, not by any DB-side rule.
-- =====================================================================
-- source_type is free text, e.g. 'order' | 'subscription' | 'free_grant' | 'admin_grant'
-- status is free text, e.g. 'active' | 'expired' | 'revoked'
CREATE TABLE entitlements (
  entitlement_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id      UUID NOT NULL REFERENCES customers(customer_id),
  product_id       UUID NOT NULL REFERENCES products(product_id),
  source_type      TEXT NOT NULL,
  source_id        UUID NOT NULL,                       -- order_id / subscription_id / admin grant id
  status           TEXT NOT NULL,
  starts_at        TIMESTAMPTZ NOT NULL,
  expires_at       TIMESTAMPTZ,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE entitlement_extensions (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  entitlement_id  UUID NOT NULL REFERENCES entitlements(entitlement_id) ON DELETE CASCADE,
  extended_days   INTEGER NOT NULL,
  price_paid      NUMERIC(10,2),
  order_id        UUID REFERENCES orders(order_id),
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Tracks async hand-off to LMS / Consultation / Community after payment succeeds.
-- target_system is free text, e.g. 'lms_enrollment' | 'consultation_access' | 'community_access'
-- status is free text, e.g. 'pending' | 'success' | 'failed'
CREATE TABLE fulfillments (
  fulfillment_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  entitlement_id   UUID NOT NULL REFERENCES entitlements(entitlement_id) ON DELETE CASCADE,
  target_system    TEXT NOT NULL,
  status           TEXT NOT NULL,
  retry_count      INTEGER NOT NULL,
  last_error       TEXT,
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);


-- =====================================================================
-- 06. SUBSCRIPTION ENGINE
-- =====================================================================
CREATE TABLE subscription_plans (
  plan_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id        UUID NOT NULL REFERENCES products(product_id),  -- the sellable subscription product
  billing_interval  TEXT NOT NULL,                       -- 'monthly' | 'annual'
  price              NUMERIC(10,2) NOT NULL,
  currency_code       CHAR(3) NOT NULL REFERENCES currencies(currency_code),
  status               TEXT NOT NULL
);

-- benefit_type is free text, e.g. 'fixed_content' | 'choice_allowance' |
--   'catalog_access' | 'consultation_credits' | 'live_program' | 'certificate' | 'discount'
CREATE TABLE subscription_plan_benefits (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  plan_id      UUID NOT NULL REFERENCES subscription_plans(plan_id) ON DELETE CASCADE,
  benefit_type TEXT NOT NULL,
  config       JSONB NOT NULL   -- e.g. {"choose": 10, "library_category_id": "..."} / {"sessions": 2}
);

-- status is free text, e.g. 'active' | 'past_due' | 'canceled' | 'expired'
CREATE TABLE subscriptions (
  subscription_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id          UUID NOT NULL REFERENCES customers(customer_id),
  plan_id              UUID NOT NULL REFERENCES subscription_plans(plan_id),
  status               TEXT NOT NULL,
  current_period_start TIMESTAMPTZ NOT NULL,
  current_period_end   TIMESTAMPTZ NOT NULL,
  auto_renew           BOOLEAN NOT NULL,
  canceled_at          TIMESTAMPTZ,
  created_at           TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE subscription_benefit_usage (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  subscription_id  UUID NOT NULL REFERENCES subscriptions(subscription_id) ON DELETE CASCADE,
  benefit_type     TEXT NOT NULL,
  used_count       INTEGER NOT NULL,
  period_start     TIMESTAMPTZ NOT NULL,
  period_end       TIMESTAMPTZ NOT NULL
);


-- =====================================================================
-- 07. CONSULTATION MARKETPLACE
-- =====================================================================
CREATE TABLE consultants (
  consultant_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  instructor_id   UUID REFERENCES instructors(instructor_id),
  bio             TEXT,
  expertise       JSONB NOT NULL,
  status          TEXT NOT NULL
);

CREATE TABLE consultation_services (
  service_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  consultant_id    UUID NOT NULL REFERENCES consultants(consultant_id) ON DELETE CASCADE,
  product_id       UUID NOT NULL REFERENCES products(product_id),   -- pricing/checkout lives on the product
  duration_minutes INTEGER NOT NULL,
  is_active        BOOLEAN NOT NULL
);

-- Row existing + FK from a booking is how "double booking" is prevented at
-- the data layer; the atomic check/transaction itself is backend logic.
CREATE TABLE consultant_availability_slots (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  consultant_id  UUID NOT NULL REFERENCES consultants(consultant_id) ON DELETE CASCADE,
  starts_at      TIMESTAMPTZ NOT NULL,
  ends_at        TIMESTAMPTZ NOT NULL,
  timezone       TEXT NOT NULL,
  is_booked      BOOLEAN NOT NULL,
  UNIQUE (consultant_id, starts_at)
);

-- status is free text, e.g. 'pending_payment' | 'confirmed' | 'rescheduled' |
--   'completed' | 'no_show' | 'cancelled_by_customer' | 'cancelled_by_consultant'
CREATE TABLE consultation_bookings (
  booking_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  service_id       UUID NOT NULL REFERENCES consultation_services(service_id),
  customer_id      UUID NOT NULL REFERENCES customers(customer_id),
  order_id         UUID REFERENCES orders(order_id),
  slot_id          UUID NOT NULL REFERENCES consultant_availability_slots(id),
  status           TEXT NOT NULL,
  meeting_url      TEXT,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE consultation_booking_events (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  booking_id   UUID NOT NULL REFERENCES consultation_bookings(booking_id) ON DELETE CASCADE,
  event_type   TEXT NOT NULL,       -- e.g. 'rescheduled' | 'cancelled_by_customer' | 'reminder_sent'
  actor_id     UUID,
  note         TEXT,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);


-- =====================================================================
-- 08. COMMUNITY
-- =====================================================================
CREATE TABLE community_spaces (
  space_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name         TEXT NOT NULL,
  space_type   TEXT NOT NULL,        -- 'general' | 'product_cohort'
  product_id   UUID REFERENCES products(product_id),   -- set when space_type = product_cohort
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE community_memberships (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  space_id        UUID NOT NULL REFERENCES community_spaces(space_id) ON DELETE CASCADE,
  customer_id     UUID NOT NULL REFERENCES customers(customer_id),
  entitlement_id  UUID REFERENCES entitlements(entitlement_id),   -- why this member has access
  joined_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (space_id, customer_id)
);


-- =====================================================================
-- 09. GROWTH & LOYALTY (Referral / Wallet / Rewards)
-- =====================================================================
CREATE TABLE referral_codes (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id   UUID NOT NULL UNIQUE REFERENCES customers(customer_id),
  code          TEXT UNIQUE NOT NULL,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- event_type is free text, e.g. 'click' | 'signup' | 'purchase'
-- status is free text, e.g. 'pending' | 'approved' | 'paid'
CREATE TABLE referral_events (
  id                     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  referrer_customer_id   UUID NOT NULL REFERENCES customers(customer_id),
  referred_customer_id   UUID REFERENCES customers(customer_id),   -- NULL until signup happens
  event_type             TEXT NOT NULL,
  order_id               UUID REFERENCES orders(order_id),
  commission_amount      NUMERIC(10,2),
  status                 TEXT NOT NULL,
  created_at             TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE wallets (
  wallet_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id        UUID NOT NULL UNIQUE REFERENCES customers(customer_id),
  available_balance  NUMERIC(10,2) NOT NULL,
  pending_balance     NUMERIC(10,2) NOT NULL,
  currency_code        CHAR(3) NOT NULL REFERENCES currencies(currency_code)
);

-- txn_type is free text, e.g. 'topup' | 'refund_credit' | 'purchase_debit' |
--   'referral_credit' | 'admin_adjustment'
CREATE TABLE wallet_transactions (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  wallet_id         UUID NOT NULL REFERENCES wallets(wallet_id) ON DELETE CASCADE,
  txn_type          TEXT NOT NULL,
  amount            NUMERIC(10,2) NOT NULL,        -- positive = credit, negative = debit
  balance_after     NUMERIC(10,2) NOT NULL,
  related_order_id  UUID REFERENCES orders(order_id),
  created_by        UUID,                            -- admin user id, if manual
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE reward_points_accounts (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id     UUID NOT NULL UNIQUE REFERENCES customers(customer_id),
  points_balance  INTEGER NOT NULL
);

-- txn_type is free text, e.g. 'earn' | 'redeem' | 'expire' | 'admin_adjustment'
CREATE TABLE reward_points_transactions (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  account_id        UUID NOT NULL REFERENCES reward_points_accounts(id) ON DELETE CASCADE,
  txn_type          TEXT NOT NULL,
  points            INTEGER NOT NULL,               -- positive = earn, negative = redeem/expire
  related_order_id  UUID REFERENCES orders(order_id),
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);


-- =====================================================================
-- 10. REVIEWS
-- =====================================================================
-- rating range (1-5) is validated in the backend, not as a DB CHECK.
-- status is free text, e.g. 'pending' | 'published' | 'hidden'
CREATE TABLE reviews (
  review_id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id   UUID NOT NULL REFERENCES products(product_id),
  customer_id  UUID NOT NULL REFERENCES customers(customer_id),
  rating       SMALLINT NOT NULL,
  comment      TEXT,
  status       TEXT NOT NULL,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (product_id, customer_id)
);


-- =====================================================================
-- 11. LANDING PAGES & MERCHANDISING
--     Database is the source of truth for landing-page content, sections,
--     and geo-targeted overrides (drives full CRUD from B2C Admin).
-- =====================================================================
-- page_type is free text, e.g. 'home' | 'campaign' | 'category' | 'instructor'
-- status is free text, e.g. 'draft' | 'published'
CREATE TABLE landing_pages (
  page_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug          TEXT UNIQUE NOT NULL,
  page_type     TEXT NOT NULL,
  status        TEXT NOT NULL,
  published_at  TIMESTAMPTZ,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE landing_page_translations (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  page_id       UUID NOT NULL REFERENCES landing_pages(page_id) ON DELETE CASCADE,
  locale_code   TEXT NOT NULL REFERENCES locales(locale_code),
  title         TEXT NOT NULL,
  seo_meta      JSONB NOT NULL,
  UNIQUE (page_id, locale_code)
);

-- Ordered, configurable sections: hero, courses, diplomas, bundles,
-- consulting, subscription_plans, social_proof, instructor_cta, faq...
CREATE TABLE landing_page_sections (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  page_id       UUID NOT NULL REFERENCES landing_pages(page_id) ON DELETE CASCADE,
  section_type  TEXT NOT NULL,
  sort_order    INTEGER NOT NULL,
  config        JSONB NOT NULL,    -- e.g. {"product_filter": "trending", "limit": 8}
  is_active     BOOLEAN NOT NULL
);

-- Geo-targeted content/pricing overrides for a page or a section.
CREATE TABLE geo_content_overrides (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  page_id        UUID REFERENCES landing_pages(page_id) ON DELETE CASCADE,
  section_id     UUID REFERENCES landing_page_sections(id) ON DELETE CASCADE,
  country_code   CHAR(2) NOT NULL REFERENCES countries(country_code),
  override_content JSONB NOT NULL,
  UNIQUE (page_id, section_id, country_code)
);

CREATE TABLE campaigns (
  campaign_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name            TEXT NOT NULL,
  landing_page_id UUID REFERENCES landing_pages(page_id),
  utm_source      TEXT,
  utm_campaign    TEXT,
  starts_at       TIMESTAMPTZ,
  ends_at         TIMESTAMPTZ
);


-- =====================================================================
-- 12. AI / RAG (optional, for later AI-layer retrieval & embedding)
--     B2C-owned: Advisor / Semantic Search / Roadmap Planner / Bundle Builder.
--     Does NOT index in-lesson content owned by the LMS AI Tutor.
-- =====================================================================
-- source_type is free text, e.g. 'product' | 'resource' | 'faq' |
--   'consultant_bio' | 'landing_page_section'
CREATE TABLE ai_documents (
  document_id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  source_type    TEXT NOT NULL,
  source_id      UUID NOT NULL,
  locale_code    TEXT REFERENCES locales(locale_code),
  content_text   TEXT NOT NULL,
  updated_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE ai_embeddings (
  embedding_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  document_id    UUID NOT NULL REFERENCES ai_documents(document_id) ON DELETE CASCADE,
  chunk_index    INTEGER NOT NULL,
  chunk_text     TEXT NOT NULL,
  embedding      vector(1536) NOT NULL,     -- adjust dimension to embedding model used
  model_name     TEXT NOT NULL,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);
-- Approximate nearest-neighbor index for retrieval at query time (performance,
-- not business logic).
CREATE INDEX ai_embeddings_ivfflat_idx ON ai_embeddings
  USING ivfflat (embedding vector_cosine_ops) WITH (lists = 100);

-- channel is free text, e.g. 'advisor' | 'semantic_search' | 'roadmap_planner' | 'bundle_builder'
CREATE TABLE ai_conversations (
  conversation_id  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id      UUID REFERENCES customers(customer_id),   -- nullable: guest advisor session
  channel          TEXT NOT NULL,
  started_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- role is free text, e.g. 'user' | 'assistant'
CREATE TABLE ai_messages (
  message_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id  UUID NOT NULL REFERENCES ai_conversations(conversation_id) ON DELETE CASCADE,
  role             TEXT NOT NULL,
  content          TEXT NOT NULL,
  retrieved_document_ids UUID[],       -- which ai_documents backed this answer
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- context_type is free text, e.g. 'home_suggestions' | 'roadmap' | 'bundle_builder' | 'search'
CREATE TABLE ai_recommendation_logs (
  id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id             UUID REFERENCES customers(customer_id),
  context_type            TEXT NOT NULL,
  recommended_product_ids UUID[] NOT NULL,
  accepted_product_id     UUID REFERENCES products(product_id),   -- outcome tracking
  created_at              TIMESTAMPTZ NOT NULL DEFAULT now()
);


-- =====================================================================
-- 13. PLATFORM: AUDIT LOG, WEBHOOKS INBOX, OBSERVABILITY
-- =====================================================================
-- actor_type is free text, e.g. 'admin' | 'system'
CREATE TABLE audit_logs (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  actor_type   TEXT NOT NULL,
  actor_id     UUID,
  action       TEXT NOT NULL,          -- e.g. 'price.updated' | 'refund.issued' | 'coupon.disabled'
  entity_type  TEXT NOT NULL,
  entity_id    UUID NOT NULL,
  before_state JSONB,
  after_state  JSONB,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Idempotent inbox for every external event (Stripe, LMS, Tabby, Tamara, Tolt).
-- source is free text, e.g. 'stripe' | 'lms' | 'tabby' | 'tamara' | 'tolt'
-- status is free text, e.g. 'received' | 'processed' | 'failed'
CREATE TABLE webhooks_inbox (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  source            TEXT NOT NULL,
  event_type        TEXT NOT NULL,
  external_event_id TEXT NOT NULL,
  payload           JSONB NOT NULL,
  status            TEXT NOT NULL,
  received_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  processed_at      TIMESTAMPTZ,
  UNIQUE (source, external_event_id)
);

-- status is free text, e.g. 'success' | 'failed'
CREATE TABLE lms_api_call_logs (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  request_id    UUID NOT NULL,
  operation     TEXT NOT NULL,          -- getCourse | createEnrollment | getProgress ...
  target_id     TEXT,                   -- lms course_id / user_id involved
  status        TEXT NOT NULL,
  duration_ms   INTEGER,
  error_message TEXT,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);


-- =====================================================================
-- INDEXES (query performance only — not business rules)
-- =====================================================================
CREATE INDEX idx_products_type_status      ON products(product_type, status);
CREATE INDEX idx_prices_product_country    ON prices(product_id, country_code);
CREATE INDEX idx_orders_customer_status    ON orders(customer_id, status);
CREATE INDEX idx_entitlements_customer     ON entitlements(customer_id, status);
CREATE INDEX idx_entitlements_product      ON entitlements(product_id);
CREATE INDEX idx_fulfillments_status       ON fulfillments(status);
CREATE INDEX idx_bookings_customer         ON consultation_bookings(customer_id, status);
CREATE INDEX idx_wallet_txn_wallet         ON wallet_transactions(wallet_id, created_at);
CREATE INDEX idx_referral_events_referrer  ON referral_events(referrer_customer_id, event_type);
CREATE INDEX idx_reviews_product           ON reviews(product_id, status);
CREATE INDEX idx_landing_sections_page     ON landing_page_sections(page_id, sort_order);