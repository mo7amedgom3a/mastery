-- =============================================================================
-- MASTERY ACADEMY B2C — COMPLETE ENTERPRISE RELATIONAL DATABASE SCHEMA (DDL)
-- =============================================================================
-- Target Database : PostgreSQL 15+
-- Extensions      : uuid-ossp, pgcrypto, vector (pgvector)
-- Architecture    : Dual Abstraction (Resource & Customer), Decoupled Core Spine
-- Purpose         : Pure Normalized Relational Data Layer for B2C Digital Learning Commerce
-- Note            : NO backend business logic, orchestration, or workflows reside in this DDL.
--                   All business orchestration is handled by modular backend services.
-- =============================================================================

-- Enable Required Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "vector";

-- =============================================================================
-- DOMAIN 1: GEOGRAPHIC ROUTING, CURRENCIES & LOCALIZED TAX
-- =============================================================================

-- 1.1 Supported Platform Currencies
CREATE TABLE currencies (
    currency_code VARCHAR(3) PRIMARY KEY, -- ISO 4217 code (USD, SAR, AED, EGP, KWD, etc.)
    currency_name_ar VARCHAR(50) NOT NULL,
    currency_name_en VARCHAR(50) NOT NULL,
    symbol VARCHAR(10) NOT NULL, -- e.g. '$', 'ر.س', 'د.إ', 'ج.م'
    exchange_rate_to_usd NUMERIC(12,6) NOT NULL DEFAULT 1.000000 CHECK (exchange_rate_to_usd > 0),
    is_supported_checkout BOOLEAN NOT NULL DEFAULT TRUE,
    decimal_places SMALLINT NOT NULL DEFAULT 2 CHECK (decimal_places BETWEEN 0 AND 4),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE currencies IS 'System-wide currency master table with exchange rates to USD baseline.';

-- 1.2 Countries, Geo Routing, VAT & Tax Configuration
CREATE TABLE geo_countries (
    country_code VARCHAR(2) PRIMARY KEY, -- ISO 3166-1 alpha-2 (e.g. 'SA', 'AE', 'EG', 'US')
    country_name_ar VARCHAR(100) NOT NULL,
    country_name_en VARCHAR(100) NOT NULL,
    default_currency_code VARCHAR(3) NOT NULL REFERENCES currencies(currency_code) ON DELETE RESTRICT,
    vat_percentage NUMERIC(5,2) NOT NULL DEFAULT 0.00 CHECK (vat_percentage >= 0),
    is_vat_inclusive BOOLEAN NOT NULL DEFAULT FALSE,
    stripe_tax_code VARCHAR(50), -- Stripe Tax integration code
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE geo_countries IS 'Source of truth for geo-routing, localized currencies, and official VAT tax calculation.';

-- =============================================================================
-- DOMAIN 2: CUSTOMER IDENTITY & ACCOUNTS (CUST)
-- =============================================================================

-- 2.1 Customer Commercial Identity (Student -> Customer Abstraction)
CREATE TABLE customers (
    customer_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    lms_user_id VARCHAR(100) UNIQUE, -- Mapped Reference to Existing LMS Student Account (NULLable before first enrollment)
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(30) UNIQUE,
    full_name_ar VARCHAR(150),
    full_name_en VARCHAR(150),
    country_code VARCHAR(2) REFERENCES geo_countries(country_code) ON DELETE RESTRICT,
    preferred_currency_code VARCHAR(3) REFERENCES currencies(currency_code) ON DELETE RESTRICT DEFAULT 'USD',
    rewards_points_balance INT NOT NULL DEFAULT 0 CHECK (rewards_points_balance >= 0),
    acquisition_source VARCHAR(100), -- UTM source, organic, campaign
    affiliate_referral_code VARCHAR(100), -- Tolt affiliate partner referral tracking
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE customers IS 'Customer Commercial Entity. Completely decoupled from LMS course progress and exam data.';
CREATE INDEX idx_customers_lms_user_id ON customers(lms_user_id);
CREATE INDEX idx_customers_email ON customers(email);
CREATE INDEX idx_customers_phone ON customers(phone_number);

-- 2.2 Passwordless Auth Identities (Email OTP, SMS OTP, Google Sign-In)
CREATE TABLE customer_auth_identities (
    identity_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
    provider VARCHAR(30) NOT NULL CHECK (provider IN ('EMAIL_OTP', 'PHONE_OTP', 'GOOGLE')),
    provider_uid VARCHAR(255) NOT NULL, -- Email, phone, or Google sub ID
    last_authenticated_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_auth_provider_uid UNIQUE (provider, provider_uid)
);

COMMENT ON TABLE customer_auth_identities IS 'Passwordless multi-channel authentication records for customer accounts.';
CREATE INDEX idx_auth_identities_customer ON customer_auth_identities(customer_id);

-- 2.3 Learner Skill Graph & Onboarding Goals
CREATE TABLE customer_skill_profiles (
    profile_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID UNIQUE NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
    current_job_title VARCHAR(150),
    target_career_role VARCHAR(150),
    experience_level VARCHAR(50) CHECK (experience_level IN ('STUDENT', 'ENTRY', 'MID', 'SENIOR', 'EXECUTIVE', 'FREELANCER', 'ENTREPRENEUR')),
    weekly_study_hours INT CHECK (weekly_study_hours >= 0),
    skills_of_interest JSONB NOT NULL DEFAULT '[]'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE customer_skill_profiles IS 'Customer career goals and onboarding survey data for AI recommendation and roadmap planning.';

-- 2.4 Physical Shipping Addresses (For Luxury Printed Certificates & CPD)
CREATE TABLE customer_addresses (
    address_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
    recipient_name VARCHAR(150) NOT NULL,
    recipient_phone VARCHAR(30) NOT NULL,
    country_code VARCHAR(2) NOT NULL REFERENCES geo_countries(country_code) ON DELETE RESTRICT,
    city VARCHAR(100) NOT NULL,
    state_province VARCHAR(100),
    street_address_1 VARCHAR(255) NOT NULL,
    street_address_2 VARCHAR(255),
    postal_code VARCHAR(20),
    is_default BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE customer_addresses IS 'Physical delivery addresses for printed certificates and merchandise.';
CREATE INDEX idx_addresses_customer ON customer_addresses(customer_id);

-- =============================================================================
-- DOMAIN 3: LMS RESOURCE ABSTRACTION LAYER (LMSI / CAT)
-- =============================================================================

-- 3.1 LMS Learning Resource Abstraction (Course != Commercial Product)
CREATE TABLE lms_resources (
    resource_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    lms_course_id VARCHAR(100) UNIQUE NOT NULL, -- Canonical Course Reference in existing LMS Core Engine
    resource_type VARCHAR(50) NOT NULL DEFAULT 'COURSE' CHECK (resource_type IN ('COURSE', 'DIPLOMA_MODULE', 'ASSESSMENT_REF', 'LIVE_SESSION_REF')),
    cached_title_ar VARCHAR(255),
    cached_instructor_name VARCHAR(150),
    cached_total_duration_minutes INT DEFAULT 0 CHECK (cached_total_duration_minutes >= 0),
    cached_lesson_count INT DEFAULT 0 CHECK (cached_lesson_count >= 0),
    cached_metadata JSONB NOT NULL DEFAULT '{}'::jsonb, -- Modules, syllabus overview, cached thumbnail
    is_lms_active BOOLEAN NOT NULL DEFAULT TRUE,
    last_synced_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE lms_resources IS 'Lightweight abstraction of LMS courses. Separates educational content from commercial product pricing.';
CREATE INDEX idx_lms_resources_course_id ON lms_resources(lms_course_id);

-- 3.2 LMS Inbound Event Audit Log (For sync contracts & idempotency)
CREATE TABLE lms_sync_event_logs (
    event_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_type VARCHAR(100) NOT NULL, -- 'course.updated', 'course.started', 'course.completed', 'certificate.issued'
    lms_user_id VARCHAR(100),
    lms_course_id VARCHAR(100),
    external_event_id VARCHAR(255) UNIQUE NOT NULL, -- Strict Idempotency Key
    event_payload JSONB NOT NULL,
    processed_status VARCHAR(30) NOT NULL DEFAULT 'PENDING' CHECK (processed_status IN ('PENDING', 'PROCESSED', 'FAILED', 'IGNORED')),
    error_message TEXT,
    received_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    processed_at TIMESTAMPTZ
);

COMMENT ON TABLE lms_sync_event_logs IS 'Audit ledger of webhooks and state events received from the LMS engine.';
CREATE INDEX idx_lms_sync_status ON lms_sync_event_logs(processed_status, received_at);

-- =============================================================================
-- DOMAIN 4: INSTRUCTORS & PLATFORM EXPERTS (CAT / CONS)
-- =============================================================================

-- 4.1 Platform Instructors & Advisory Consultants
CREATE TABLE platform_experts (
    expert_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    slug VARCHAR(150) UNIQUE NOT NULL,
    full_name_ar VARCHAR(150) NOT NULL,
    full_name_en VARCHAR(150),
    professional_title_ar VARCHAR(150),
    professional_title_en VARCHAR(150),
    short_bio_ar TEXT,
    full_bio_ar TEXT,
    avatar_url VARCHAR(500),
    cover_image_url VARCHAR(500),
    is_instructor BOOLEAN NOT NULL DEFAULT TRUE,
    is_consultant BOOLEAN NOT NULL DEFAULT FALSE,
    consultation_hourly_rate_usd NUMERIC(10,2) CHECK (consultation_hourly_rate_usd >= 0),
    consultation_default_duration_min INT NOT NULL DEFAULT 60 CHECK (consultation_default_duration_min > 0),
    google_calendar_email VARCHAR(255),
    timezone VARCHAR(50) NOT NULL DEFAULT 'Asia/Riyadh',
    social_links JSONB NOT NULL DEFAULT '{}'::jsonb,
    sort_order INT NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE platform_experts IS 'Master profiles for course instructors and professional 1-on-1 consultants.';
CREATE INDEX idx_experts_slug ON platform_experts(slug);
CREATE INDEX idx_experts_active ON platform_experts(is_active, is_consultant);

-- 4.2 Expert Weekly Availability Rules
CREATE TABLE expert_availability_rules (
    rule_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    expert_id UUID NOT NULL REFERENCES platform_experts(expert_id) ON DELETE CASCADE,
    day_of_week SMALLINT NOT NULL CHECK (day_of_week BETWEEN 0 AND 6), -- 0=Sunday, 6=Saturday
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT chk_slot_time_order CHECK (start_time < end_time)
);

COMMENT ON TABLE expert_availability_rules IS 'Recurring weekly working hours for 1-on-1 consultation bookings.';
CREATE INDEX idx_expert_rules ON expert_availability_rules(expert_id, day_of_week);

-- 4.3 Expert Availability Date Overrides (Blocked Dates & Special Slots)
CREATE TABLE expert_availability_overrides (
    override_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    expert_id UUID NOT NULL REFERENCES platform_experts(expert_id) ON DELETE CASCADE,
    override_date DATE NOT NULL,
    override_type VARCHAR(20) NOT NULL CHECK (override_type IN ('BLOCKED', 'CUSTOM_SLOT')),
    start_time TIME,
    end_time TIME,
    notes VARCHAR(255),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_override_slot CHECK (
        (override_type = 'BLOCKED') OR
        (override_type = 'CUSTOM_SLOT' AND start_time IS NOT NULL AND end_time IS NOT NULL AND start_time < end_time)
    )
);

COMMENT ON TABLE expert_availability_overrides IS 'Specific date exceptions, vacations, and custom consultation hours.';
CREATE INDEX idx_expert_overrides ON expert_availability_overrides(expert_id, override_date);

-- =============================================================================
-- DOMAIN 5: CATALOG & COMMERCIAL PRODUCTS (CAT)
-- =============================================================================

-- 5.1 Catalog Taxonomies & Categories
CREATE TABLE product_categories (
    category_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    slug VARCHAR(100) UNIQUE NOT NULL,
    name_ar VARCHAR(150) NOT NULL,
    name_en VARCHAR(150),
    description_ar TEXT,
    parent_category_id UUID REFERENCES product_categories(category_id) ON DELETE SET NULL,
    icon_url VARCHAR(500),
    sort_order INT NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE product_categories IS 'Hierarchical taxonomy for commercial product discovery and filtering.';
CREATE INDEX idx_categories_slug ON product_categories(slug);

-- 5.2 Commercial Catalog Products
CREATE TABLE catalog_products (
    product_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_type VARCHAR(50) NOT NULL CHECK (product_type IN (
        'COURSE',          -- Single asynchronous online course (365 days default access)
        'DIPLOMA',         -- Comprehensive professional diploma
        'LIVE_COHORT',     -- Synchronous cohort-based interactive program
        'BUNDLE',          -- Composite bundle combining multiple items
        'SUBSCRIPTION',    -- Recurring membership or library subscription
        'CONSULTATION',    -- 1-on-1 expert advisory consultation
        'COMMUNITY',       -- Standalone Mastery community membership
        'ADDON'            -- Physical certificate, printed CPD accreditation, etc.
    )),
    slug VARCHAR(180) UNIQUE NOT NULL,
    title_ar VARCHAR(255) NOT NULL,
    title_en VARCHAR(255),
    subtitle_ar VARCHAR(255),
    short_description_ar TEXT,
    full_description_ar TEXT,
    category_id UUID REFERENCES product_categories(category_id) ON DELETE SET NULL,
    primary_expert_id UUID REFERENCES platform_experts(expert_id) ON DELETE SET NULL,
    thumbnail_url VARCHAR(500),
    promo_video_url VARCHAR(500),
    difficulty_level VARCHAR(30) CHECK (difficulty_level IN ('BEGINNER', 'INTERMEDIATE', 'ADVANCED', 'ALL_LEVELS')),
    target_career_level VARCHAR(50),
    estimated_duration_hours INT CHECK (estimated_duration_hours >= 0),
    has_cpd_accreditation BOOLEAN NOT NULL DEFAULT FALSE,
    status VARCHAR(30) NOT NULL DEFAULT 'DRAFT' CHECK (status IN ('DRAFT', 'PUBLISHED', 'UNPUBLISHED', 'ARCHIVED')),
    published_at TIMESTAMPTZ,
    seo_metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    sort_order INT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE catalog_products IS 'Commercial product catalog. Reusable wrapper decoupling sales terms from LMS resources.';
CREATE INDEX idx_products_slug ON catalog_products(slug);
CREATE INDEX idx_products_type_status ON catalog_products(product_type, status);
CREATE INDEX idx_products_category ON catalog_products(category_id);
CREATE INDEX idx_products_expert ON catalog_products(primary_expert_id);

-- 5.3 Product to LMS Resource Mappings (N:M mapping for courses & diplomas)
CREATE TABLE product_resource_mappings (
    mapping_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID NOT NULL REFERENCES catalog_products(product_id) ON DELETE CASCADE,
    resource_id UUID NOT NULL REFERENCES lms_resources(resource_id) ON DELETE CASCADE,
    sequence_order INT NOT NULL DEFAULT 1,
    is_mandatory BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT uq_product_resource UNIQUE (product_id, resource_id)
);

COMMENT ON TABLE product_resource_mappings IS 'Relational bridge connecting commercial products to one or more LMS course resources.';
CREATE INDEX idx_prm_product ON product_resource_mappings(product_id);
CREATE INDEX idx_prm_resource ON product_resource_mappings(resource_id);

-- 5.4 Composite Bundle Components
CREATE TABLE bundle_items (
    bundle_item_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    parent_bundle_product_id UUID NOT NULL REFERENCES catalog_products(product_id) ON DELETE CASCADE,
    child_product_id UUID NOT NULL REFERENCES catalog_products(product_id) ON DELETE RESTRICT,
    quantity INT NOT NULL DEFAULT 1 CHECK (quantity > 0),
    sort_order INT NOT NULL DEFAULT 0,
    CONSTRAINT uq_bundle_child UNIQUE (parent_bundle_product_id, child_product_id)
);

COMMENT ON TABLE bundle_items IS 'Components included in composite bundles (courses, diplomas, consultations, community).';
CREATE INDEX idx_bundle_parent ON bundle_items(parent_bundle_product_id);
CREATE INDEX idx_bundle_child ON bundle_items(child_product_id);

-- =============================================================================
-- DOMAIN 6: OFFERS, PRICING & LOCALIZED GEO ROUTING (COM / PRM)
-- =============================================================================

-- 6.1 Commercial Product Offers
CREATE TABLE product_offers (
    offer_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID NOT NULL REFERENCES catalog_products(product_id) ON DELETE CASCADE,
    offer_code VARCHAR(50) UNIQUE NOT NULL,
    offer_name_ar VARCHAR(150) NOT NULL,
    base_price_usd NUMERIC(10,2) NOT NULL CHECK (base_price_usd >= 0),
    compare_at_price_usd NUMERIC(10,2) CHECK (compare_at_price_usd >= base_price_usd),
    billing_type VARCHAR(30) NOT NULL DEFAULT 'ONE_TIME' CHECK (billing_type IN ('ONE_TIME', 'RECURRING')),
    billing_interval VARCHAR(20) CHECK (billing_interval IN ('MONTHLY', 'ANNUAL')),
    access_duration_days INT CHECK (access_duration_days > 0 OR access_duration_days IS NULL), -- NULL = Lifetime; Default is 365
    is_default BOOLEAN NOT NULL DEFAULT TRUE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    starts_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ends_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_offer_dates CHECK (ends_at IS NULL OR starts_at <= ends_at),
    CONSTRAINT chk_no_monthly_for_single_course CHECK (
        -- Global rule: Monthly purchases for single courses are barred (only recurring for subscriptions)
        NOT (billing_type = 'RECURRING' AND billing_interval = 'MONTHLY' AND access_duration_days IS NOT NULL)
    )
);

COMMENT ON TABLE product_offers IS 'Commercial pricing terms and access duration definitions for catalog products.';
CREATE INDEX idx_offers_product ON product_offers(product_id, is_active);

-- 6.2 Localized Geo Pricing Overrides
CREATE TABLE offer_geo_prices (
    geo_price_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    offer_id UUID NOT NULL REFERENCES product_offers(offer_id) ON DELETE CASCADE,
    currency_code VARCHAR(3) NOT NULL REFERENCES currencies(currency_code) ON DELETE RESTRICT,
    country_code VARCHAR(2) REFERENCES geo_countries(country_code) ON DELETE RESTRICT, -- NULL applies to any country using currency
    price_amount NUMERIC(12,2) NOT NULL CHECK (price_amount >= 0),
    compare_at_amount NUMERIC(12,2) CHECK (compare_at_amount >= price_amount),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_offer_geo UNIQUE NULLS NOT DISTINCT (offer_id, currency_code, country_code)
);

COMMENT ON TABLE offer_geo_prices IS 'Explicit localized pricing per country and currency overriding standard baseline.';
CREATE INDEX idx_geo_prices_offer ON offer_geo_prices(offer_id, currency_code, country_code);

-- 6.3 Dedicated Access Extension Offers (Rules: 3 Months, 12 Months, Lifetime)
CREATE TABLE access_extension_offers (
    extension_offer_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID REFERENCES catalog_products(product_id) ON DELETE CASCADE, -- NULL indicates platform-wide default
    duration_type VARCHAR(30) NOT NULL CHECK (duration_type IN ('3_MONTHS', '12_MONTHS', 'LIFETIME')),
    extension_days INT CHECK (
        (duration_type = '3_MONTHS' AND extension_days = 90) OR
        (duration_type = '12_MONTHS' AND extension_days = 365) OR
        (duration_type = 'LIFETIME' AND extension_days IS NULL)
    ),
    price_usd NUMERIC(10,2) NOT NULL CHECK (price_usd >= 0),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_product_extension_type UNIQUE NULLS NOT DISTINCT (product_id, duration_type)
);

COMMENT ON TABLE access_extension_offers IS 'Commercial extension packages for renewing course/diploma access after year 1.';

-- =============================================================================
-- DOMAIN 7: SHOPPING CARTS & WISHLISTS (COM)
-- =============================================================================

-- 7.1 Shopping Carts (Supports Guest Sessions & Merging)
CREATE TABLE shopping_carts (
    cart_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID REFERENCES customers(customer_id) ON DELETE CASCADE,
    session_token VARCHAR(255), -- Guest token prior to OTP login
    applied_coupon_id UUID, -- Foreign key reference applied at checkout
    rewards_points_to_redeem INT NOT NULL DEFAULT 0 CHECK (rewards_points_to_redeem >= 0),
    currency_code VARCHAR(3) NOT NULL REFERENCES currencies(currency_code) ON DELETE RESTRICT DEFAULT 'USD',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_cart_owner CHECK (customer_id IS NOT NULL OR session_token IS NOT NULL)
);

COMMENT ON TABLE shopping_carts IS 'Active shopping carts supporting anonymous visitors and seamless OTP cart merge.';
CREATE INDEX idx_carts_customer ON shopping_carts(customer_id);
CREATE INDEX idx_carts_session ON shopping_carts(session_token);

-- 7.2 Shopping Cart Items
CREATE TABLE cart_items (
    cart_item_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cart_id UUID NOT NULL REFERENCES shopping_carts(cart_id) ON DELETE CASCADE,
    offer_id UUID NOT NULL REFERENCES product_offers(offer_id) ON DELETE CASCADE,
    cohort_schedule_id UUID, -- Populated if Live Cohort is selected
    quantity INT NOT NULL DEFAULT 1 CHECK (quantity > 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_cart_item UNIQUE (cart_id, offer_id)
);

COMMENT ON TABLE cart_items IS 'Line items currently in the active shopping cart.';
CREATE INDEX idx_cart_items_cart ON cart_items(cart_id);

-- 7.3 Customer Wishlists
CREATE TABLE customer_wishlists (
    wishlist_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES catalog_products(product_id) ON DELETE CASCADE,
    added_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_customer_wishlist UNIQUE (customer_id, product_id)
);

COMMENT ON TABLE customer_wishlists IS 'Saved products and courses for future purchase consideration.';
CREATE INDEX idx_wishlists_customer ON customer_wishlists(customer_id);

-- =============================================================================
-- DOMAIN 8: ORDERS & DECOUPLED STATE MACHINE (COM - CORE SPINE)
-- =============================================================================

-- 8.1 Customer Orders
CREATE TABLE cust_orders (
    order_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_number VARCHAR(50) UNIQUE NOT NULL, -- Public order reference (e.g. 'ORD-2026-9812')
    customer_id UUID NOT NULL REFERENCES customers(customer_id) ON DELETE RESTRICT,
    
    -- Crucial Architectural Decoupling of the 3 State Dimensions
    order_status VARCHAR(30) NOT NULL DEFAULT 'CREATED' CHECK (order_status IN ('CREATED', 'CONFIRMED', 'COMPLETED', 'CANCELLED')),
    payment_status VARCHAR(30) NOT NULL DEFAULT 'PENDING' CHECK (payment_status IN ('PENDING', 'PAID', 'FAILED', 'REFUNDED', 'PARTIALLY_REFUNDED')),
    fulfillment_status VARCHAR(30) NOT NULL DEFAULT 'PENDING' CHECK (fulfillment_status IN ('PENDING', 'IN_PROGRESS', 'FULFILLED', 'PARTIALLY_FULFILLED', 'FAILED')),
    
    -- Currency and Financial Breakdown
    currency_code VARCHAR(3) NOT NULL REFERENCES currencies(currency_code) ON DELETE RESTRICT,
    country_code VARCHAR(2) REFERENCES geo_countries(country_code) ON DELETE RESTRICT,
    subtotal_amount NUMERIC(12,2) NOT NULL CHECK (subtotal_amount >= 0),
    coupon_discount_amount NUMERIC(12,2) NOT NULL DEFAULT 0.00 CHECK (coupon_discount_amount >= 0),
    rewards_discount_amount NUMERIC(12,2) NOT NULL DEFAULT 0.00 CHECK (rewards_discount_amount >= 0),
    tax_amount NUMERIC(12,2) NOT NULL DEFAULT 0.00 CHECK (tax_amount >= 0),
    total_amount NUMERIC(12,2) NOT NULL CHECK (total_amount >= 0),
    
    -- Rewards Points Participation
    rewards_points_spent INT NOT NULL DEFAULT 0 CHECK (rewards_points_spent >= 0),
    rewards_points_earned INT NOT NULL DEFAULT 0 CHECK (rewards_points_earned >= 0),
    
    -- Marketing, Coupon & Tolt Affiliate Attribution
    applied_coupon_code VARCHAR(50),
    affiliate_referral_token VARCHAR(255),
    
    -- Audit & Context
    ip_address VARCHAR(45),
    user_agent TEXT,
    billing_address JSONB,
    
    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    paid_at TIMESTAMPTZ,
    fulfilled_at TIMESTAMPTZ,
    cancelled_at TIMESTAMPTZ
);

COMMENT ON TABLE cust_orders IS 'Decoupled order master table separating Order, Payment, and Fulfillment lifecycles.';
CREATE INDEX idx_orders_customer ON cust_orders(customer_id);
CREATE INDEX idx_orders_number ON cust_orders(order_number);
CREATE INDEX idx_orders_states ON cust_orders(order_status, payment_status, fulfillment_status);
CREATE INDEX idx_orders_created ON cust_orders(created_at);

-- 8.2 Order Line Items (Immutable Snapshot of Purchased Terms)
CREATE TABLE order_line_items (
    line_item_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL REFERENCES cust_orders(order_id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES catalog_products(product_id) ON DELETE RESTRICT,
    offer_id UUID NOT NULL REFERENCES product_offers(offer_id) ON DELETE RESTRICT,
    cohort_schedule_id UUID, -- Linked cohort if applicable
    
    -- Frozen Snapshots at moment of purchase
    product_title_snapshot VARCHAR(255) NOT NULL,
    product_type_snapshot VARCHAR(50) NOT NULL,
    unit_price_snapshot NUMERIC(12,2) NOT NULL CHECK (unit_price_snapshot >= 0),
    access_duration_days_snapshot INT, -- NULL indicates lifetime access
    
    -- Line Amounts
    quantity INT NOT NULL DEFAULT 1 CHECK (quantity > 0),
    line_subtotal NUMERIC(12,2) NOT NULL CHECK (line_subtotal >= 0),
    line_discount NUMERIC(12,2) NOT NULL DEFAULT 0.00 CHECK (line_discount >= 0),
    line_total NUMERIC(12,2) NOT NULL CHECK (line_total >= 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE order_line_items IS 'Frozen snapshot of order line items preserving commercial terms at transaction time.';
CREATE INDEX idx_line_items_order ON order_line_items(order_id);
CREATE INDEX idx_line_items_product ON order_line_items(product_id);

-- =============================================================================
-- DOMAIN 9: PAYMENTS, WEBHOOKS, INVOICES & REFUNDS (COM)
-- =============================================================================

-- 9.1 Payment Transactions
CREATE TABLE payment_transactions (
    transaction_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL REFERENCES cust_orders(order_id) ON DELETE RESTRICT,
    customer_id UUID NOT NULL REFERENCES customers(customer_id) ON DELETE RESTRICT,
    payment_gateway VARCHAR(50) NOT NULL CHECK (payment_gateway IN ('STRIPE', 'TABBY', 'TAMARA')),
    gateway_transaction_id VARCHAR(255) UNIQUE, -- Stripe PaymentIntent ID, Tabby Payment ID
    idempotency_key VARCHAR(255) UNIQUE NOT NULL,
    payment_method_type VARCHAR(50) NOT NULL CHECK (payment_method_type IN (
        'CREDIT_CARD', 'APPLE_PAY', 'GOOGLE_PAY', 'MADA', 'TABBY_INSTALLMENTS', 'TAMARA_INSTALLMENTS', 'SPLIT_REWARDS_ONLY'
    )),
    amount NUMERIC(12,2) NOT NULL CHECK (amount >= 0),
    currency_code VARCHAR(3) NOT NULL REFERENCES currencies(currency_code) ON DELETE RESTRICT,
    status VARCHAR(30) NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'SUCCESS', 'FAILED', 'REFUNDED', 'PARTIALLY_REFUNDED')),
    gateway_error_code VARCHAR(100),
    gateway_error_message TEXT,
    gateway_response JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE payment_transactions IS 'Payment attempt and settlement records processed via Stripe, Tabby, or Tamara.';
CREATE INDEX idx_payment_tx_order ON payment_transactions(order_id);
CREATE INDEX idx_payment_tx_gateway ON payment_transactions(gateway_transaction_id);

-- 9.2 Official Tax Invoices
CREATE TABLE payment_invoices (
    invoice_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID UNIQUE NOT NULL REFERENCES cust_orders(order_id) ON DELETE RESTRICT,
    stripe_invoice_id VARCHAR(100) UNIQUE,
    invoice_number VARCHAR(100) UNIQUE NOT NULL,
    invoice_pdf_url VARCHAR(500),
    tax_percentage NUMERIC(5,2) NOT NULL DEFAULT 0.00,
    tax_amount NUMERIC(12,2) NOT NULL DEFAULT 0.00,
    issued_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE payment_invoices IS 'Tax invoices generated and verified through Stripe Tax and Invoicing.';
CREATE INDEX idx_invoices_order ON payment_invoices(order_id);

-- 9.3 Order Refunds
CREATE TABLE order_refunds (
    refund_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL REFERENCES cust_orders(order_id) ON DELETE RESTRICT,
    transaction_id UUID NOT NULL REFERENCES payment_transactions(transaction_id) ON DELETE RESTRICT,
    refund_number VARCHAR(50) UNIQUE NOT NULL,
    refund_type VARCHAR(20) NOT NULL CHECK (refund_type IN ('FULL', 'PARTIAL')),
    amount NUMERIC(12,2) NOT NULL CHECK (amount > 0),
    currency_code VARCHAR(3) NOT NULL REFERENCES currencies(currency_code) ON DELETE RESTRICT,
    reason TEXT NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'SUCCEEDED', 'FAILED')),
    gateway_refund_id VARCHAR(255) UNIQUE,
    points_reversed INT NOT NULL DEFAULT 0 CHECK (points_reversed >= 0),
    requested_by_admin_id UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE order_refunds IS 'Records of full and partial refunds with payment gateway reconciliation.';
CREATE INDEX idx_refunds_order ON order_refunds(order_id);

-- 9.4 Incoming Webhook Events & Idempotency Log
CREATE TABLE incoming_webhook_events (
    webhook_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    source_gateway VARCHAR(50) NOT NULL CHECK (source_gateway IN ('STRIPE', 'TABBY', 'TAMARA', 'LMS', 'TOLT')),
    event_type VARCHAR(100) NOT NULL,
    external_event_id VARCHAR(255) UNIQUE NOT NULL, -- Strict Idempotency Check
    payload JSONB NOT NULL,
    processing_status VARCHAR(30) NOT NULL DEFAULT 'PENDING' CHECK (processing_status IN ('PENDING', 'PROCESSED', 'FAILED', 'IGNORED')),
    error_message TEXT,
    received_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    processed_at TIMESTAMPTZ
);

COMMENT ON TABLE incoming_webhook_events IS 'Idempotency ledger ensuring external webhooks are processed exactly once.';
CREATE INDEX idx_webhooks_idempotency ON incoming_webhook_events(external_event_id);
CREATE INDEX idx_webhooks_status ON incoming_webhook_events(processing_status, received_at);

-- =============================================================================
-- DOMAIN 10: ENTITLEMENTS & ACCESS ENGINE (ENT & EXT)
-- =============================================================================

-- 10.1 Customer Entitlements (Single Source of Truth for Product Access)
CREATE TABLE cust_entitlements (
    entitlement_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL REFERENCES customers(customer_id) ON DELETE RESTRICT,
    product_id UUID NOT NULL REFERENCES catalog_products(product_id) ON DELETE RESTRICT,
    resource_id UUID REFERENCES lms_resources(resource_id) ON DELETE SET NULL, -- Mapped LMS Course
    source_type VARCHAR(50) NOT NULL CHECK (source_type IN (
        'ORDER_PURCHASE',       -- Direct standalone purchase
        'BUNDLE_ITEM',          -- Part of a composite bundle
        'SUBSCRIPTION',         -- Recurring subscription active access
        'CHOOSE_X_SELECTION',   -- Selected under Choose-X annual allowance
        'MANUAL_GRANT',         -- Granted manually by ops/support
        'ACCESS_EXTENSION'      -- Extended after standard expiration
    )),
    source_reference_id UUID, -- order_id, subscription_id, or selection_id
    starts_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    expires_at TIMESTAMPTZ, -- NULL denotes Lifetime Access
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'EXPIRED', 'REVOKED', 'SUSPENDED')),
    revocation_reason TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_entitlement_dates CHECK (expires_at IS NULL OR starts_at <= expires_at)
);

COMMENT ON TABLE cust_entitlements IS 'The exclusive Source of Truth for access rights. Answers "Does this customer have access?".';
CREATE INDEX idx_entitlements_customer_product ON cust_entitlements(customer_id, product_id, status);
CREATE INDEX idx_entitlements_customer_resource ON cust_entitlements(customer_id, resource_id, status);
CREATE INDEX idx_entitlements_expiry ON cust_entitlements(expires_at) WHERE status = 'ACTIVE';

-- 10.2 Entitlement Extension History
CREATE TABLE entitlement_extension_history (
    extension_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    entitlement_id UUID NOT NULL REFERENCES cust_entitlements(entitlement_id) ON DELETE CASCADE,
    order_id UUID NOT NULL REFERENCES cust_orders(order_id) ON DELETE RESTRICT,
    extension_type VARCHAR(30) NOT NULL CHECK (extension_type IN ('3_MONTHS', '12_MONTHS', 'LIFETIME')),
    added_days INT,
    old_expires_at TIMESTAMPTZ,
    new_expires_at TIMESTAMPTZ, -- NULL if Lifetime
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE entitlement_extension_history IS 'Audit and renewal trail for extended access on expired courses/diplomas.';
CREATE INDEX idx_extensions_entitlement ON entitlement_extension_history(entitlement_id);

-- =============================================================================
-- DOMAIN 11: FULFILLMENT ENGINE (FUL)
-- =============================================================================

-- 11.1 Asynchronous Fulfillment Tasks Queue
CREATE TABLE fulfillment_tasks (
    task_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL REFERENCES cust_orders(order_id) ON DELETE RESTRICT,
    order_line_item_id UUID REFERENCES order_line_items(line_item_id) ON DELETE SET NULL,
    customer_id UUID NOT NULL REFERENCES customers(customer_id) ON DELETE RESTRICT,
    task_type VARCHAR(50) NOT NULL CHECK (task_type IN (
        'LMS_ENROLL',                -- Enroll student in LMS course
        'LMS_REVOKE',                -- Revoke access upon refund
        'LMS_EXTEND_EXPIRY',         -- Push updated expiry date to LMS
        'GRANT_COMMUNITY_ACCESS',    -- Add member to community space
        'REVOKE_COMMUNITY_ACCESS',   -- Remove member from community space
        'SCHEDULE_CONSULTATION',     -- Confirm consultation slot
        'DISPATCH_PHYSICAL_ITEM'     -- Trigger printed certificate shipment
    )),
    target_reference VARCHAR(255) NOT NULL, -- e.g. course_id, space_id, service_id
    payload JSONB NOT NULL DEFAULT '{}'::jsonb,
    status VARCHAR(30) NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'PROCESSING', 'SUCCESS', 'FAILED', 'DEAD_LETTER')),
    attempt_count INT NOT NULL DEFAULT 0 CHECK (attempt_count >= 0),
    max_attempts INT NOT NULL DEFAULT 5,
    last_error_message TEXT,
    next_retry_at TIMESTAMPTZ,
    idempotency_key VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE fulfillment_tasks IS 'Decoupled task execution queue distributing fulfillment work across external systems.';
CREATE INDEX idx_fulfillment_queue ON fulfillment_tasks(status, next_retry_at);
CREATE INDEX idx_fulfillment_order ON fulfillment_tasks(order_id);

-- =============================================================================
-- DOMAIN 12: SUBSCRIPTION ENGINE & CHOOSE-X (SUB)
-- =============================================================================

-- 12.1 Subscription Plans
CREATE TABLE subscription_plans (
    plan_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID NOT NULL REFERENCES catalog_products(product_id) ON DELETE RESTRICT,
    plan_code VARCHAR(50) UNIQUE NOT NULL, -- e.g. 'SUB-ALL-MONTHLY', 'SUB-ALL-ANNUAL', 'SUB-CHOOSE10-ANNUAL'
    plan_name_ar VARCHAR(150) NOT NULL,
    plan_type VARCHAR(50) NOT NULL CHECK (plan_type IN ('FULL_CATALOG_ACCESS', 'CHOOSE_X_ANNUAL', 'CATEGORY_SPECIFIC')),
    billing_interval VARCHAR(20) NOT NULL CHECK (billing_interval IN ('MONTHLY', 'ANNUAL')),
    selection_allowance INT NOT NULL DEFAULT 0 CHECK (selection_allowance >= 0), -- 10 courses for Choose-X, 0 for unlimited
    price_usd NUMERIC(10,2) NOT NULL CHECK (price_usd >= 0),
    stripe_plan_price_id VARCHAR(100),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    version INT NOT NULL DEFAULT 1,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_choose_x_annual_only CHECK (
        -- Global rule: Choose-X subscription model is strictly ANNUAL ONLY
        NOT (plan_type = 'CHOOSE_X_ANNUAL' AND billing_interval <> 'ANNUAL')
    )
);

COMMENT ON TABLE subscription_plans IS 'Master subscription plans including full catalog and Choose-X annual model.';
CREATE INDEX idx_sub_plans_code ON subscription_plans(plan_code);

-- 12.2 Customer Subscriptions
CREATE TABLE customer_subscriptions (
    subscription_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL REFERENCES customers(customer_id) ON DELETE RESTRICT,
    plan_id UUID NOT NULL REFERENCES subscription_plans(plan_id) ON DELETE RESTRICT,
    stripe_subscription_id VARCHAR(100) UNIQUE,
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'TRIALING', 'PAST_DUE', 'UNPAID', 'CANCELLED', 'EXPIRED')),
    current_period_start TIMESTAMPTZ NOT NULL,
    current_period_end TIMESTAMPTZ NOT NULL,
    cancel_at_period_end BOOLEAN NOT NULL DEFAULT FALSE,
    cancelled_at TIMESTAMPTZ,
    selections_allowance_total INT NOT NULL DEFAULT 0 CHECK (selections_allowance_total >= 0),
    selections_allowance_used INT NOT NULL DEFAULT 0 CHECK (selections_allowance_used >= 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_selections_within_limit CHECK (selections_allowance_used <= selections_allowance_total OR selections_allowance_total = 0)
);

COMMENT ON TABLE customer_subscriptions IS 'Recurring subscription contracts and lifecycle states managed via Stripe Billing.';
CREATE INDEX idx_cust_sub_customer ON customer_subscriptions(customer_id);
CREATE INDEX idx_cust_sub_status ON customer_subscriptions(status);

-- 12.3 Choose-X Course Selections Ledger
CREATE TABLE choose_x_selections (
    selection_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    subscription_id UUID NOT NULL REFERENCES customer_subscriptions(subscription_id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES catalog_products(product_id) ON DELETE RESTRICT,
    entitlement_id UUID REFERENCES cust_entitlements(entitlement_id) ON DELETE SET NULL,
    learning_started BOOLEAN NOT NULL DEFAULT FALSE, -- Lock flag: once true, course replacement is strictly barred
    learning_started_at TIMESTAMPTZ,
    selected_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_subscription_selection UNIQUE (subscription_id, product_id)
);

COMMENT ON TABLE choose_x_selections IS 'Course selections under Choose-X annual subscription with learning lock enforcement.';
CREATE INDEX idx_choose_x_sub ON choose_x_selections(subscription_id);

-- =============================================================================
-- DOMAIN 13: LIVE COHORTS & WAITLISTS (COH)
-- =============================================================================

-- 13.1 Cohort Schedules
CREATE TABLE cohort_schedules (
    cohort_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID NOT NULL REFERENCES catalog_products(product_id) ON DELETE RESTRICT,
    cohort_code VARCHAR(50) UNIQUE NOT NULL,
    cohort_name_ar VARCHAR(150) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    meeting_schedule_text VARCHAR(255), -- e.g. 'كل أحد وثلاثاء الساعة 8 مساءً'
    seat_capacity INT NOT NULL CHECK (seat_capacity > 0),
    seats_booked INT NOT NULL DEFAULT 0 CHECK (seats_booked >= 0 AND seats_booked <= seat_capacity),
    status VARCHAR(30) NOT NULL DEFAULT 'OPEN' CHECK (status IN ('UPCOMING', 'OPEN', 'SOLD_OUT', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_cohort_dates CHECK (start_date <= end_date)
);

COMMENT ON TABLE cohort_schedules IS 'Live interactive cohorts with seat capacity limits and automatic sold-out status.';
CREATE INDEX idx_cohorts_product ON cohort_schedules(product_id, status);

-- 13.2 Cohort Student Registrations
CREATE TABLE cohort_registrations (
    registration_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cohort_id UUID NOT NULL REFERENCES cohort_schedules(cohort_id) ON DELETE RESTRICT,
    customer_id UUID NOT NULL REFERENCES customers(customer_id) ON DELETE RESTRICT,
    order_id UUID NOT NULL REFERENCES cust_orders(order_id) ON DELETE RESTRICT,
    status VARCHAR(30) NOT NULL DEFAULT 'CONFIRMED' CHECK (status IN ('CONFIRMED', 'CANCELLED', 'GRADUATED')),
    registered_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_cohort_customer UNIQUE (cohort_id, customer_id)
);

COMMENT ON TABLE cohort_registrations IS 'Enrolled students within specific live interactive cohorts.';
CREATE INDEX idx_cohort_reg_customer ON cohort_registrations(customer_id);

-- 13.3 Cohort Waitlists (For Sold-Out Programs)
CREATE TABLE cohort_waitlists (
    waitlist_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cohort_id UUID NOT NULL REFERENCES cohort_schedules(cohort_id) ON DELETE CASCADE,
    customer_id UUID NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
    joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    status VARCHAR(30) NOT NULL DEFAULT 'WAITING' CHECK (status IN ('WAITING', 'NOTIFIED', 'ENROLLED', 'EXPIRED')),
    notified_at TIMESTAMPTZ,
    reservation_expires_at TIMESTAMPTZ,
    CONSTRAINT uq_cohort_waitlist UNIQUE (cohort_id, customer_id)
);

COMMENT ON TABLE cohort_waitlists IS 'Automated queue of prospective learners when cohort capacity is reached.';
CREATE INDEX idx_cohort_waitlist_status ON cohort_waitlists(cohort_id, status);

-- =============================================================================
-- DOMAIN 14: CONSULTATIONS MARKETPLACE (CONS)
-- =============================================================================

-- 14.1 Expert Consultation Services
CREATE TABLE consultation_services (
    service_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    expert_id UUID NOT NULL REFERENCES platform_experts(expert_id) ON DELETE RESTRICT,
    product_id UUID REFERENCES catalog_products(product_id) ON DELETE SET NULL,
    title_ar VARCHAR(255) NOT NULL,
    description_ar TEXT,
    duration_minutes INT NOT NULL DEFAULT 60 CHECK (duration_minutes > 0),
    price_usd NUMERIC(10,2) NOT NULL CHECK (price_usd >= 0),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE consultation_services IS 'Professional advisory services offered by instructors and industry consultants.';
CREATE INDEX idx_consult_services_expert ON consultation_services(expert_id);

-- 14.2 Consultation Bookings & Calendar Sync
CREATE TABLE consultation_bookings (
    booking_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    booking_reference VARCHAR(50) UNIQUE NOT NULL,
    order_id UUID NOT NULL REFERENCES cust_orders(order_id) ON DELETE RESTRICT,
    customer_id UUID NOT NULL REFERENCES customers(customer_id) ON DELETE RESTRICT,
    expert_id UUID NOT NULL REFERENCES platform_experts(expert_id) ON DELETE RESTRICT,
    service_id UUID NOT NULL REFERENCES consultation_services(service_id) ON DELETE RESTRICT,
    scheduled_start_time TIMESTAMPTZ NOT NULL,
    scheduled_end_time TIMESTAMPTZ NOT NULL,
    customer_timezone VARCHAR(50) NOT NULL DEFAULT 'Asia/Riyadh',
    google_meet_link VARCHAR(500),
    google_calendar_event_id VARCHAR(255),
    booking_status VARCHAR(40) NOT NULL DEFAULT 'CONFIRMED' CHECK (booking_status IN (
        'PENDING_PAYMENT',
        'CONFIRMED',
        'RESCHEDULED',
        'COMPLETED',
        'CANCELLED_BY_CUSTOMER',
        'CANCELLED_BY_EXPERT',
        'NO_SHOW'
    )),
    reschedule_count INT NOT NULL DEFAULT 0 CHECK (reschedule_count >= 0),
    cancellation_reason TEXT,
    customer_notes TEXT,
    expert_private_notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_consultation_time CHECK (scheduled_start_time < scheduled_end_time)
);

-- Partial Unique Index to ensure atomic double-booking prevention for active slots
CREATE UNIQUE INDEX uq_expert_active_slot 
ON consultation_bookings(expert_id, scheduled_start_time) 
WHERE booking_status NOT IN ('CANCELLED_BY_CUSTOMER', 'CANCELLED_BY_EXPERT');

COMMENT ON TABLE consultation_bookings IS 'Confirmed 1-on-1 consultations with atomic slot reservations and Google Meet integration.';
CREATE INDEX idx_bookings_customer ON consultation_bookings(customer_id);
CREATE INDEX idx_bookings_expert_time ON consultation_bookings(expert_id, scheduled_start_time);

-- =============================================================================
-- DOMAIN 15: MASTERY COMMUNITY & SPACES (CMTY)
-- =============================================================================

-- 15.1 Community Spaces
CREATE TABLE community_spaces (
    space_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name_ar VARCHAR(150) NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    description_ar TEXT,
    space_type VARCHAR(30) NOT NULL DEFAULT 'PUBLIC' CHECK (space_type IN (
        'PUBLIC',              -- General discussions for all active members
        'COURSE_RESTRICTED',   -- Requires active course entitlement
        'COHORT_RESTRICTED',   -- Requires active cohort registration
        'ALUMNI_ONLY'          -- For program graduates
    )),
    required_product_id UUID REFERENCES catalog_products(product_id) ON DELETE SET NULL,
    required_cohort_id UUID REFERENCES cohort_schedules(cohort_id) ON DELETE SET NULL,
    sort_order INT NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE community_spaces IS 'Social learning spaces, professional networking channels, and cohort rooms.';
CREATE INDEX idx_spaces_slug ON community_spaces(slug);

-- 15.2 Community Memberships
CREATE TABLE community_memberships (
    membership_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
    space_id UUID NOT NULL REFERENCES community_spaces(space_id) ON DELETE CASCADE,
    role VARCHAR(20) NOT NULL DEFAULT 'MEMBER' CHECK (role IN ('MEMBER', 'MODERATOR', 'INSTRUCTOR')),
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'MUTED', 'BANNED', 'EXPIRED')),
    joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    expires_at TIMESTAMPTZ, -- Tied to community subscription expiry
    CONSTRAINT uq_customer_space UNIQUE (customer_id, space_id)
);

COMMENT ON TABLE community_memberships IS 'Customer memberships and moderation privileges across community spaces.';
CREATE INDEX idx_memberships_customer ON community_memberships(customer_id);

-- 15.3 Community Discussion Posts
CREATE TABLE community_posts (
    post_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    space_id UUID NOT NULL REFERENCES community_spaces(space_id) ON DELETE CASCADE,
    author_customer_id UUID NOT NULL REFERENCES customers(customer_id) ON DELETE RESTRICT,
    title VARCHAR(255),
    content_text TEXT NOT NULL,
    attachments JSONB NOT NULL DEFAULT '[]'::jsonb,
    likes_count INT NOT NULL DEFAULT 0 CHECK (likes_count >= 0),
    replies_count INT NOT NULL DEFAULT 0 CHECK (replies_count >= 0),
    is_pinned BOOLEAN NOT NULL DEFAULT FALSE,
    is_locked BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE community_posts IS 'Member questions, case discussions, and professional networking posts.';
CREATE INDEX idx_posts_space ON community_posts(space_id, is_pinned DESC, created_at DESC);

-- 15.4 Community Post Replies
CREATE TABLE community_post_replies (
    reply_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    post_id UUID NOT NULL REFERENCES community_posts(post_id) ON DELETE CASCADE,
    author_customer_id UUID NOT NULL REFERENCES customers(customer_id) ON DELETE RESTRICT,
    parent_reply_id UUID REFERENCES community_post_replies(reply_id) ON DELETE CASCADE,
    content_text TEXT NOT NULL,
    likes_count INT NOT NULL DEFAULT 0 CHECK (likes_count >= 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE community_post_replies IS 'Threaded discussion replies and instructor answers on community posts.';
CREATE INDEX idx_replies_post ON community_post_replies(post_id, created_at ASC);

-- =============================================================================
-- DOMAIN 16: MASTERY REWARDS & LOYALTY LEDGER (GRW)
-- =============================================================================

-- 16.1 Mastery Rewards Ledger (Points Only - Strictly No Independent Wallet / No Cash Out)
CREATE TABLE rewards_ledger (
    ledger_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL REFERENCES customers(customer_id) ON DELETE RESTRICT,
    order_id UUID REFERENCES cust_orders(order_id) ON DELETE SET NULL,
    transaction_type VARCHAR(40) NOT NULL CHECK (transaction_type IN (
        'EARN',                  -- 10 points per $1 cash paid
        'REDEEM',                -- 1,000 points = $10 checkout discount
        'RESERVE_HOLD',          -- Temporarily held during checkout
        'RESTORE_ON_CANCEL',     -- Restored if payment fails or order cancelled
        'REVERSE_ON_REFUND',     -- Clawback of earned points upon refund
        'ADMIN_ADJUSTMENT'       -- Manual adjustment by authorized staff
    )),
    points_change INT NOT NULL, -- Positive for earning/restoring, negative for spending/clawback
    balance_after INT NOT NULL CHECK (balance_after >= 0),
    description_ar VARCHAR(255) NOT NULL,
    idempotency_key VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE rewards_ledger IS 'Immutable ledger of Mastery Rewards points. Non-expiring points, redeemable for discounts only.';
CREATE INDEX idx_rewards_customer ON rewards_ledger(customer_id, created_at DESC);

-- =============================================================================
-- DOMAIN 17: PROMOTIONS, COUPONS & MERCHANDISING (PRM / CMS)
-- =============================================================================

-- 17.1 Automated Campaigns & Promotions
CREATE TABLE promotions (
    promotion_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    slug VARCHAR(100) UNIQUE NOT NULL,
    name_ar VARCHAR(150) NOT NULL,
    discount_type VARCHAR(30) NOT NULL CHECK (discount_type IN ('PERCENTAGE', 'FIXED_AMOUNT')),
    discount_value NUMERIC(10,2) NOT NULL CHECK (discount_value > 0),
    target_type VARCHAR(30) NOT NULL CHECK (target_type IN ('ALL_PRODUCTS', 'SPECIFIC_PRODUCTS', 'SPECIFIC_CATEGORIES')),
    starts_at TIMESTAMPTZ NOT NULL,
    ends_at TIMESTAMPTZ NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_promo_dates CHECK (starts_at <= ends_at)
);

COMMENT ON TABLE promotions IS 'Scheduled promotional campaigns and automated discounts.';
CREATE INDEX idx_promotions_active ON promotions(is_active, starts_at, ends_at);

-- 17.2 Promotion Targeted Products / Categories
CREATE TABLE promotion_target_items (
    target_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    promotion_id UUID NOT NULL REFERENCES promotions(promotion_id) ON DELETE CASCADE,
    product_id UUID REFERENCES catalog_products(product_id) ON DELETE CASCADE,
    category_id UUID REFERENCES product_categories(category_id) ON DELETE CASCADE,
    CONSTRAINT chk_promo_target_item CHECK (product_id IS NOT NULL OR category_id IS NOT NULL)
);

COMMENT ON TABLE promotion_target_items IS 'Products or categories targeted by a specific promotional campaign.';

-- 17.3 Discount Coupons
CREATE TABLE coupons (
    coupon_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(50) UNIQUE NOT NULL, -- Normalized uppercase code
    description_ar VARCHAR(255),
    discount_type VARCHAR(30) NOT NULL CHECK (discount_type IN ('PERCENTAGE', 'FIXED_AMOUNT')),
    discount_value NUMERIC(10,2) NOT NULL CHECK (discount_value > 0),
    min_order_amount NUMERIC(10,2) NOT NULL DEFAULT 0.00 CHECK (min_order_amount >= 0),
    max_discount_amount NUMERIC(10,2) CHECK (max_discount_amount >= 0),
    usage_limit_total INT CHECK (usage_limit_total > 0),
    usage_limit_per_customer INT NOT NULL DEFAULT 1 CHECK (usage_limit_per_customer > 0),
    times_used INT NOT NULL DEFAULT 0 CHECK (times_used >= 0),
    starts_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ends_at TIMESTAMPTZ NOT NULL,
    is_stackable BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_coupon_dates CHECK (starts_at <= ends_at)
);

COMMENT ON TABLE coupons IS 'Promotional discount coupons with usage limits and stacking rules.';
CREATE INDEX idx_coupons_code ON coupons(code);

-- 17.4 Coupon Redemptions Ledger
CREATE TABLE coupon_redemptions (
    redemption_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    coupon_id UUID NOT NULL REFERENCES coupons(coupon_id) ON DELETE RESTRICT,
    customer_id UUID NOT NULL REFERENCES customers(customer_id) ON DELETE RESTRICT,
    order_id UUID NOT NULL REFERENCES cust_orders(order_id) ON DELETE RESTRICT,
    discount_amount NUMERIC(12,2) NOT NULL CHECK (discount_amount >= 0),
    redeemed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_coupon_order UNIQUE (coupon_id, order_id)
);

COMMENT ON TABLE coupon_redemptions IS 'Per-customer coupon usage tracking.';
CREATE INDEX idx_coupon_redemptions_cust ON coupon_redemptions(coupon_id, customer_id);

-- 17.5 CMS Block-based Landing Pages
CREATE TABLE cms_landing_pages (
    page_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    slug VARCHAR(150) UNIQUE NOT NULL,
    title_ar VARCHAR(255) NOT NULL,
    meta_title VARCHAR(255),
    meta_description TEXT,
    layout_blocks JSONB NOT NULL DEFAULT '[]'::jsonb, -- Block-based: Hero, CTA, Grid, FAQs, Testimonials
    is_published BOOLEAN NOT NULL DEFAULT FALSE,
    published_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE cms_landing_pages IS 'Dynamic marketing and campaign landing pages composed of modular blocks.';
CREATE INDEX idx_landing_pages_slug ON cms_landing_pages(slug);

-- 17.6 CMS Marketing Banners
CREATE TABLE cms_banners (
    banner_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title_ar VARCHAR(150) NOT NULL,
    placement VARCHAR(50) NOT NULL DEFAULT 'HOMEPAGE_HERO' CHECK (placement IN ('HOMEPAGE_HERO', 'CATEGORY_TOP', 'CHECKOUT_TOP', 'POPUP')),
    image_url VARCHAR(500) NOT NULL,
    link_url VARCHAR(500),
    starts_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ends_at TIMESTAMPTZ,
    sort_order INT NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE cms_banners IS 'Promotional banners and scheduled marketing notices.';

-- =============================================================================
-- DOMAIN 18: INTERNAL FEEDBACK & QUALITY (FBK)
-- =============================================================================

-- 18.1 Customer Product Feedback (Strict Rule: Internal Only - Hidden from Public Store)
CREATE TABLE product_feedback (
    feedback_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL REFERENCES customers(customer_id) ON DELETE RESTRICT,
    product_id UUID NOT NULL REFERENCES catalog_products(product_id) ON DELETE RESTRICT,
    order_id UUID NOT NULL REFERENCES cust_orders(order_id) ON DELETE RESTRICT,
    overall_rating SMALLINT NOT NULL CHECK (overall_rating BETWEEN 1 AND 5),
    content_quality_rating SMALLINT CHECK (content_quality_rating BETWEEN 1 AND 5),
    instructor_rating SMALLINT CHECK (instructor_rating BETWEEN 1 AND 5),
    practical_value_rating SMALLINT CHECK (practical_value_rating BETWEEN 1 AND 5),
    feedback_comments TEXT,
    is_internal_only BOOLEAN NOT NULL DEFAULT TRUE, -- Fixed business invariant
    admin_notes TEXT,
    reviewed_by_admin_id UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_feedback_customer_product UNIQUE (customer_id, product_id)
);

COMMENT ON TABLE product_feedback IS 'Strictly internal quality feedback from verified buyers. Never displayed publicly on store PDPs.';
CREATE INDEX idx_feedback_product ON product_feedback(product_id, overall_rating);

-- =============================================================================
-- DOMAIN 19: PHYSICAL FULFILLMENT & CERTIFICATES (ADD)
-- =============================================================================

-- 19.1 Physical Certificates & Luxury Shipping
CREATE TABLE physical_fulfillments (
    fulfillment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL REFERENCES cust_orders(order_id) ON DELETE RESTRICT,
    order_line_item_id UUID REFERENCES order_line_items(line_item_id) ON DELETE RESTRICT,
    customer_id UUID NOT NULL REFERENCES customers(customer_id) ON DELETE RESTRICT,
    address_id UUID REFERENCES customer_addresses(address_id) ON DELETE RESTRICT,
    certificate_type VARCHAR(50) NOT NULL CHECK (certificate_type IN (
        'MASTERY_LUXURY_PRINTED_CERT',
        'CPD_PRINTED_CERT',
        'COMBO_PRINTED_CERTS'
    )),
    lms_verification_id VARCHAR(100), -- Official certificate serial number generated by LMS Core
    recipient_full_name_on_cert VARCHAR(200) NOT NULL,
    shipping_carrier VARCHAR(100), -- Aramex, SMSA, DHL
    tracking_number VARCHAR(100),
    tracking_url VARCHAR(500),
    fulfillment_status VARCHAR(30) NOT NULL DEFAULT 'PENDING_ADDRESS' CHECK (fulfillment_status IN (
        'PENDING_ADDRESS',
        'PROCESSING',
        'PRINTED',
        'SHIPPED',
        'DELIVERED',
        'RETURNED',
        'FAILED'
    )),
    shipped_at TIMESTAMPTZ,
    delivered_at TIMESTAMPTZ,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE physical_fulfillments IS 'Physical dispatch and parcel tracking for luxury printed certificates and CPD credentials.';
CREATE INDEX idx_physical_status ON physical_fulfillments(fulfillment_status);
CREATE INDEX idx_physical_order ON physical_fulfillments(order_id);

-- =============================================================================
-- DOMAIN 20: OPERATIONS & INCIDENTS CENTER (OPS)
-- =============================================================================

-- 20.1 Operational Incidents & Needs-Attention Queue
CREATE TABLE operational_incidents (
    incident_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    incident_type VARCHAR(50) NOT NULL CHECK (incident_type IN (
        'LMS_ENROLLMENT_FAILED',
        'GOOGLE_MEET_CREATION_FAILED',
        'PAYMENT_WEBHOOK_MISMATCH',
        'REFUND_SYNC_FAILED',
        'COMMUNITY_PROVISIONING_FAILED',
        'CHOOSE_X_LOCK_FAILURE'
    )),
    severity VARCHAR(20) NOT NULL DEFAULT 'HIGH' CHECK (severity IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')),
    status VARCHAR(30) NOT NULL DEFAULT 'OPEN' CHECK (status IN ('OPEN', 'INVESTIGATING', 'RESOLVED', 'IGNORED')),
    reference_entity_type VARCHAR(50) NOT NULL, -- 'cust_orders', 'consultation_bookings', 'fulfillment_tasks'
    reference_entity_id UUID NOT NULL,
    error_message TEXT NOT NULL,
    payload JSONB NOT NULL DEFAULT '{}'::jsonb,
    resolution_notes TEXT,
    resolved_by_admin_id UUID,
    resolved_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE operational_incidents IS 'Needs-Attention incident queue tracking automated failures for operations staff resolution.';
CREATE INDEX idx_incidents_status_severity ON operational_incidents(status, severity);

-- =============================================================================
-- DOMAIN 21: SECURITY, RBAC & AUDIT LOGS (SEC)
-- =============================================================================

-- 21.1 Administrative Staff Users
CREATE TABLE admin_users (
    admin_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE admin_users IS 'Staff operators, administrators, and customer support representatives.';

-- 21.2 Granular Administrative Roles
CREATE TABLE admin_roles (
    role_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role_code VARCHAR(50) UNIQUE NOT NULL, -- SUPER_ADMIN, CATALOG_MANAGER, MARKETING_LEAD, SUPPORT_AGENT, FINANCE, OPERATIONS
    role_name_ar VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE admin_roles IS 'Predefined operational and governance roles for B2C platform administration.';

-- 21.3 Granular System Permissions
CREATE TABLE admin_permissions (
    permission_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    permission_key VARCHAR(100) UNIQUE NOT NULL, -- 'orders.view', 'refunds.execute', 'pricing.edit', 'entitlements.manual_grant', etc.
    module VARCHAR(50) NOT NULL,
    description VARCHAR(255)
);

COMMENT ON TABLE admin_permissions IS 'Atomic permissions guarding sensitive operations and administrative features.';

-- 21.4 Role to Permission Join Table
CREATE TABLE admin_role_permissions (
    role_id UUID NOT NULL REFERENCES admin_roles(role_id) ON DELETE CASCADE,
    permission_id UUID NOT NULL REFERENCES admin_permissions(permission_id) ON DELETE CASCADE,
    PRIMARY KEY (role_id, permission_id)
);

-- 21.5 Admin User to Role Join Table
CREATE TABLE admin_user_roles (
    admin_id UUID NOT NULL REFERENCES admin_users(admin_id) ON DELETE CASCADE,
    role_id UUID NOT NULL REFERENCES admin_roles(role_id) ON DELETE CASCADE,
    PRIMARY KEY (admin_id, role_id)
);

-- 21.6 Immutable System Audit Trail (No updates or deletes permitted)
CREATE TABLE system_audit_logs (
    audit_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    actor_type VARCHAR(30) NOT NULL CHECK (actor_type IN ('ADMIN_USER', 'CUSTOMER', 'SYSTEM_WORKER')),
    actor_id UUID,
    actor_email VARCHAR(255),
    action_type VARCHAR(100) NOT NULL, -- 'REFUND_EXECUTED', 'PRICE_UPDATED', 'MANUAL_ENTITLEMENT_GRANTED', 'POINTS_ADJUSTED'
    target_entity_type VARCHAR(50) NOT NULL,
    target_entity_id VARCHAR(100) NOT NULL,
    before_state JSONB,
    after_state JSONB,
    reason TEXT,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE system_audit_logs IS 'Append-only immutable audit trail recording all sensitive financial, entitlement, and pricing operations.';
CREATE INDEX idx_audit_target ON system_audit_logs(target_entity_type, target_entity_id);
CREATE INDEX idx_audit_actor ON system_audit_logs(actor_type, actor_id);
CREATE INDEX idx_audit_created ON system_audit_logs(created_at DESC);

-- =============================================================================
-- DOMAIN 22: AI VECTOR EMBEDDINGS (AI DISCOVERY & RECOMMENDATIONS)
-- =============================================================================

-- 22.1 Vector Table for Catalog Semantic Search & Personalization (pgvector)
CREATE TABLE ai_product_embeddings (
    embedding_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID UNIQUE NOT NULL REFERENCES catalog_products(product_id) ON DELETE CASCADE,
    content_chunk TEXT NOT NULL, -- Title, outcomes, syllabus summary, and audience keywords
    embedding_vector vector(1536), -- Standard 1536-dimensional embeddings (e.g. text-embedding-3-small)
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE ai_product_embeddings IS 'Vector embeddings for semantic product discovery, bundles, and recommendation engine.';

-- HNSW Vector Index for sub-millisecond approximate nearest neighbor search
CREATE INDEX idx_ai_product_vector_hnsw 
ON ai_product_embeddings 
USING hnsw (embedding_vector vector_cosine_ops)
WITH (m = 16, ef_construction = 64);

-- 22.2 Vector Table for B2C Pre-Sales AI Assistant & Roadmaps
CREATE TABLE ai_knowledge_base_embeddings (
    kb_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category VARCHAR(50) NOT NULL CHECK (category IN ('FAQ', 'REFUND_POLICY', 'ROADMAP_TEMPLATE', 'PRODUCT_COMPARISON')),
    title VARCHAR(255) NOT NULL,
    content_text TEXT NOT NULL,
    embedding_vector vector(1536),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE ai_knowledge_base_embeddings IS 'Knowledge base vector embeddings for "Ask Mastery AI" pre-sales floating assistant.';

CREATE INDEX idx_ai_kb_vector_hnsw 
ON ai_knowledge_base_embeddings 
USING hnsw (embedding_vector vector_cosine_ops)
WITH (m = 16, ef_construction = 64);

-- =============================================================================
-- END OF SCHEMA DEFINITION
-- =============================================================================