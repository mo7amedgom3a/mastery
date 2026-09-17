This is a copy of a shared ChatGPT chat. It won't be added to memory.

Report conversation

Tuesday 5:44 PM

Uploaded a file

في رحلة التطوير لمنصة ماستري قمت بتوظيف مبرمج Ai كلود يعمل معي في المكتب لتطوير قسم المنصة الخاص بالافراد فقط b2c ، كما تعلم قمنا بتطوير مشاريع البي تو بي ولدينا فريق كبير يعمل عليه، لكن الان قد ان الاوان لتطوير البي تو سي وهي الواجهات والدورات والاستشارات وكل ما يصل اليه العميل الفردي الذي يقوم بشراء المنتج بنفسه واستهلاكه بالمنصة. نحن انا والمبرمج سنكون مسؤولين عن تطوير البي تو سي فقط لذلك تستطيع تسميتنا فريق تطوير البي تو سي الان عليك ان تعرف ان البي تو سي سيكون له داش بورد مستقلة تماما من حيث الادارة والتحكم

واضح جداً، وسأتعامل من الآن معكما — أنت والمبرمج الذي يعمل معك — باعتباركما **فريق تطوير B2C في ماستري Academy**، ومسؤوليتكما هي كل ما يتعلق بتجربة العميل الفردي الذي يكتشف المنتج، يشتريه بنفسه، ثم يستهلكه داخل المنصة.

وأرى أن قرار فصل إدارة الـB2C عن الـB2B **قرار صحيح استراتيجياً**؛ لأنهما فعلياً نموذجا عمل مختلفان، وليس مجرد واجهتين لنفس المنتج. الـB2B يبيع اشتراكاً مؤسسياً، مستخدمين، مسارات، تقارير إدارية، وإدارة تعلم للشركات. أما الـB2C فهو أقرب إلى **Digital Commerce + Learning Marketplace**: اكتشاف، تسويق، شراء، Upsell، تجربة تعلم، استشارات، تجديد وشراء متكرر.

الوثيقة التي أرفقتها بالفعل تضع أساساً جيداً جداً لواجهة الـB2C، فهي تغطي الصفحة الرئيسية، البحث والاستكشاف، الدورات والدبلومات والباقات والاستشارات، بالإضافة إلى الـSEO والاستهداف الجغرافي والعملات وبوابات الدفع. c5c4a142-abcd-494b-846a-33091bc… كما أنها تمتد إلى صفحات المنتجات، السلة والدفع، الـWishlist والـOnboarding والتوصيات الشخصية، أي أن نطاق الـCustomer Experience أصبح واضحاً إلى حد جيد. c5c4a142-abcd-494b-846a-33091bc…

لكن من هذه اللحظة أريد أن نضع مبدأ هندسياً مهماً جداً:

> **B2C يجب أن يكون منتجاً مستقلاً من ناحية الإدارة والتشغيل، لكن ليس بالضرورة أن يكون جزيرة تقنية منفصلة عن كل ماستري.**

أي أنني أؤيد وجود **B2C Admin Dashboard مستقلة تماماً**، ولكن قد نستفيد من بعض الخدمات المشتركة الموجودة أصلاً في ماستري بدلاً من إعادة بنائها مرتين.

أتصور الهيكل كالتالي:

**Mastery Ecosystem**

**1. Mastery B2B**  
له:  
B2B Frontend  
Corporate Admin Dashboard  
Training Manager Dashboard  
Organizations / Departments / Employees  
Learning Paths  
Corporate Reporting  
Integrations

وهذا يبقى مع الفريق التقني الحالي.

**2. Mastery B2C**  
وهذا هو نطاق فريقكم الجديد:

B2C Website  
Student Experience  
Courses / Diplomas / Bundles  
Consultations  
Cart & Checkout  
Coupons  
Affiliate  
Wishlist  
Reviews  
Subscriptions  
Certificates  
AI Recommendations  
Customer Account

وفوق كل ذلك:

**B2C Admin Dashboard**

وهذه يجب أن تكون مركز التحكم التجاري الكامل للـB2C.

وأقترح أن ننظر إلى الـB2C Admin باعتبارها ليست مجرد لوحة لإضافة دورة؛ بل **Operating System لقطاع الأفراد في ماستري**.

بالتالي يجب أن تحتوي لاحقاً على وحدات مثل:

|الوحدة|ما الذي تسيطر عليه|
|---|---|
|Catalog Management|الدورات، الدبلومات، الباقات، التصنيفات|
|Instructor Management|المدربين والمستشارين|
|Pricing|الأسعار حسب الدول والعملات|
|Promotions|الخصومات والكوبونات والعروض|
|Orders|الطلبات والمشتريات|
|Payments|المدفوعات والاسترداد|
|Customers|حسابات العملاء وسجل الشراء|
|Learning|التسجيل في الدورات والتقدم والشهادات|
|Consultations|الاستشارات والحجوزات|
|Reviews|التقييمات والمراجعات|
|Affiliates|المسوقون والعمولات|
|Marketing|Banners، Landing Pages، Campaigns|
|CRM|Leads والعملاء والسلات المتروكة|
|Notifications|Email / WhatsApp / Push|
|Analytics|المبيعات والتحويل وسلوك المستخدم|
|SEO|Meta، Schema، URLs|
|Geo & Currency|الدول والعملات والأسعار المحلية|
|AI|التوصيات والمساعد الذكي|

وهناك نقطة أعتبرها مهمة جداً في التصميم منذ البداية: **لا تجعلوا Admin مجرد CRUD Dashboard**؛ أي صفحات Create / Edit / Delete فقط. الأفضل أن تكون Dashboard موجهة لإدارة العمل التجاري.

مثلاً عند دخول مدير B2C، يجب أن يرى مباشرة أرقاماً مثل:

**Revenue Today — Revenue MTD — Orders — Conversion Rate — AOV — Cart Abandonment — Top Products — New Customers — Returning Customers — Refunds — Consultation Bookings.**

بهذا تصبح فعلياً لوحة قيادة للأعمال، وليس لوحة تقنية.

أما من الناحية المعمارية فأقترح قاعدة بسيطة:

**مستقل في Business Logic، مشترك عندما يكون الاشتراك منطقياً.**

مثلاً قد نشترك مع B2B في:

User Identity  
Video Infrastructure  
Course Content Storage  
Certificates Engine  
Assessment Engine  
Notifications Infrastructure

لكن الـB2C يمتلك بشكل مستقل:

Pricing  
Orders  
Cart  
Checkout  
Coupons  
Affiliate  
Customer Analytics  
Recommendations  
Promotions  
B2C Admin  
Merchandising  
Consultations  
Consumer CRM

وهذا الفصل مهم جداً؛ لأنه سيمنع أن يصبح أي تعديل صغير في قطاع الأفراد معتمداً على فريق الـB2B.

وأريد أن نضع قاعدة تنظيمية داخل ماستري من الآن:

> **أي Feature هدفها زيادة اكتشاف المنتج أو شرائه أو استهلاكه من قبل فرد يدفع من ماله الخاص → ملك فريق B2C.**

أما:

> **أي Feature هدفها إدارة تعلم موظفين تابعين لشركة أو إدارة مؤسسة أو قياس تعلمهم → ملك فريق B2B.**

وهذا التعريف سيحل لاحقاً كثيراً من مشاكل الـownership بين الفرق.

كما أنني لا أنصح أن نحاول بناء كل شيء دفعة واحدة. أرى أن رحلة تطوير B2C يجب أن نسير فيها بطريقة Product Development حقيقية:

**Foundation → Commerce → Learning → Growth → Intelligence.**

أي نثبت أولاً الأساس، ثم منظومة البيع، ثم تجربة التعلم، ثم أدوات النمو، وأخيراً طبقة الذكاء الاصطناعي والتخصيص.

وأقترح أن تكون خطوتنا التالية الآن هي **أهم وثيقة في مشروع B2C كله**:

### Mastery B2C Product Map

سنرسم فيها كل أجزاء النظام في صفحة واحدة، من لحظة دخول الزائر إلى الموقع وحتى أن يصبح عميلاً متكرراً:

**Visitor → Discovery → Product Page → Cart → Checkout → Payment → Account → Learning → Certificate → Review → Upsell → Repeat Purchase**

وتحتها نرسم:

**B2C Admin → Catalog → Customers → Orders → Marketing → Learning → Analytics → Finance**

ثم بعد ذلك نحولها إلى **Modules → Epics → Features → User Stories** ونبدأ تنفيذها مع المبرمج بشكل منظم.

وبهذا لن يكون المشروع «نطوّر الموقع القديم»، بل سنكون فعلياً نبني **Mastery B2C 2.0 كنظام تجاري وتعليمي مستقل داخل منظومة ماستري**.

Sources

Yesterday 7:12 PM

Uploaded a file

اليك الاجابات

![Generated image: Grayscale E-Commerce Wireframe Board](https://sdmntprnznorth.oaiusercontent.com/files/00000000-c1d4-820b-b58a-97eba5a6d374/raw?se=2026-09-17T08%3A25%3A15Z&sp=r&sv=2026-02-06&sr=b&scid=d91fd06f-dbe9-492f-871d-9667480b044d&skoid=456594af-533f-44ef-9bdc-35ea2f9daee5&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2026-09-17T06%3A40%3A22Z&ske=2026-09-18T06%3A40%3A22Z&sks=b&skv=2026-02-06&sig=v6291wlldHUA/z73nZiQHRnx64%2BhL6KkTjcHhrY80mc%3D)

![](https://sdmntprnznorth.oaiusercontent.com/files/00000000-c1d4-820b-b58a-97eba5a6d374/raw?se=2026-09-17T08%3A25%3A15Z&sp=r&sv=2026-02-06&sr=b&scid=d91fd06f-dbe9-492f-871d-9667480b044d&skoid=456594af-533f-44ef-9bdc-35ea2f9daee5&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2026-09-17T06%3A40%3A22Z&ske=2026-09-18T06%3A40%3A22Z&sks=b&skv=2026-02-06&sig=v6291wlldHUA/z73nZiQHRnx64%2BhL6KkTjcHhrY80mc%3D)

![](https://sdmntprnznorth.oaiusercontent.com/files/00000000-c1d4-820b-b58a-97eba5a6d374/raw?se=2026-09-17T08%3A25%3A15Z&sp=r&sv=2026-02-06&sr=b&scid=d91fd06f-dbe9-492f-871d-9667480b044d&skoid=456594af-533f-44ef-9bdc-35ea2f9daee5&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2026-09-17T06%3A40%3A22Z&ske=2026-09-18T06%3A40%3A22Z&sks=b&skv=2026-02-06&sig=v6291wlldHUA/z73nZiQHRnx64%2BhL6KkTjcHhrY80mc%3D)

Edit

نعم. بما أننا وصلنا حتى **Master Product Backlog**، فالمشروع أصبح معرّفاً على مستوى الرؤية والمنتج والوظائف، لكن ما يزال أمامنا تحويله من Product Blueprint إلى مشروع قابل للتنفيذ والإطلاق.

أرتب لك **كل الخطوات المتبقية من مكاننا الحالي وحتى ما بعد الإطلاق**، ثم تستطيع اختيار أين تريد أن نذهب.

## أين وصلنا الآن؟

|المرحلة|الحالة|
|---|---|
|Product Definition|✅|
|System Architecture|✅|
|Core Data Model|✅|
|LMS Integration Concept|✅|
|Customer Journeys|✅|
|Admin Architecture|✅|
|Information Architecture / Sitemap|✅|
|Wireframe Direction|✅ مبدئياً|
|Master Product Backlog|✅|
|Release Planning|⬜|
|Detailed PRD / Stories|⬜|
|Technical Design|⬜|
|UI Design|⬜|
|Development Planning|⬜|
|QA / Launch|⬜|

---

# المراحل المتبقية

|#|المرحلة|ماذا ننجز فيها؟|المخرج النهائي|
|---|---|---|---|
|**1**|**Scope & Prioritization**|تحديد ما يدخل V1 وما يؤجل، وتصنيف Must / Should / Later|Scope نهائي|
|**2**|**Release Plan**|تقسيم المشروع إلى Releases ومراحل إطلاق منطقية حسب Dependencies|R0 / R1 / R2…|
|**3**|**Development Sequencing**|تحديد ترتيب بناء الـEpics والـFeatures بحيث لا يبدأ الفريق بشيء يعتمد على شيء غير موجود|Dependency Map|
|**4**|**Detailed PRD**|كتابة المتطلبات الوظيفية التفصيلية لكل Module|PRD قابل للتطوير|
|**5**|**User Stories**|تحويل الـBacklog إلى Stories مثل: As a customer…|Jira-ready Stories|
|**6**|**Acceptance Criteria**|تحديد متى تعتبر كل Story مكتملة فعلاً|Testable criteria|
|**7**|**Business Rules Catalogue**|توثيق كل القواعد الدقيقة: Refund، Rewards، Subscription، Entitlements، Bundles…|Rule Book|
|**8**|**Detailed ERD & Database Schema**|تحويل الـLogical Data Model إلى Tables/Relations/Indexes/Constraints فعلية|ERD + DB Schema|
|**9**|**API & Integration Contracts**|تعريف APIs والـpayloads والـwebhooks مع LMS وStripe وTolt وMeet وغيرها|API Specification|
|**10**|**Technical Architecture Finalization**|اختيار Stack، Auth، DB، queue، caching، hosting، storage، search، observability…|Technical Design Document|
|**11**|**Security & Permissions Design**|RBAC، secrets، webhook signatures، admin security، rate limiting، data access|Security Specification|
|**12**|**High-Fidelity UX/UI**|تحويل الـWireframes إلى التصميم النهائي الحقيقي للموقع والـAdmin والموبايل|Figma/UI|
|**13**|**Design System**|Buttons، typography، cards، forms، states، spacing، RTL، reusable components|Mastery Design System|
|**14**|**Content Model & Migration Plan**|كيف ننقل مئات الدورات والأسعار والمدربين والـSEO من النظام الحالي|Migration Map|
|**15**|**Analytics Measurement Plan**|Event taxonomy، GA4، Pixels، funnels، attribution، naming conventions|Tracking Plan|
|**16**|**SEO Migration Plan**|URLs القديمة، redirects، metadata، sitemap، canonical، منع فقدان Google traffic|SEO Migration Plan|
|**17**|**QA & Testing Strategy**|Unit / Integration / E2E / Payment / LMS / permissions / regression|Master Test Plan|
|**18**|**Test Cases**|سيناريوهات اختبار فعلية لكل Journey وEdge Case|QA Cases|
|**19**|**Performance & Reliability Plan**|Core Web Vitals، load، retries، queues، timeouts، monitoring|NFR Specification|
|**20**|**Data Migration & Reconciliation**|نقل العملاء، الطلبات المطلوبة، access، المنتجات، وربط LMS IDs|Migration Runbook|
|**21**|**UAT – Business Acceptance**|فريق ماستري يجرب النظام كما لو كان حقيقياً|UAT Sign-off|
|**22**|**Launch Readiness Review**|مراجعة شاملة قبل الإطلاق|Go/No-Go Checklist|
|**23**|**Cutover Plan**|متى يتوقف النظام القديم؟ ماذا يحدث للطلبات المفتوحة؟ كيف يتم DNS/Traffic switch؟|Cutover Runbook|
|**24**|**Go-Live**|تشغيل المنصة الجديدة ومراقبتها المكثفة|Production Launch|
|**25**|**Hypercare**|أول 1–2 أسبوع: متابعة الأخطاء، المدفوعات، LMS، Conversion، Support|Stabilization|
|**26**|**Post-launch Optimization**|تحسين Conversion، Search، Offers، Funnels، UX|Growth Backlog|
|**27**|**R2/R3 Development**|Community، Rewards، AI، advanced personalization وغيرها وفق ترتيبكم|Continuous Roadmap|

---

# أهم 7 مراحل أمامنا فعلياً

لو أردنا تجاهل التفاصيل الإجرائية والنظر للمشروع من مستوى CEO/Product Owner، فالمتبقي هو:

**Backlog → Prioritization → Release Plan → Detailed Specifications → Technical & UI Design → Development & Testing → Launch & Optimization**

وأنت الآن تحديداً تقف بين:

> **Master Backlog**

و:

> **Prioritized Release Plan**

وهذه نقطة مهمة؛ لأن أكبر خطأ الآن سيكون أن نعطي الـ300 Feature للمبرمج ونقول له «ابدأ».

يجب أولاً تحديد:

**ما أول شيء نبنيه؟ ما الذي يعتمد عليه؟ ما الذي يدخل النسخة الأولى؟ وما الذي يمكن تأجيله دون الإضرار برؤية المشروع؟**

---

# هناك أربعة مسارات منطقية تستطيع اختيار أحدها الآن

### المسار A — Release Plan

إذا كان هدفك **بدء التنفيذ قريباً**، فهذا أفضل اختيار الآن.

سأحول الـBacklog إلى:

**Foundation → Core Commerce → Expansion → Community/Rewards → Growth**

وأحدد بالضبط ما يدخل كل Release، Dependencies، والـGo-Live Scope.

### المسار B — Detailed PRD

إذا أردت **توثيق المشروع كاملاً قبل أن يلمس المبرمج الكود**، نأخذ Module Module ونكتب كل Requirement وBusiness Rule وAcceptance Criteria.

مثلاً نبدأ:

`Product → Offer → Cart → Checkout → Order → Payment → Entitlement`

### المسار C — Technical Specification

إذا كان المبرمج جاهزاً ويريد أن يعرف **كيف يبني النظام تقنياً**، نبدأ:

ERD  
Database Schema  
API Contracts  
Events  
Queues  
Auth  
Integrations  
Hosting  
Security.

### المسار D — UI/UX

إذا كنت تريد أولاً أن **ترى المنصة كاملة أمامك**، ننتقل إلى High-Fidelity UX/UI Specifications لكل شاشة، بدءاً بالـConversion Core.

---

## ترتيبي المفضل من هنا

بالنسبة لماستري، أوصي بهذا التسلسل:

> **1. Prioritization & Release Plan**  
> **2. Business Rules Catalogue**  
> **3. Detailed PRD + Acceptance Criteria**  
> **4. Technical ERD/API Specification**  
> **5. Final UI/Design System**  
> **6. Development Sprint Plan**  
> **7. QA / Migration / Launch**

وأرى أن **Release Plan هو الخطوة الأنسب الآن**؛ لأنه سيحوّل هذه الرؤية الكبيرة إلى مشروع يمكن إدارته فعلياً، ويمنعنا من محاولة بناء كل شيء في نفس الوقت.

اشتغلي على Detailed PRD / Stories كاملة

ممتاز. سأعتبر النص التالي **Mastery B2C Detailed PRD + User Stories v1.0**، وهو الوثيقة التنفيذية التي تأتي بعد Product Definition والـArchitecture والـBacklog.

الغرض منها أن يستطيع Product Owner، المبرمج، المصمم، وQA الرجوع إليها وفهم **ماذا يجب أن يفعل النظام، ولماذا، ومتى نعتبر الـFeature مكتملة**.

هذه الوثيقة لا تدخل بعد في أسماء الجداول أو تفاصيل الـAPI النهائية؛ تلك تأتي في Technical Specification. لكنها مفصلة بما يكفي لتحويلها مباشرة إلى Jira Epics / Stories / Acceptance Criteria.

# Mastery Academy B2C

## Detailed Product Requirements Document & User Stories

### Version 1.0

---

# 1. Product Vision

Mastery B2C منصة تجارة تعليمية عربية متكاملة تتيح للأفراد اكتشاف وشراء والاستفادة من منتجات ماستري وخدماتها، وتشمل:

**Courses، Diplomas، Live Programs، Bundles، Subscriptions، Consultations، Community، Add-ons.**

المنصة مسؤولة عن الجانب التجاري والبيعي والتشغيلي، بينما يبقى الـLMS الحالي مسؤولاً عن استهلاك المحتوى التعليمي والتقدم والاختبارات وغيرها من وظائف التعلم الموجودة.

رحلة المنتج العليا:

```
Discover
   ↓
Evaluate
   ↓
Purchase
   ↓
Payment
   ↓
Entitlement
   ↓
Fulfillment
   ↓
Learning / Service Access
   ↓
Engagement
   ↓
Repeat Purchase
```

---

# 2. Product Goals

الأهداف الرئيسية:

1. رفع Conversion Rate.
2. زيادة Average Order Value.
3. زيادة Repeat Purchase Rate.
4. رفع Customer Lifetime Value.
5. إنشاء Recurring Revenue عبر الاشتراكات.
6. توسيع الإيرادات إلى خدمات غير الدورات مثل Community وConsultations.
7. تمكين فريق الأعمال من تشغيل B2C دون الاعتماد اليومي على المطورين.
8. تقليل أخطاء الدفع والوصول والمزامنة.
9. بناء منصة قابلة لإضافة منتجات ونماذج إيراد مستقبلية.
10. توفير Full Observability لكل العمليات الحساسة.

---

# 3. Out of Scope

لا يشمل المشروع:

- إعادة بناء LMS.
- إعادة بناء Student Learning Profile.
- B2B Platform.
- Video Player.
- Exams engine الحالي.
- Learning progress engine.
- بناء بوابة دفع.
- بناء Video conferencing.
- بناء Affiliate platform بديلة لـTolt.
- Tax Engine مستقل إذا كانت Stripe توفر المطلوب.
- Public Reviews.
- Social network عامة خارج سياق Community.

---

# 4. المستخدمون الرئيسيون

### Customer / Visitor

الزائر أو المشتري النهائي.

### Product Manager

يدير المنتجات والباقات والاشتراكات.

### Marketing Team

يدير العروض، الصفحة الرئيسية، الحملات، Landing Pages.

### Customer Support

يرى العملاء والطلبات والوصول ويساعد في حل المشاكل.

### Finance

يدير المدفوعات والاستردادات.

### Consultation Manager

يدير المستشارين والحجوزات.

### Community Manager

يدير الأعضاء والمحتوى والمجتمع.

### Operations

يعالج Failed Fulfillments والمشاكل التشغيلية.

### Super Admin

صلاحيات شاملة.

---

# 5. Global Business Rules

هذه القواعد تعتبر ثابتة في كل النظام.

|المجال|القاعدة|
|---|---|
|Course access|سنة افتراضياً|
|Diploma access|سنة افتراضياً|
|Extension|3 أشهر / سنة / Lifetime|
|Course monthly purchase|غير مسموح|
|Subscription|شهري أو سنوي|
|Choose-X|سنوي فقط|
|Choose-X replacement|مسموح قبل Start Learning فقط|
|Choose-X rollover|غير مسموح|
|Subscription benefits rollover|غير مسموح|
|Community|لا تأتي تلقائياً مع Course|
|Reviews|Verified customer only|
|Reviews visibility|داخلية فقط|
|Rewards earn|10 points / $1 paid|
|Rewards value|1000 points = $10|
|Rewards expiry|لا يوجد|
|Rewards cash withdrawal|ممنوع|
|Split payment|Points + Payment Provider|
|Consultation reschedule|حتى 6 ساعات قبل الموعد|
|Customer consultation cancellation|لا Refund تلقائي|
|Stripe|Payment/Tax/Invoices main provider|
|LMS|Learning Source of Truth|
|B2C|Commercial Source of Truth|

---

# EPIC 01 — Authentication & Identity

## الهدف

إنشاء تجربة دخول بدون Password وتقليل الاحتكاك أثناء الشراء.

### AUTH-01 — تصفح بدون تسجيل

**User Story**

بصفتي زائراً أريد تصفح ماستري والبحث ورؤية المنتجات دون إنشاء حساب.

**Acceptance Criteria**

- يستطيع Visitor دخول جميع صفحات المنتجات العامة.
- يستطيع استخدام Search وFilters.
- يستطيع Add to Cart.
- لا يتم إجباره على Login قبل Checkout أو وظيفة تحتاج هوية.

---

### AUTH-02 — Email OTP

بصفتي عميلاً أريد الدخول باستخدام بريدي وكود OTP دون كلمة مرور.

**Acceptance Criteria**

- يدخل المستخدم Email.
- يرسل النظام OTP.
- الكود له مدة صلاحية محدودة.
- الكود لا يمكن استخدامه أكثر من مرة.
- إذا كان المستخدم موجوداً يتم تسجيل الدخول.
- إذا لم يكن موجوداً يتم إنشاء الحساب المناسب.

---

### AUTH-03 — Mobile OTP

نفس منطق Email OTP باستخدام الهاتف.

**Acceptance Criteria**

- يدعم Country Code.
- يتحقق من تنسيق الهاتف.
- يمنع Abuse عبر Rate Limit.
- يتم ربط Mobile verified بالحساب.

---

### AUTH-04 — Google Sign-in

- يمكن الدخول بحساب Google.
- إذا تطابق البريد مع حساب موجود يتم Identity Linking الآمن.
- لا يتم إنشاء Duplicate Customer دون حاجة.

---

### AUTH-05 — Anonymous Cart Merge

عند Login يجب نقل Cart الزائر إلى حساب العميل.

**Acceptance Criteria**

- لا تضيع المنتجات.
- تمنع المنتجات المكررة.
- يعاد احتساب الأسعار.
- يتم التحقق من ownership بعد Login.

---

# EPIC 02 — Customer

### CUS-01 — إنشاء Customer Profile تجاري

يجب إنشاء Customer record مرتبط بـUser.

يحتوي على:

Name، Email، Mobile، Country، Acquisition data، timestamps.

---

### CUS-02 — Customer 360

بصفتي موظف Support أريد رؤية العلاقة التجارية الكاملة مع العميل.

يجب عرض:

- Orders.
- Payments.
- Products.
- Entitlements.
- Subscriptions.
- Consultations.
- Community.
- Rewards.
- Refunds.

---

# EPIC 03 — Product Catalog

## Product Types

يجب دعم:

`Course`

`Diploma`

`Live Program`

`Bundle`

`Subscription`

`Consultation`

`Community`

---

### CAT-01 — Create Product

Product Manager يستطيع إنشاء Product.

البيانات الأساسية:

- Product Type.
- Title.
- Slug.
- Short Description.
- Full Description.
- Media.
- Category.
- Level.
- Job Level.
- Delivery Type.
- Duration.
- Instructor.
- Status.

---

### CAT-02 — Product Lifecycle

الحالات:

`Draft`

`Published`

`Unpublished`

`Archived`

لا يتم Hard Delete للمنتجات التي لديها معاملات تاريخية.

---

### CAT-03 — Categories

- Product يمكن أن ينتمي لأكثر من Category.
- Category لها Name/Slug/SEO.
- يمكن استخدامها في Filters وLanding Pages.

---

### CAT-04 — Product Publish Validation

قبل Publish يجب التحقق من Critical Fields.

مثلاً Course مدفوعة لا تنشر بدون:

- Title.
- Active Offer.
- LMS Mapping.
- Image.
- Required commercial data.

---

# EPIC 04 — LMS Mapping

### LMS-01 — Map Product to LMS

Course أو Diploma يمكن ربطها بـLMS resources.

Course:

```
B2C Product
→ LMS Course
```

Diploma:

```
B2C Diploma
→ LMS Course A
→ LMS Course B
→ LMS Course C
```

---

### LMS-02 — Create Enrollment

بعد منح Entitlement يجب إنشاء Enrollment في LMS عند الحاجة.

**Acceptance Criteria**

- Payment success وحده لا يعتمد على browser return.
- Enrollment يتم عبر LMS Adapter.
- الفشل لا يلغي الدفع.
- الفشل يدخل Retry Queue.

---

### LMS-03 — Course Started Event

يجب استقبال `course.started`.

يستخدم خصوصاً في Choose-X.

- event يجب أن يكون idempotent.
- يربط user + course.
- بعده تصبح selection غير قابلة للاستبدال.

---

### LMS-04 — Completion Event

يستقبل B2C completion عند توفرها.

يمكن استخدامها لاحقاً في:

Feedback، Certificates، Notifications.

---

# EPIC 05 — Experts

### EXP-01 — Expert Profile

Expert يمكن أن يكون:

Instructor  
Consultant  
Both.

يحتوي:

- Name.
- Photo.
- Professional Title.
- Bio.
- Expertise.
- Social Links.

---

### EXP-02 — Public Expert Page

تعرض:

Courses  
Diplomas  
Live Programs  
Consultation Services.

---

# EPIC 06 — Offers & Pricing

### OFF-01 — Offer Entity

كل Product يمكن أن يكون له Offer واحدة أو أكثر.

Offer تحدد:

- Price.
- Currency.
- Billing Type.
- Billing Interval.
- Access Duration.
- Validity.
- Status.

---

### OFF-02 — One-time Offer

يدعم Course/Diploma/Bundle/etc.

---

### OFF-03 — Recurring Offer

يدعم:

Monthly  
Annual.

---

### OFF-04 — Price History Integrity

Order يجب أن يحتفظ بالسعر وقت الشراء.

تغيير السعر لاحقاً لا يغير الطلب القديم.

---

# EPIC 07 — Search & Discovery

### SRCH-01 — Global Search

البحث يشمل:

- Courses.
- Diplomas.
- Bundles.
- Live Programs.
- Experts.
- Consultants.
- Consultation Services.

---

### SRCH-02 — Filters

يدعم:

Category  
Product Type  
Level  
Job Level  
Duration  
Delivery Type  
Price  
Certification  
Instructor  
Subscription eligibility  
Live date.

---

### SRCH-03 — Sorting

يدعم على الأقل:

Relevance  
Newest  
Popular  
Price إذا كان مناسباً.

---

### SRCH-04 — Zero Results

إذا لا توجد نتيجة:

- لا تظهر Empty Page فقط.
- تعرض Related Categories.
- Suggested Products.
- Popular Products.

---

# EPIC 08 — Product Detail Pages

### PDP-01 — Course Page

تتضمن:

- Title.
- Instructor.
- Commercial Offer.
- Outcomes.
- Audience.
- Requirements.
- Curriculum.
- Duration.
- Level.
- Certificates.
- CPD.
- Add-ons.
- Related products.
- Subscription availability.
- CTA.

---

### PDP-02 — Dynamic Ownership State

إذا العميل يمتلك Course:

> ابدأ التعلم

بدلاً من:

> اشتر الآن.

إذا انتهت:

> مدد الوصول.

---

### PDP-03 — Diploma Page

تدعم:

Recorded  
Live  
Hybrid.

وتعرض البرنامج ومكوناته وCohort عند الحاجة.

---

### PDP-04 — Reviews Hidden

لا تظهر Rating أو Reviews للعامة تحت أي حالة.

---

# EPIC 09 — Cart

### CART-01 — Add to Cart

- Visitor وCustomer يستطيعان الاستخدام.
- يتم ربط Offer وليس Product فقط.
- يعاد احتساب السعر Server-side.

---

### CART-02 — Remove Item

يسمح بالحذف وإعادة الإجمالي.

---

### CART-03 — Buy Now

ينتقل مباشرة إلى Checkout دون المرور بسلة منفصلة.

---

### CART-04 — Existing Ownership Detection

إذا العميل يمتلك Product فعالة، يجب منع الشراء غير المقصود أو تنبيهه حسب النوع.

---

# EPIC 10 — Checkout

### CHK-01 — Unified Checkout

يجب استخدام Checkout Engine واحدة لكل المنتجات.

وتتعامل مع Context مختلف:

Course  
Subscription  
Consultation  
Cohort  
Bundle.

---

### CHK-02 — Price Breakdown

يجب عرض:

Subtotal  
Promotion  
Coupon  
Rewards  
Tax  
Final Amount.

---

### CHK-03 — Server-side Validation

قبل الدفع يعاد التحقق من:

- Price.
- Product availability.
- Offer status.
- Coupon.
- Rewards.
- Cohort availability.
- Consultation slot.

---

### CHK-04 — Payment Failure Recovery

إذا فشل الدفع:

- السلة لا تضيع.
- Rewards المحجوزة تعاد.
- يمكن Retry.
- يمكن تغيير Payment Method.

---

# EPIC 11 — Payments

### PAY-01 — Stripe

يدعم:

Cards  
Apple Pay  
Google Pay.

---

### PAY-02 — Tabby

يدعم كPayment Provider إضافي.

---

### PAY-03 — Tamara

نفس المبدأ.

---

### PAY-04 — Payment Webhook

الحقيقة النهائية لنجاح العملية تأتي من Provider Webhook وليس فقط Browser.

---

### PAY-05 — Idempotency

إذا وصل webhook عدة مرات:

- لا ينشأ Order جديد.
- لا تمنح Entitlement إضافية.
- لا تضاعف Rewards.

---

# EPIC 12 — Orders

### ORD-01 — Create Order

يحتوي:

Customer  
Items  
Currency  
Subtotal  
Discounts  
Rewards  
Tax  
Total  
Paid Amount.

---

### ORD-02 — Order Item Snapshot

يحفظ:

Product title  
Offer  
Price  
Access terms  
Add-ons.

---

### ORD-03 — Separate Statuses

Order Status.

Payment Status.

Fulfillment Status.

يجب ألا تدمج في Status واحدة.

---

### ORD-04 — Order Confirmation

حسب Product Type يظهر CTA مناسب:

Course → Start Learning.

Subscription → Explore Benefits.

Consultation → View Booking.

Community → Enter Community.

---

# EPIC 13 — Entitlement Engine

### ENT-01 — Grant Entitlement

Entitlement تحدد:

Customer  
Resource  
Source  
Start  
Expiry  
Status.

---

### ENT-02 — Multiple Active Entitlements

إذا العميل يمتلك Product من:

Purchase  
Subscription  
Bundle

يكفي وجود Entitlement واحدة Active للسماح بالوصول.

---

### ENT-03 — Entitlement Source

يجب دائماً معرفة مصدر الحق:

Order  
Subscription  
Bundle  
Admin Grant.

---

### ENT-04 — Lifetime

`expires_at = null`

مع access type lifetime.

---

### ENT-05 — Manual Grant

موظف مخول يستطيع منح Access.

Reason إجباري.

يسجل Audit.

---

# EPIC 14 — Fulfillment Engine

### FUL-01 — Fulfillment Tasks

عملية شراء واحدة قد تنشئ عدة Tasks.

مثال Bundle:

- Enroll Course A.
- Enroll Course B.
- Grant Community.
- Grant Consultation Credit.

---

### FUL-02 — Retry

إذا فشل External Service:

Pending → Failed → Retrying → Success.

---

### FUL-03 — Manual Intervention

بعد عدد محاولات محدد تنتقل المهمة إلى Operations Queue.

---

# EPIC 15 — Access Extensions

### EXT-01 — Extension Options

الخيارات فقط:

3 Months  
12 Months  
Lifetime.

---

### EXT-02 — Pricing

يمكن تحديد السعر لكل Product ولكل خيار.

---

### EXT-03 — Extension Purchase

بعد الدفع:

- يتم تحديث Entitlement.
- يتم تحديث LMS expiry.
- تسجل Extension History.

---

# EPIC 16 — Bundles

### BND-01 — Composite Bundle

Bundle تستطيع احتواء:

Course  
Diploma  
Consultation  
Community  
Live Program  
Add-on.

---

### BND-02 — Bundle Builder

Admin يستطيع:

- إضافة المكونات.
- تحديد quantity.
- تحديد السعر.
- ترتيب المكونات.
- Preview.

---

### BND-03 — Bundle Fulfillment

بعد الشراء تنشأ جميع الحقوق المناسبة.

---

### BND-04 — Customer Success Summary

صفحة النجاح توضح للعميل بوضوح كل ما حصل عليه.

---

# EPIC 17 — Subscription Engine

### SUB-01 — Monthly Subscription

يدعم Auto-renewal.

---

### SUB-02 — Annual Subscription

يدعم Auto-renewal.

---

### SUB-03 — Fixed Benefits

يمكن للPlan منح Products محددة.

---

### SUB-04 — Full Library Access

يمكن للPlan منح Library كاملة.

يفضل دعم Lazy LMS Enrollment إذا كان مناسباً تقنياً.

---

### SUB-05 — Generic Benefits

Benefit يمكن أن تكون:

Product Access  
Community  
Consultation  
Live Program  
Selection Allowance  
Discount.

---

### SUB-06 — Subscription Expiry

عند انتهاء Subscription تنتهي الحقوق الناتجة عنها فقط.

لا تتأثر الحقوق المملوكة من مصادر أخرى.

---

### SUB-07 — Cancel at Period End

عند إلغاء التجديد:

- لا ينتهي الوصول فوراً.
- يبقى حتى نهاية الفترة.

---

### SUB-08 — Plan Versioning

إذا عدلت Benefits:

يتم إنشاء Version جديدة.

المشتركون القدامى لا يتغيرون تلقائياً.

---

# EPIC 18 — Choose-X

### CHX-01 — Annual Only

Choose-X لا يعمل شهرياً.

---

### CHX-02 — Selection Allowance

مثلاً:

10 selections/year.

---

### CHX-03 — Partial Selection

لا يجب إجبار المستخدم على اختيار كل الدورات فوراً.

---

### CHX-04 — Replacement

إذا `learning_started=false`:

يمكن الاستبدال.

إذا `true`:

لا يمكن.

---

### CHX-05 — Renewal

عند التجديد:

يتم إنشاء Allowance جديدة بالكامل.

لا يوجد rollover.

---

# EPIC 19 — Live Programs / Cohorts

### LIV-01 — Multiple Cohorts

Product واحدة يمكن أن تحتوي عدة دفعات.

---

### LIV-02 — Cohort Fields

Start  
End  
Registration Start  
Registration End  
Capacity  
Status.

---

### LIV-03 — Sessions

كل Cohort تحتوي Sessions.

---

### LIV-04 — Capacity

يجب منع تسجيل يزيد عن السعة.

---

### LIV-05 — Sold Out

إذا امتلأت:

CTA → Join Waitlist.

---

### LIV-06 — Waitlist

تسجيل العميل بقائمة الانتظار.

يمكن إخباره عند توفر مقعد.

---

# EPIC 20 — Consultations

### CON-01 — Consultant Services

المستشار الواحد يمكن أن يقدم عدة Services.

---

### CON-02 — Availability

يمكن إدارتها من:

Admin  
Consultant.

---

### CON-03 — Booking Flow

Service  
→ Date  
→ Time  
→ Checkout  
→ Payment  
→ Confirm.

---

### CON-04 — Double Booking Prevention

يجب إجراء Atomic Availability Check قبل التأكيد.

---

### CON-05 — Google Meet

بعد تأكيد الحجز:

ينشئ النظام Meet.

ويرسل invitations.

---

### CON-06 — Reschedule

Self-service فقط إذا بقي أكثر من 6 ساعات.

---

### CON-07 — Customer Cancel

لا يوجد Refund تلقائي.

---

### CON-08 — Consultant Cancellation

يتم تعليم الحجز كـConsultant Cancelled ويجب تمكين إعادة الجدولة.

---

# EPIC 21 — Add-ons & Certificates

### ADD-01 — Electronic Mastery Certificate

Included في Course purchases وفق completion logic.

---

### ADD-02 — Printed Mastery Certificate

Paid Add-on.

---

### ADD-03 — Digital CPD

يمكن أن يكون:

Included  
Paid.

---

### ADD-04 — Printed CPD

Paid دائماً.

---

### ADD-05 — Shipping

إذا Physical Product:

يجب جمع Shipping Address.

---

### ADD-06 — Physical Fulfillment

الحالات:

Pending  
Processing  
Shipped  
Delivered.

---

# EPIC 22 — Mastery Rewards

### RWD-01 — Earn

كل:

`$1 actually paid = 10 points`.

---

### RWD-02 — Redemption

`1000 points = $10`.

---

### RWD-03 — No Expiry

النقاط لا تنتهي.

---

### RWD-04 — No Wallet

لا يوجد balance مالي مستقل.

النقاط فقط.

---

### RWD-05 — Split Payment

مثال:

Product = $100.

Customer = 1000 points.

Points discount = $10.

Card payment = $90.

---

### RWD-06 — Earn on Paid Portion

في المثال السابق يحصل العميل على:

900 points.

---

### RWD-07 — Reservation During Payment

عند استخدام النقاط:

يتم حجزها مؤقتاً حتى نتيجة الدفع.

إذا فشل الدفع:

تعاد.

---

### RWD-08 — History

العميل يرى:

Earned  
Used  
Restored  
Reversed.

---

# EPIC 23 — Promotions

### PRM-01 — Percentage Discount

مثال:

20%.

---

### PRM-02 — Fixed Discount

مثال:

$50.

---

### PRM-03 — Coupon

Code مرتبط بـPromotion.

---

### PRM-04 — Product / Category Rules

يمكن استهداف Product أو Category.

---

### PRM-05 — Date Rules

Start/End.

---

### PRM-06 — Usage Limits

Global وPer Customer.

---

### PRM-07 — Stacking

يجب تحديد هل Promotion يمكن جمعها مع أخرى.

---

### PRM-08 — Free Benefits

يمكن مستقبلاً أن تمنح:

Free Product  
Consultation  
Add-on  
CPD.

---

# EPIC 24 — Community

### COM-01 — Community Product

Community تباع كمنتج مستقل.

---

### COM-02 — Community via Subscription/Bundle

يمكن الحصول عليها Benefit.

---

### COM-03 — Spaces

أنواع المساحات تشمل:

General  
Discussion  
Course  
Cohort  
Events  
Networking.

---

### COM-04 — Course Space Rule

الدخول يتطلب:

Active Community Membership  
AND  
Active Course Entitlement.

---

### COM-05 — Cohort Space

يتطلب:

Community

- Cohort eligibility.

---

### COM-06 — Posts

Member يستطيع إنشاء Posts في Spaces المسموحة.

---

### COM-07 — Comments / Replies

---

### COM-08 — Reactions

---

### COM-09 — Member Directory

بحث وتصفية الأعضاء.

---

### COM-10 — Community Profile

يعرض:

Role  
Company  
Location  
Interests  
About  
Can Help With  
Looking For.

---

### COM-11 — Direct Messaging

الأعضاء يستطيعون التواصل وفق Privacy rules.

---

### COM-12 — Community Events

يمكن إنشاء Events وربطها بـSpace.

---

### COM-13 — Moderation

Report  
Remove content  
Warn  
Suspend  
Ban.

---

# EPIC 25 — Customer Commercial Account

### ACC-01 — Orders

العميل يرى طلباته.

---

### ACC-02 — Subscriptions

يرى:

Status  
Renewal  
Current period  
Plan.

---

### ACC-03 — Consultations

Upcoming / Past / Cancelled.

---

### ACC-04 — Rewards

Current points + history.

---

### ACC-05 — Community Membership

Status وSource وExpiry.

---

### ACC-06 — Existing LMS Link

يجب توفير انتقال واضح إلى تجربة التعلم الحالية.

---

# EPIC 26 — CMS & Merchandising

### CMS-01 — Dynamic Homepage

Homepage تتكون من Sections يتم التحكم بها من Admin.

---

### CMS-02 — Sections

مثلاً:

Hero  
Categories  
Featured  
Diplomas  
Live  
Bundles  
Community  
Consultations  
Offers.

---

### CMS-03 — Reordering

يمكن ترتيب Sections.

---

### CMS-04 — Scheduling

يمكن إظهار Banner أو Section لفترة محددة.

---

### CMS-05 — Landing Page Builder

Block-based وليس Page Builder معقداً.

Blocks:

Hero  
Text  
Image  
Video  
Products  
CTA  
FAQ  
Forms.

---

# EPIC 27 — Feedback

### FBK-01 — Verified Buyer Only

لا يستطيع شخص لم يحصل على Product إرسال تقييم.

---

### FBK-02 — Internal-only

Feedback لا تظهر للعملاء.

---

### FBK-03 — Rating + Comment

---

### FBK-04 — Analytics

يعرض:

Average  
Distribution  
Trends  
Lowest products  
Negative feedback.

---

# EPIC 28 — Refunds

### REF-01 — Full Refund

يدعم Provider Refund.

---

### REF-02 — Partial Refund

موظف مخول يستطيع تحديد المبلغ.

---

### REF-03 — Impact Preview

قبل تنفيذ Refund يجب توضيح:

Cash refund  
Points impact  
Entitlement impact.

---

### REF-04 — Rewards Restoration

Points المستخدمة في الطلب تعود.

---

### REF-05 — Earned Points Reversal

النقاط المكتسبة من المبلغ المسترد يتم إلغاؤها.

---

### REF-06 — Failure Handling

إذا Provider refund فشل:

يدخل Operations Queue.

---

# EPIC 29 — Notifications

### NTF-01 — Order Confirmation

### NTF-02 — Payment Failure

### NTF-03 — Access Granted

### NTF-04 — Subscription Renewal

### NTF-05 — Subscription Renewal Failure

### NTF-06 — Consultation Booking

### NTF-07 — Consultation Reminder

### NTF-08 — Consultation Reschedule

### NTF-09 — Course Expiry

### NTF-10 — Waitlist Seat Available

### NTF-11 — Community Mention/Message

كل Notification يجب أن يكون لها:

Template  
Trigger  
Recipient  
Status  
Timestamp.

---

# EPIC 30 — Admin

## ADM-01 — Dashboard

يعرض:

Revenue  
Orders  
AOV  
Conversion  
Customers  
Subscriptions.

---

## ADM-02 — Needs Attention

يعرض:

Failed Fulfillment  
Refund failure  
Payment reconciliation  
Meet failure  
Physical fulfillment.

---

## ADM-03 — Products

Create/Edit/Publish/Archive.

---

## ADM-04 — Orders

Search + Detail.

---

## ADM-05 — Customer 360

---

## ADM-06 — Entitlements

View / Grant / Revoke.

---

## ADM-07 — Subscriptions

Plans  
Versions  
Subscribers.

---

## ADM-08 — Bundles

Builder + components.

---

## ADM-09 — Cohorts

Dates  
Capacity  
Sessions  
Enrollments.

---

## ADM-10 — Consultations

Calendar  
Services  
Bookings.

---

## ADM-11 — Community

Members  
Spaces  
Moderation.

---

## ADM-12 — Promotions

Campaign rules.

---

## ADM-13 — Rewards

Balance  
History  
Manual adjustment.

---

# EPIC 31 — RBAC

### SEC-01 — Roles

يجب دعم:

Super Admin  
Product  
Marketing  
Support  
Finance  
Consultation  
Community  
Operations  
Analyst.

---

### SEC-02 — Permissions

يجب أن تكون Granular مثل:

`orders.view`

`refunds.execute`

`products.publish`

`entitlements.grant`

`rewards.adjust`

`promotions.manage`

---

### SEC-03 — Sensitive Operations

لا يحق لكل موظف:

Refund  
Lifetime Access  
Rewards Adjustment  
Pricing config.

---

# EPIC 32 — Audit Log

يجب تسجيل العمليات الحساسة.

مثال:

```
Actor: Sara
Action: Refund Order #3812
Before: Paid $500
After: Refunded $500
Timestamp
```

ينطبق على:

Prices  
Refunds  
Promotions  
Entitlements  
Rewards  
Subscriptions  
Consultations.

---

# EPIC 33 — Operations Center

### OPS-01 — Incident Queue

كل فشل تشغيلي ينشئ Incident.

---

### OPS-02 — Failed LMS Enrollment

يظهر:

Order  
Customer  
Attempts  
Last Error.

---

### OPS-03 — Retry

يمكن تنفيذ Retry يدوياً.

---

### OPS-04 — Resolve

يمكن Mark Resolved مع note.

---

### OPS-05 — External Failures

يشمل:

LMS  
Meet  
Payment  
Refund  
Subscription sync.

---

# EPIC 34 — Analytics

الأحداث الأساسية:

`view_item`

`search`

`add_to_cart`

`begin_checkout`

`apply_coupon`

`use_rewards`

`payment_attempt`

`payment_failed`

`purchase`

`subscription_started`

`subscription_renewed`

`consultation_booked`

`community_joined`

---

## Integrations

GA4  
Meta Pixel  
Google Ads  
TikTok  
Clarity.

---

# EPIC 35 — Observability

يجب توفير:

Logs  
Metrics  
Errors  
Traces حيث يلزم  
API latency  
DB performance  
External API performance  
Webhook status  
Job status.

كل Request حساسة يجب أن تحمل Correlation data مثل:

`request_id`

`customer_id`

`order_id`

`event_id`

---

# EPIC 36 — SEO

### SEO-01

Clean URLs.

### SEO-02

Meta title/description.

### SEO-03

Canonical.

### SEO-04

Sitemap.

### SEO-05

Structured Data.

### SEO-06

Course Schema عند الملاءمة.

### SEO-07

SSR / pre-rendering المناسب.

### SEO-08

Core Web Vitals.

---

# EPIC 37 — Affiliate

Tolt هو Source of Truth.

B2C مسؤول عن:

Attribution capture  
Conversion send  
Order value  
Refund adjustment إذا طلب Tolt.

لا نبني Affiliate management داخلياً.

---

# 6. Non-Functional Requirements

## Performance

يجب استهداف:

- صفحات أساسية سريعة على Mobile.
- عدم تحميل Catalog كاملة دفعة واحدة.
- استخدام caching حيث يناسب.
- Search سريع حتى مع نمو المكتبة.

---

## Reliability

العمليات المالية يجب أن تكون idempotent.

External failures لا تضيع المعاملة.

يجب وجود retries.

---

## Security

- Signed webhooks.
- Secrets لا تظهر في Admin.
- RBAC.
- Sensitive logs لا تحتوي بيانات دفع سرية.
- Rate limiting للـOTP والواجهات الحساسة.
- Secure session management.

---

## Accessibility

واجهات أساسية يجب أن تراعي:

Keyboard access  
Labels  
Contrast  
Semantic structure.

---

## Mobile

كل تجربة B2C العامة يجب أن تكون Mobile-first.

خصوصاً:

Product Page  
Cart  
Checkout  
Search.

---

## Arabic / RTL

العربية هي اللغة الأساسية.

كل Component يجب أن يعمل RTL بشكل أصيل.

---

# 7. Global Error Handling

كل شاشة أو Flow يجب أن تحتوي حالات:

**Loading**

**Success**

**Empty**

**Validation Error**

**System Error**

**Permission Error**

**External Integration Error**

ولا نكتفي بالـHappy Path.

---

# 8. Definition of Done

لا تعتبر أي Story مكتملة إلا إذا:

|البند|مطلوب|
|---|---|
|Functional requirement يعمل|✅|
|Acceptance criteria مكتملة|✅|
|Permission checked|✅|
|Error states|✅|
|Loading states|✅|
|Empty states|✅|
|Mobile checked|✅|
|Analytics event|✅ إذا ينطبق|
|Audit event|✅ إذا حساس|
|Logging|✅|
|Retry|✅ إذا External|
|Staging tested|✅|
|Regression passed|✅|

---

# 9. Open Product Decisions

هذه نقاط لم نحسمها نهائياً، ويجب ألا يخترع المبرمج قراراً فيها من نفسه.

### Bundle + Existing Ownership

إذا اشترى العميل Bundle ويملك بالفعل Product منها، هل:

- يبقى السعر كما هو؟
- يحصل على Extension؟
- يسمح بالاستبدال؟
- يحصل على تعديل في السعر؟

**TBD**

### Community Billing

Standalone Community:

Monthly + Annual؟

أم Annual فقط؟

**TBD**

### Alumni Space

هل يستمر الوصول بعد انتهاء البرنامج؟

**TBD**

### Rewards Granularity

هل الاستبدال:

1,000 points increments فقط؟

أم يمكن مثلاً 1,500 = $15؟

**TBD**

### Shipping

طريقة احتساب Shipping للشهادات المطبوعة.

**TBD**

---

# 10. Story Dependency Backbone

هناك سلسلة يجب أن تبنى أولاً:

```
Identity
   ↓
Product
   ↓
Offer
   ↓
Cart
   ↓
Checkout
   ↓
Order
   ↓
Payment
   ↓
Entitlement
   ↓
Fulfillment
   ↓
LMS
```

هذه هي **Core Transaction Spine**.

لا ينبغي البدء مثلاً بـCommunity أو AI Bundle Builder قبل أن تصبح هذه السلسلة مستقرة.

---

# 11. Functional Release Boundaries

حتى لو قررنا لاحقاً إطلاق كل شيء معاً، من الأفضل تقنياً بناءه كمراحل.

### Foundation

Identity  
Catalog  
Offers  
Orders  
Entitlements  
Events  
LMS Integration.

### Commerce

Product Pages  
Search  
Cart  
Checkout  
Stripe  
Refunds  
Admin.

### Portfolio

Bundles  
Subscriptions  
Choose-X  
Live  
Consultations.

### Ecosystem

Community  
Rewards.

### Growth

Advanced promotions  
Landing pages  
Personalization  
AI.

---

# 12. Definition of Successful V1

يمكن اعتبار B2C الجديدة وظيفياً ناجحة عندما يستطيع عميل جديد تنفيذ الرحلة التالية من البداية للنهاية دون تدخل بشري:

```
Visit Mastery
   ↓
Discover a course
   ↓
Understand it
   ↓
Buy
   ↓
Login via OTP/Google
   ↓
Pay
   ↓
Receive confirmation
   ↓
Receive entitlement
   ↓
Be enrolled in LMS
   ↓
Start learning
```

وبالمقابل يستطيع موظف ماستري:

```
Create Product
   ↓
Set Price
   ↓
Publish
   ↓
Receive Order
   ↓
See Payment
   ↓
See Customer
   ↓
Resolve Fulfillment Problem
   ↓
Refund if needed
   ↓
Audit what happened
```

إذا كانت هاتان الرحلتان متماسكتين، فالأساس الذي بنيت عليه بقية المنصة صحيح.

---

# 13. الشكل المقترح لنقل هذه الوثيقة إلى Jira

أوصي بالترتيب:

**Project:** Mastery B2C

ثم:

**Epic → User Story → Acceptance Criteria → Technical Tasks**

مثلاً:

```
EPIC: Rewards

Story:
RWD-07 Apply Rewards at Checkout

Acceptance Criteria:
- User can see available points.
- User can choose to use them.
- Conversion follows configured rate.
- Remaining amount is sent to payment provider.
- Points are reserved during payment.
- Failure restores reserved points.
- Success finalizes deduction.
- Earned points are calculated only on paid amount.

Technical Tasks:
- Backend endpoint
- Rewards transaction logic
- Checkout UI
- Concurrency lock
- Analytics event
- Tests
```

وهكذا **لا نضع Technical Task في مستوى الـProduct Story نفسها**.

هذه الوثيقة الآن تمثل **Master Detailed PRD + Functional User Stories** للمشروع بأكمله. المرحلة الطبيعية بعدها، عندما ترغب، هي تفكيكها إلى **Jira-ready Stories واحدة واحدة بصيغة تنفيذية أدق تشمل Given / When / Then Acceptance Criteria والتبعيات والتقدير والأولوية لكل Story**، أو الانتقال مباشرة إلى **Technical ERD/API Specification** إذا أردت أن يبدأ المبرمج في البنية الداخلية.

اعطني ايضا brd

بالتأكيد. بما أننا أعددنا **PRD**، فمن المفيد جداً أن يكون لدينا أيضاً **BRD – Business Requirements Document** لأن وظيفته مختلفة.

الـ**BRD** يجيب أساساً عن: **لماذا نبني المشروع؟ ما المشكلة التجارية؟ ما النتائج المطلوبة؟ ما نطاق الأعمال؟ وما المتطلبات والقواعد التي يجب أن تحققها المنصة؟**  
أما الـPRD فيترجم ذلك لاحقاً إلى Features وUser Stories ومتطلبات منتج تفصيلية.

فيما يلي النسخة المقترحة الكاملة.

# Mastery Academy B2C Platform

## Business Requirements Document – BRD

### Version 1.0

---

## 1. معلومات الوثيقة

**اسم المشروع:** Mastery Academy B2C Platform Rebuild  
**الجهة:** Mastery Academy  
**نوع المشروع:** إعادة بناء شاملة لمنصة B2C  
**النطاق:** قطاع العملاء الأفراد فقط  
**المالك التجاري:** Mastery Academy Management / Product Owner  
**الأنظمة المرتبطة:** Existing LMS, Authentication System, Stripe, Tolt, Google, Tabby, Tamara وغيرها من التكاملات المعتمدة.

---

# 2. الغرض من الوثيقة

تهدف هذه الوثيقة إلى تحديد المتطلبات التجارية لمنصة Mastery Academy B2C الجديدة بصورة واضحة يمكن الرجوع إليها من قبل:

الإدارة العليا، Product Owner، فريق الأعمال، فريق التسويق، فريق التقنية، المالية، خدمة العملاء، Operations وأي طرف جديد ينضم للمشروع.

وتحدد الوثيقة:

- المشكلة والفرصة التجارية.
- أهداف المشروع.
- نطاق العمل.
- نماذج الإيراد.
- المنتجات والخدمات المطلوب دعمها.
- Business Requirements.
- Business Rules.
- Stakeholders.
- العمليات التشغيلية.
- مؤشرات النجاح.
- القيود والافتراضات.
- المخاطر.
- نقاط القرار المفتوحة.

---

# 3. خلفية الأعمال

تعمل ماستري أكاديمي في مجال التعليم الإلكتروني العربي وتقدم مجموعة كبيرة من المنتجات التعليمية والمهنية للأفراد والشركات.

قطاع B2C يخدم الأفراد الذين يشترون منتجات ماستري للاستخدام الشخصي، وتشمل المنتجات الحالية والمستقبلية:

الدورات، الدبلومات، البرامج المباشرة، الباقات، الاشتراكات، الاستشارات، المجتمع والخدمات الإضافية.

المنصة الحالية لا تعكس بالضرورة كامل الإمكانات التجارية والمنتجية التي تريد ماستري الوصول إليها مستقبلاً، كما أن النموذج الجديد يتطلب مرونة أكبر في:

البيع، العروض، الاشتراكات، الخدمات، الباقات، المكافآت، التسويق، إدارة العملاء والعمليات.

ولذلك تقرر **إعادة بناء B2C من الصفر** بدلاً من الاكتفاء بتحسين الواجهة الحالية.

---

# 4. المشكلة التجارية

المشكلة ليست في الحاجة إلى Website أجمل فقط.

المشكلة الأساسية هي أن قطاع B2C يحتاج إلى **Commercial Platform** تستطيع دعم نموذج أعمال ماستري الحالي والمستقبلي.

وتشمل الاحتياجات الرئيسية:

|الحاجة|الوضع المطلوب|
|---|---|
|تنوع المنتجات|عدم اقتصار النظام على Course|
|زيادة الإيرادات|Bundles، Subscriptions، Add-ons، Services|
|رفع Repeat Purchase|Rewards وCross-sell وRetention|
|الاشتراكات|نماذج مرنة وليس Full Library فقط|
|Live Programs|إدارة Cohorts حقيقية|
|الاستشارات|Booking & Payment متكامل|
|Community|منتج مستقل قابل للبيع|
|Marketing|تحكم أكبر بالعروض والصفحات|
|Operations|اكتشاف ومعالجة الأعطال التشغيلية|
|Admin|تقليل الحاجة للمبرمج|
|البيانات|قياس وتحليل الأداء التجاري|
|التوسع|بنية تسمح بإضافة منتجات مستقبلية|

---

# 5. الرؤية التجارية للمشروع

الرؤية هي تحويل Mastery B2C إلى:

> **منظومة تجارة تعليمية عربية متكاملة تمكّن العميل من اكتشاف وشراء والاستفادة من منتجات وخدمات ماستري المختلفة، وتوفر لماستري منصة تشغيل ونمو مرنة وقابلة للتوسع لسنوات قادمة.**

لا يجب النظر إلى المنتج الجديد على أنه متجر دورات فقط.

بل Ecosystem تجمع:

**Learning + Commerce + Services + Community + Retention.**

---

# 6. الأهداف التجارية

الأهداف الأساسية للمشروع هي:

### زيادة الإيرادات المباشرة

عن طريق تحسين تجربة الشراء وتقديم أنواع أكثر من المنتجات.

### زيادة Conversion Rate

تقليل الاحتكاك بين دخول العميل وإتمام عملية الشراء.

### زيادة Average Order Value

من خلال:

Bundles، Add-ons، Upselling، Cross-selling.

### رفع Repeat Purchase Rate

من خلال:

Rewards، Recommendations، Community، Extensions.

### رفع Customer Lifetime Value

بحيث لا تنتهي علاقة العميل مع ماستري عند شراء دورة واحدة.

### بناء Recurring Revenue

عبر الاشتراكات الشهرية والسنوية.

### تنويع مصادر الإيراد

بدلاً من الاعتماد على بيع الدورات فقط.

### زيادة الكفاءة التشغيلية

تمكين فريق الأعمال من إدارة العمليات دون تدخل تقني مستمر.

### تحسين الاعتمادية

خصوصاً في:

Payments، Enrollments، Refunds، Subscriptions، Consultations.

### تحسين اتخاذ القرار

من خلال Analytics وObservability.

---

# 7. نطاق المشروع

يشمل المشروع جميع العمليات التجارية الخاصة بقطاع B2C ابتداءً من اكتشاف العميل للمنتج وحتى منحه الوصول.

النطاق الرئيسي:

|المجال|داخل النطاق|
|---|---|
|Public Website|نعم|
|Search & Discovery|نعم|
|Product Pages|نعم|
|Cart|نعم|
|Checkout|نعم|
|Payments|نعم|
|Orders|نعم|
|Refunds|نعم|
|Courses Commerce|نعم|
|Diplomas Commerce|نعم|
|Bundles|نعم|
|Subscriptions|نعم|
|Live Programs|نعم|
|Cohorts|نعم|
|Consultations|نعم|
|Community|نعم|
|Rewards|نعم|
|Promotions|نعم|
|Add-ons|نعم|
|Certificates Commerce|نعم|
|CMS|نعم|
|Merchandising|نعم|
|Customer Commercial Area|نعم|
|Admin Dashboard|نعم|
|Analytics|نعم|
|Operations|نعم|
|LMS Integration|نعم|

---

# 8. خارج نطاق المشروع

لا يتضمن المشروع:

- إعادة بناء LMS.
- إعادة بناء Video Player.
- إعادة بناء نظام الاختبارات الموجود.
- إعادة بناء Progress Tracking.
- إعادة بناء Student Learning Profile.
- إعادة بناء B2B Platform.
- بناء Payment Gateway.
- بناء Tax Engine إذا كانت Stripe تفي بالمتطلبات.
- بناء Accounting System.
- بناء Affiliate Platform بديلة عن Tolt.
- بناء Zoom/Meet بديل.
- بناء CRM متكامل.
- بناء Social Network عامة.

---

# 9. أصحاب المصلحة

|Stakeholder|الاهتمام الرئيسي|
|---|---|
|CEO / Product Owner|النمو والرؤية والربحية|
|B2C Management|التشغيل والأداء|
|Product Team|تطوير المنتج|
|Marketing|Conversion والعروض والحملات|
|Sales / Customer Service|العميل والمشاكل|
|Finance|Payments وRefunds|
|Content Team|المنتجات التعليمية|
|Consultants|الاستشارات|
|Instructors|المحتوى والبرامج|
|Community Manager|المجتمع|
|Technical Team|التطوير والاستقرار|
|Customers|سهولة الشراء والاستخدام|

---

# 10. شرائح العملاء

العميل الرئيسي هو الفرد الذي يريد تطوير نفسه مهنياً.

يمكن أن تشمل الشرائح:

- الموظفين.
- المدراء والمشرفين.
- الإدارة العليا.
- رواد الأعمال.
- أصحاب المشاريع.
- المستقلين.
- الباحثين عن تطوير مهني.
- المهتمين بمهارات التسويق والإدارة والقيادة والمبيعات وريادة الأعمال.

يجب ألا تفترض المنصة أن كل العملاء يريدون Course قصيرة فقط.

---

# 11. نموذج الأعمال

تحتاج المنصة إلى دعم أكثر من Revenue Model.

### One-Time Purchase

شراء:

Course  
Diploma  
Bundle  
Consultation  
Live Program  
Add-on.

### Subscription

Monthly أو Annual.

### Membership

Community.

### Extension Revenue

تمديد الوصول.

### Certification Revenue

الشهادات الإضافية والمطبوعة.

### Service Revenue

Consultations.

---

# 12. المنتجات التجارية

يجب أن تدعم المنصة على الأقل:

|المنتج|نموذج البيع|
|---|---|
|Course|One-time|
|Diploma|One-time|
|Live Program|One-time / included|
|Bundle|One-time|
|Subscription|Recurring|
|Consultation|Booking + Payment|
|Community|Standalone / Benefit|
|Add-ons|Additional purchase|

---

# 13. متطلبات بيع الدورات

**BR-COURSE-01**  
يجب أن تستطيع ماستري بيع Course مستقلة للعميل.

**BR-COURSE-02**  
مدة الوصول الافتراضية سنة واحدة.

**BR-COURSE-03**  
لا توجد Monthly Course Purchase.

**BR-COURSE-04**  
يجب أن يستطيع العميل شراء Extension بعد انتهاء الوصول.

**BR-COURSE-05**  
الخيارات المعتمدة للتمديد:

3 أشهر، سنة، Lifetime.

---

# 14. متطلبات الدبلومات

**BR-DIP-01**  
يجب معاملة Diploma كProduct مستقلة تجارياً.

**BR-DIP-02**  
يمكن أن تتكون داخلياً من Learning Resource واحدة أو عدة Resources.

**BR-DIP-03**  
يمكن أن تكون:

Recorded، Live، Hybrid.

**BR-DIP-04**  
مدة الوصول الافتراضية سنة ما لم تحدد ماستري خلاف ذلك.

---

# 15. متطلبات Bundles

**BR-BND-01**  
يجب أن تستطيع ماستري إنشاء Bundle تحتوي على عدة أنواع منتجات.

يمكن أن تتضمن مثلاً:

Course + Diploma + Consultation + Community + Live Program.

**BR-BND-02**  
يجب أن يكون للـBundle سعر مستقل عن مجموع أسعار مكوناتها.

**BR-BND-03**  
يجب أن يستطيع فريق الأعمال إنشاء Bundle دون تدخل المبرمج.

**BR-BND-04**  
يجب أن يفهم العميل بوضوح جميع ما يحصل عليه بعد الشراء.

---

# 16. متطلبات الاشتراكات

الاشتراكات عنصر استراتيجي رئيسي.

**BR-SUB-01**  
يجب دعم Monthly وAnnual Billing.

**BR-SUB-02**  
يجب دعم Auto Renewal.

**BR-SUB-03**  
يجب أن تستطيع ماستري بناء Subscription مرنة وليس فقط Full Library.

**BR-SUB-04**  
يمكن أن تحتوي الباقة على أي مزيج من:

Courses  
Diplomas  
Consultations  
Community  
Live Programs  
Benefits أخرى.

**BR-SUB-05**  
الحقوق الناتجة عن Subscription تنتهي بانتهاء الاشتراك.

**BR-SUB-06**  
لا يتم ترحيل Benefits غير المستخدمة إلى الفترة التالية.

---

# 17. Choose-X Subscription

تحتاج ماستري إلى نموذج اشتراك:

> اختر X منتجات من مكتبة محددة.

مثلاً:

> اختر 10 Courses سنوياً.

Business Rules:

- Annual فقط.
- يستطيع العميل الاختيار تدريجياً.
- يمكن تغيير الاختيار قبل Start Learning.
- بعد Start Learning لا يمكن تغييره.
- عند Renewal يحصل على Allowance جديدة.
- لا يوجد rollover للـAllowance السابقة.

---

# 18. Full Library Subscription

يجب أن تستطيع ماستري تقديم باقة تمنح الوصول إلى مكتبة كاملة أو Collection كبيرة.

لا يعني ذلك أن كل Plan يجب أن تمنح Full Library.

---

# 19. Live Programs

بما أن Live Training جزء مهم من أعمال ماستري، يجب أن تدعم المنصة Cohorts.

**BR-LIVE-01**

نفس Live Product يمكن أن تحتوي على عدة Cohorts.

كل Cohort يجب أن تستطيع تحديد:

- Start date.
- End date.
- Registration period.
- Capacity.
- Sessions.
- Status.

**BR-LIVE-02**

يجب دعم Sold Out.

**BR-LIVE-03**

يجب دعم Waiting List.

---

# 20. Consultations

الاستشارات Product أساسية.

**BR-CON-01**  
المستشار يستطيع تقديم أكثر من خدمة.

**BR-CON-02**  
كل خدمة لها:

Duration  
Price  
Description  
Availability.

**BR-CON-03**  
يجب أن يستطيع العميل اختيار موعد والدفع إلكترونياً.

**BR-CON-04**  
بعد نجاح الحجز ينشأ Meeting تلقائياً.

**BR-CON-05**  
يمكن للعميل إعادة الجدولة قبل 6 ساعات على الأقل.

**BR-CON-06**  
Customer Cancellation لا تؤدي إلى Automatic Refund.

**BR-CON-07**  
إذا ألغى Consultant، يحصل العميل على فرصة إعادة الحجز.

---

# 21. Community

يجب بناء Community كمنتج مستقل داخل منظومة ماستري.

**BR-COM-01**

يمكن بيع Community standalone.

**BR-COM-02**

يمكن تضمينها داخل:

Bundle  
Subscription.

**BR-COM-03**

شراء Course وحدها لا يمنح Community Membership تلقائياً.

**BR-COM-04**

يجب دعم Spaces عامة وخاصة.

**BR-COM-05**

يمكن ربط Space بـCourse أو Cohort.

مثال:

الدخول يتطلب:

Active Community Membership

- Active Course Entitlement.

**BR-COM-06**

يجب أن يكون Networking جزءاً أساسياً من تجربة المجتمع.

---

# 22. Mastery Rewards

نظام مكافآت بسيط يهدف إلى زيادة Repeat Purchase.

Business Rules المعتمدة:

**BR-RWD-01**

كل:

> $1 مدفوع فعلياً = 10 Mastery Points.

**BR-RWD-02**

قيمة الاستخدام:

> 1,000 نقطة = $10 من قيمة عملية شراء.

**BR-RWD-03**

النقاط لا تنتهي.

**BR-RWD-04**

لا توجد Wallet مالية مستقلة.

**BR-RWD-05**

لا يمكن استرداد النقاط نقداً.

**BR-RWD-06**

يمكن استخدام النقاط على جميع Products وAdd-ons.

**BR-RWD-07**

يمكن دفع جزء بالنقاط والباقي بوسيلة دفع أخرى.

**BR-RWD-08**

لا يتم كسب نقاط على الجزء المدفوع بالنقاط.

---

# 23. Promotions

تحتاج ماستري إلى Promotion Engine مرنة.

يجب أن تدعم على الأقل:

- Percentage Discount.
- Fixed Discount.
- Coupons.
- Product Discounts.
- Category Discounts.
- Start/End Date.
- Usage Limits.
- Per Customer Limits.
- Bundle Offers.
- Free Products.
- Free Add-ons.
- Free Consultations.
- Subscription Offers.

الهدف التجاري:

> تمكين Marketing Team من إطلاق معظم الحملات دون تدخل برمجي.

---

# 24. Certificates & Add-ons

كل Course مؤهلة تمنح Mastery Electronic Certificate وفق شروط الإكمال.

يجب كذلك دعم:

### Printed Mastery Certificate

Paid Add-on.

### CPD Digital

يمكن أن تكون:

Included أو Paid.

### CPD Printed

Paid.

ويجب أن يستطيع فريق ماستري تحديد السعر لكل Product.

---

# 25. Payments

بوابة الدفع الرئيسية:

> Stripe.

يجب دعم:

Cards  
Apple Pay  
Google Pay.

كما يجب التكامل مع:

Tabby  
Tamara.

العملة الأساسية:

> USD.

ويفضل دعم Actual Local Currency Payments عندما تسمح بوابة الدفع بذلك.

---

# 26. Taxes & Invoices

تعتمد ماستري قدر الإمكان على:

Stripe Tax.

وStripe-generated:

Invoices / Receipts.

ولا يوجد Business Requirement لبناء Tax Engine مستقل ما لم تظهر حاجة قانونية أو تشغيلية لاحقاً.

---

# 27. Refunds

رغم أن سياسة ماستري قد لا تشجع Refunds الاعتيادية، يجب أن تستطيع الإدارة تنفيذ:

Full Refund  
Partial Refund.

ويجب أن تتم معالجة أثر Refund على:

- Payment.
- Order.
- Entitlements.
- Rewards.
- Access.

---

# 28. Authentication

تحتاج المنصة إلى Passwordless Experience.

طرق الدخول المطلوبة:

- Email OTP.
- Mobile OTP.
- Google.

يمكن للعميل التصفح وبناء Cart قبل Login.

يصبح Login مطلوباً عند الحاجة إلى الهوية مثل Checkout.

---

# 29. Search & Discovery

بسبب حجم Library، يجب أن يكون Search مركزياً في تجربة B2C.

يجب أن يبحث عبر:

Courses  
Diplomas  
Bundles  
Live Programs  
Experts  
Consultants  
Consultation Services.

ويجب توفير Filters تساعد العميل على تقليص الخيارات.

---

# 30. Merchandising

Homepage لا يجب أن تكون Hardcoded.

يجب أن يستطيع فريق التسويق التحكم في:

Featured Products  
Trending  
New  
Banners  
Collections  
Diplomas  
Live Programs  
Bundles  
Subscriptions  
Community  
Consultations.

الهدف:

> أن تستطيع ماستري تغيير أولويات البيع سريعاً دون Deployment تقني.

---

# 31. CMS

يجب أن يستطيع فريق الأعمال إدارة:

- Static Pages.
- Landing Pages.
- FAQ.
- Navigation.
- Footer.
- Marketing Content.

مع Landing Page Builder بسيط قائم على Blocks.

---

# 32. Customer Commercial Area

Student Learning Profile موجود ولا يعاد بناؤه.

لكن B2C تحتاج Commercial Area تظهر:

- Orders.
- Subscriptions.
- Consultations.
- Rewards.
- Community membership.
- Printed orders.
- Invoices/Receipts.

ويجب دمجها بصرياً قدر الإمكان مع تجربة العميل العامة.

---

# 33. B2C Admin

يجب أن تمتلك ماستري B2C Admin مستقلة.

الغرض الأساسي:

> تشغيل B2C دون الاعتماد المستمر على الفريق التقني.

يجب أن تشمل على الأقل:

Catalog  
Pricing  
Orders  
Payments  
Refunds  
Customers  
Entitlements  
Subscriptions  
Bundles  
Live Programs  
Consultations  
Community  
Rewards  
Promotions  
CMS  
Merchandising  
Analytics  
Operations  
Integrations  
Permissions.

---

# 34. Customer 360

يجب أن يستطيع Support رؤية العميل تجارياً من مكان واحد.

تشمل:

Customer Details  
Orders  
Spend  
Products  
Access  
Subscriptions  
Rewards  
Bookings  
Community  
Refunds.

---

# 35. Operations Management

يجب ألا تبقى المشاكل التقنية مخفية حتى يشتكي العميل.

يحتاج النظام إلى Operations Center للحالات مثل:

- Payment succeeded but enrollment failed.
- Refund failed.
- Google Meet creation failed.
- Subscription sync failed.
- LMS integration error.

والهدف التجاري:

> تقليل زمن اكتشاف المشكلة وحلها.

---

# 36. Roles & Permissions

يجب دعم تعدد الأدوار.

مثلاً:

Super Admin  
Product Manager  
Marketing  
Customer Support  
Finance  
Operations  
Consultation Manager  
Community Manager  
Analyst.

يجب ألا يستطيع Marketing مثلاً تنفيذ Refund لمجرد أن لديه Admin account.

---

# 37. Auditability

أي عملية مالية أو حساسة يجب أن تكون قابلة للتتبع.

أمثلة:

- Price change.
- Refund.
- Rewards adjustment.
- Access grant.
- Subscription modification.
- Consultation reschedule.

يجب معرفة:

Who  
What  
When  
Before  
After.

---

# 38. Analytics

يجب اعتبار Analytics جزءاً من Business Requirement منذ اليوم الأول.

أهم المجالات:

Traffic  
Search  
Conversion  
Orders  
Revenue  
AOV  
Customer acquisition  
Repeat purchase  
Subscriptions  
Consultations  
Live Programs  
Community  
Rewards.

---

# 39. Marketing Tracking

يجب التكامل مع:

GA4  
Meta Pixel  
Google Ads  
TikTok Pixel  
Microsoft Clarity.

ويجب تتبع Events الرئيسية عبر رحلة الشراء.

---

# 40. SEO

الموقع يعتمد جزئياً على Organic Discovery.

لذلك يجب دعم:

SEO-friendly URLs  
Metadata  
Canonical  
Structured Data  
Sitemap  
Indexable Catalog  
Performance  
Core Web Vitals.

---

# 41. Non-Functional Business Requirements

رغم أن تفاصيل التنفيذ تقنية، توجد متطلبات Business عالية المستوى.

### Performance

لا يجب أن تسبب المنصة الجديدة تراجعاً واضحاً في سرعة تجربة المستخدم.

### Availability

يجب أن تكون Commerce Journey عالية الاعتمادية.

### Mobile

تجربة Mobile Critical.

### Arabic

Arabic-first وRTL.

### Scalability

يجب أن تتحمل المنصة نمو Library والعملاء والطلبات.

### Reliability

Payment نجاحها يجب ألا تضيع بسبب فشل نظام خارجي.

---

# 42. التكاملات الرئيسية

المشروع يعتمد على:

|النظام|الوظيفة|
|---|---|
|Existing LMS|Learning|
|Existing Auth|Identity|
|Stripe|Payments/Billing/Tax|
|Tabby|BNPL|
|Tamara|BNPL|
|Tolt|Affiliate|
|Google|Login|
|Google Meet|Consultations/Events|
|Analytics Platforms|Measurement|

---

# 43. Source of Truth

من منظور Business Governance:

|البيانات|المسؤول عنها|
|---|---|
|Learning Content|LMS|
|Learning Progress|LMS|
|Course Started|LMS|
|Product Commerce|B2C|
|Pricing|B2C|
|Promotions|B2C|
|Orders|B2C|
|Entitlements|B2C|
|Subscription Benefits|B2C|
|Payment transaction|Payment Provider|
|Rewards|B2C|
|Community|B2C|
|Consultations|B2C|
|Affiliate Attribution|Tolt|
|Tax / Invoice|Stripe|

---

# 44. Business Process – شراء Course

العملية التجارية الأساسية:

```
Visitor
↓
Discover Product
↓
Evaluate
↓
Cart / Buy Now
↓
Identify Customer
↓
Checkout
↓
Payment
↓
Order
↓
Entitlement
↓
Enrollment
↓
Learning
```

هدف العمل:

> تقليل الخطوات والاحتكاك مع الحفاظ على سلامة العملية.

---

# 45. Business Process – Subscription

```
Discover Plan
↓
Understand Benefits
↓
Subscribe
↓
Recurring Billing
↓
Grant Benefits
↓
Usage
↓
Renewal / Cancellation
```

---

# 46. Business Process – Consultation

```
Discover Expert
↓
Select Service
↓
Select Time
↓
Pay
↓
Confirm
↓
Meeting
↓
Completion
```

---

# 47. Business Process – Rewards

```
Purchase
↓
Earn Points
↓
Accumulate
↓
Future Checkout
↓
Redeem Points
↓
Pay Remaining Amount
↓
Earn Again
```

---

# 48. Business Success Metrics

المشروع لا يعتبر ناجحاً فقط لأنه تم إطلاقه.

المقاييس الأساسية:

|KPI|الهدف|
|---|---|
|Conversion Rate|الارتفاع|
|Average Order Value|الارتفاع|
|Repeat Purchase Rate|الارتفاع|
|Customer Lifetime Value|الارتفاع|
|Revenue per Visitor|الارتفاع|
|Subscription Revenue|النمو|
|Renewal Rate|التحسن|
|Payment Success Rate|الارتفاع|
|Cart Abandonment|الانخفاض|
|Fulfillment Failures|الانخفاض|
|Support Cases per Order|الانخفاض|
|Consultation Revenue|النمو|
|Bundle Adoption|النمو|
|Rewards Redemption|قياس تأثير الولاء|
|Community Adoption|قياس استخدام Ecosystem|

يتم تحديد Target Numbers بعد توفر Baseline الحالي.

---

# 49. مؤشرات تشغيلية

يجب كذلك متابعة:

- Failed payments.
- Failed enrollments.
- Refund failures.
- Failed subscription renewals.
- Consultation no-shows.
- Cohort fill rate.
- Waitlist size.
- Physical fulfillment backlog.
- Integration availability.

---

# 50. الفوائد المتوقعة

المشروع يفترض أن يحقق فوائد في ثلاثة مستويات.

### Revenue Benefits

رفع الإيراد والتكرار والاشتراكات وAOV.

### Customer Benefits

سهولة أكبر في اكتشاف وشراء المنتجات والخدمات المناسبة.

### Operational Benefits

تقليل العمل اليدوي والاعتماد على الفريق التقني.

---

# 51. القيود التجارية

يجب أخذ القيود التالية بالحسبان:

- LMS الحالي سيستمر.
- Stripe بوابة الدفع الأساسية.
- B2B خارج نطاق المشروع.
- الفريق التقني B2C محدود الحجم.
- يجب تجنب Architecture تشغيلية معقدة بلا داعٍ.
- Arabic-first.
- المنصة يجب أن تكون قابلة للإدارة من فريق الأعمال.

---

# 52. الافتراضات

يعتمد BRD على افتراضات منها:

- الـLMS الحالي يوفر أو يمكنه توفير API مناسب.
- يمكن تنفيذ Enrollment وExpiry عبر Integration.
- Stripe يدعم نماذج الدفع المطلوبة في أسواق ماستري الرئيسية.
- فريق الأعمال سيقوم بإدارة المنتجات والمحتوى من Admin.
- Content Library الحالية سيتم ربطها بالنظام الجديد.
- Accounts الحالية يمكن ربطها بهوية النظام الجديد.

إذا ثبت خطأ افتراض أساسي، يجب مراجعة المتطلب المرتبط به.

---

# 53. المخاطر الرئيسية

### Scope Expansion

المنصة واسعة، وقد يؤدي بناء كل شيء في نفس الوقت إلى تأخير الإطلاق.

**Mitigation:** Release Planning.

### LMS Dependency

قد تمنع قيود الـAPI بعض السيناريوهات المطلوبة.

**Mitigation:** LMS Integration Assessment مبكر.

### Migration

مئات المنتجات والعملاء والروابط يمكن أن تسبب مشكلات عند الانتقال.

**Mitigation:** Migration Plan + Reconciliation.

### Payment Complexity

Stripe + Tabby + Tamara + Subscriptions تزيد التعقيد.

**Mitigation:** Payment abstraction + testing.

### Operational Complexity

Subscriptions وBundles وEntitlements قد تنتج حالات متعددة.

**Mitigation:** Entitlement Engine + Operations Center.

### SEO Loss

إعادة بناء الموقع قد تؤثر على Organic Traffic.

**Mitigation:** SEO Migration Plan + Redirect Mapping.

### Overbuilding

إمكانية بناء Features متقدمة قبل الحاجة لها.

**Mitigation:** Prioritized Release Scope.

---

# 54. الاعتماد على الأطراف الخارجية

يعتمد نجاح المشروع جزئياً على:

LMS APIs  
Stripe APIs  
Tolt  
Google  
Tabby  
Tamara.

لذلك يجب ألا تفترض العمليات أن كل External Service متاح دائماً.

---

# 55. Business Continuity Principle

هناك قاعدة تجارية مهمة جداً:

> **إذا دفع العميل بنجاح، يجب ألا تؤدي مشكلة مؤقتة في نظام خارجي إلى فقدان طلبه أو أمواله أو حقوقه.**

لذلك يجب الاحتفاظ بالطلب وإكمال Fulfillment لاحقاً.

---

# 56. البيانات والتاريخ التجاري

يجب ألا يؤدي تعديل Product أو Price مستقبلاً إلى تغيير السجل التاريخي للطلبات السابقة.

أي Order تاريخية يجب أن تمثل الحقيقة وقت تنفيذ العملية.

---

# 57. Data Governance

يجب أن يكون معروفاً:

- من يستطيع الاطلاع على البيانات؟
- من يستطيع تعديلها؟
- ما العمليات الحساسة؟
- ماذا يسجل في Audit Log؟
- ما البيانات التي لا يجوز حذفها؟

التنفيذ التفصيلي يحدد في Security/Technical Specification.

---

# 58. التوافق مع استراتيجية ماستري

المنتج الجديد يجب أن يدعم تحول العلاقة مع العميل من:

> شراء دورة منفردة

إلى:

> علاقة طويلة مع منظومة ماستري.

المسار المستهدف مثالاً:

```
Course
↓
Diploma
↓
Community
↓
Consultation
↓
Subscription
↓
Repeat Purchase
```

ولا يعني أن كل عميل سيسلك هذا المسار نفسه، لكنه يعبر عن فلسفة Ecosystem.

---

# 59. متطلبات التوسع المستقبلي

يجب ألا يمنع التصميم مستقبلاً:

- منتجات جديدة.
- لغات إضافية.
- AI Recommendations.
- AI Bundle Builder.
- Advanced personalization.
- Advanced Community.
- New Payment Providers.
- New Certification Products.

لكن هذه ليست بالضرورة Requirements لإطلاق V1.

---

# 60. AI – Future Business Direction

ماستري ترى إمكانية استخدام AI لاحقاً لتحسين:

Discovery  
Recommendations  
Bundle Building  
Community Search  
Member Matching.

لكن AI لا يجب أن يصبح Dependency لإطلاق Core B2C.

ويجب ألا يحدد AI أسعاراً أو خصومات خارج القواعد التجارية المعتمدة.

---

# 61. القرارات المفتوحة

بعض Business Rules تحتاج قراراً نهائياً لاحقاً:

### Existing Product داخل Bundle

إذا كان العميل يمتلك جزءاً من Bundle، لم يتم حسم هل يحصل على:

Price adjustment  
Replacement  
Extension  
أو لا تغيير.

### Community Standalone Billing

شهري وسنوي أم أحدهما فقط.

### Alumni Community

هل يبقى الوصول بعد انتهاء البرنامج.

### Rewards Redemption

هل الاستبدال بمضاعفات 1,000 فقط أم أي عدد نقاط وفق النسبة.

### Shipping

احتساب رسوم الشحن للشهادات المطبوعة.

هذه القرارات لا تمنع اعتماد BRD العام.

---

# 62. Business Acceptance Criteria للمشروع

يعتبر المشروع قد حقق الحد الأدنى من المتطلبات التجارية عندما تستطيع ماستري تنفيذ العمليات التالية بصورة مستقرة:

**Customer side**

- اكتشاف Product.
- تقييمها.
- التسجيل/الدخول.
- الدفع.
- الحصول على Access.
- الدخول إلى LMS.
- استخدام Services التي تم شراؤها.
- إدارة Subscription/Consultation/Rewards المطلوبة.

**Business side**

- إنشاء Product.
- وضع السعر.
- نشرها.
- إنشاء عروض.
- استقبال Orders.
- متابعة Payments.
- رؤية Customer.
- تنفيذ Refund.
- إدارة Access.
- التعامل مع Failed Fulfillment.
- قياس الأداء.

---

# 63. شروط نجاح Go-Live

لا ينبغي اعتماد Go-Live قبل التأكد على الأقل من:

- Golden Purchase Journey تعمل End-to-End.
- Stripe payment tested.
- LMS enrollment tested.
- Refund tested.
- Admin يستطيع إدارة Products وOrders.
- Operations failure handling tested.
- Analytics tracking validated.
- SEO migration ready.
- Existing customer/account migration validated.
- Critical security controls implemented.
- Monitoring active.
- Support team trained.

---

# 64. العلاقة بين BRD وبقية وثائق المشروع

الآن أصبح لدينا التسلسل الصحيح:

**BRD**  
يحدد الحاجة والهدف والمتطلبات التجارية.

↓

**Product Definition**  
يحدد شكل المنتج ومنظوماته.

↓

**PRD**  
يحدد الوظائف والمتطلبات التفصيلية.

↓

**User Stories & Acceptance Criteria**  
تحول الوظائف إلى وحدات تطوير.

↓

**Technical Specification**  
يحدد كيفية التنفيذ.

↓

**Sprint Backlog**  
يحدد ما سيبنى ومتى.

---

# 65. الخلاصة التنفيذية

مشروع Mastery B2C هو إعادة بناء لمنظومة قطاع الأفراد بهدف الانتقال من نموذج بيع دورات تقليدي إلى **Digital Learning Commerce Ecosystem**.

المنصة الجديدة يجب أن تمكن ماستري من:

> **بيع أنواع متعددة من المنتجات والخدمات، بناء إيرادات متكررة، زيادة قيمة العميل بمرور الوقت، تحسين تجربة الشراء، وإدارة عمليات B2C بصورة مستقلة وقابلة للتوسع.**

ويعتبر نجاح المشروع قائماً على ثلاثة محاور متساوية:

**Customer Experience**  
شراء واكتشاف سهل وموثوق.

**Commercial Capability**  
مرونة في المنتجات والأسعار والعروض ونماذج الإيراد.

**Operational Control**  
قدرة فريق ماستري على إدارة النظام وحل المشكلات وقياس الأداء دون الاعتماد الدائم على المبرمج.

وبذلك يصبح **BRD + Product Definition + PRD + Master Backlog** معاً الحزمة الأساسية لوثائق المشروع قبل الدخول إلى الـTechnical Specification والتنفيذ.

