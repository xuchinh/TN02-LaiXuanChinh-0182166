# RoomHub Database Rules

I want all UI labels, card titles, and inventory-related text to be displayed in Vietnamese, as this system is specifically designed for Vietnamese users.

Production-grade database standards for RoomHub.

This document defines:

- schema design rules
- naming conventions
- constraints
- indexing policy
- transaction rules
- migration policy
- audit strategy
- deletion strategy
- performance rules
- data integrity requirements

This document is the database source of truth.

---

# Database Philosophy

Database is not passive storage.

Database enforces business integrity.

Application validation alone is insufficient.

System protection must exist at:

```text
application layer
service layer
database layer
```

---

# Database Engine Standard

Official DB:

```text
MySQL 8+
```

Reason:

```text
stable
well-supported
Spring Boot friendly
index support
transaction support
fulltext support
good tooling
```

---

# Character Encoding Standard

Required:

```sql
utf8mb4
```

Collation:

```sql
utf8mb4_unicode_ci
```

Reason:

full Unicode support.

Supports:

```text
Vietnamese
emoji
international text
```

---

# Naming Conventions

Mandatory:

snake_case.

Good:

```text
created_at
updated_at
deleted_at
owner_id
room_status
subscription_end_at
```

Bad:

```text
CreatedAt
createdAt
OWNERID
RoomStatus
```

---

# Table Naming Rules

Plural nouns.

Good:

```text
users
roles
motels
rooms
posts
bookings
payments
subscriptions
reviews
coupons
favorites
refresh_tokens
activity_logs
```

Bad:

```text
User
tbl_user
roomData
```

---

# Column Naming Rules

Clear semantic naming.

Good:

```text
email
password_hash
phone_number
is_verified
expires_at
status
```

Bad:

```text
pwd
tel
flag1
data
x
```

---

# Primary Key Standard

All core tables:

```sql
BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY
```

Reason:

future scale safety.

Avoid INT for production-scale entities.

---

# UUID Policy

Default:

numeric primary keys.

Optional UUID:

public-facing identifiers.

Example:

```text
booking_reference
payment_reference
public_slug
```

Reason:

prevent enumeration exposure.

Do NOT replace every PK with UUID unnecessarily.

---

# Timestamp Standard

Required audit columns:

```sql
created_at
updated_at
```

Format:

```sql
DATETIME
```

or:

```sql
TIMESTAMP
```

Be consistent.

---

Recommended:

```sql
created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
```

---

# Soft Delete Standard

Entities requiring recovery/history:

must use:

```sql
deleted_at DATETIME NULL
```

Applicable:

```text
users
motels
rooms
posts
reviews
service_plans
packages
```

---

Do NOT soft delete:

ephemeral/security tables when unnecessary.

Examples:

```text
temporary auth codes
cache tables
```

---

# Hard Delete Policy

Allowed only when data should truly disappear.

Examples:

```text
expired temporary tokens
failed transient cache entries
staging temp rows
```

Sensitive legal/business entities often should not be hard deleted.

---

# Boolean Standard

Use:

```sql
BOOLEAN
```

or:

```sql
TINYINT(1)
```

Examples:

```text
is_active
is_verified
is_boosted
is_revoked
```

Use explicit names.

Bad:

```text
flag
status_bool
```

---

# ENUM Policy

Use ENUM sparingly.

Good for stable finite states.

Examples:

```text
booking_status
payment_status
user_status
room_status
```

Bad for frequently changing business taxonomies.

---

# Status Column Rules

Explicit lifecycle states.

Example user:

```text
ACTIVE
LOCKED
SUSPENDED
PENDING_VERIFICATION
```

Example booking:

```text
PENDING
CONFIRMED
CANCELLED
COMPLETED
EXPIRED
```

Avoid vague:

```text
1
2
3
```

---

# Monetary Data Rules

Never use FLOAT.

Never use DOUBLE.

Required:

```sql
DECIMAL(15,2)
```

Examples:

```text
price
deposit_amount
payment_amount
discount_amount
refund_amount
```

Reason:

financial precision.

---

# Percentage Rules

Use:

```sql
DECIMAL(5,2)
```

Examples:

```text
discount_percent
commission_percent
```

---

# Phone Number Rules

Use:

```sql
VARCHAR
```

NOT numeric.

Reason:

```text
leading zeros
country codes
formatting
```

Example:

```sql
VARCHAR(20)
```

---

# Email Rules

Use:

```sql
VARCHAR(255)
```

Must be unique.

Store normalized lowercase values.

---

# Password Rules

Never store raw password.

Required column:

```text
password_hash
```

Example:

```sql
VARCHAR(255)
```

---

# JSON Column Policy

Allowed for flexible metadata only.

Examples:

```text
device metadata
provider callback payload snapshot
search filter cache
```

Do NOT abuse JSON for relational core data.

Bad:

```text
all room data in one JSON column
```

---

# Foreign Key Rules

Mandatory for relational integrity.

Example:

```sql
owner_id BIGINT UNSIGNED NOT NULL
FOREIGN KEY (owner_id) REFERENCES users(id)
```

Never skip FK "for convenience".

---

# Foreign Key Delete Strategy

Explicit policy required.

Options:

```text
CASCADE
RESTRICT
SET NULL
```

Choose intentionally.

Examples:

users -> refresh_tokens:

```text
CASCADE
```

users -> payments:

usually:

```text
RESTRICT
```

Avoid accidental mass deletes.

---

# NOT NULL Rules

Core business columns:

must be NOT NULL.

Bad:

```text
email nullable
price nullable
status nullable
```

Nullable only when semantically valid.

---

# Default Value Rules

Use safe defaults.

Examples:

```sql
is_active DEFAULT TRUE
is_boosted DEFAULT FALSE
status DEFAULT 'PENDING'
```

Avoid ambiguous null-state business logic.

---

# Unique Constraint Rules

Mandatory where identity matters.

Examples:

```text
users.email
users.username (if exists)
coupons.code
payments.transaction_reference
refresh_tokens.token_hash
```

---
# Indexing Policy

Indexes are mandatory for query-heavy fields.

Typical indexed columns:

```text
email
phone_number
status
created_at
owner_id
motel_id
room_id
city_id
district_id
price
booking_status
payment_status
expires_at
```

---

Do NOT over-index.

Too many indexes:

```text
slower inserts
slower updates
larger storage
```

Index intentionally.

---

# Composite Index Rules

Use when queries filter multiple columns together.

Examples:

```sql
(city_id, district_id, status)
(owner_id, status)
(user_id, created_at)
(status, created_at)
```

---

# Full Text Search Policy

For listing search:

MySQL FULLTEXT allowed.

Applicable:

```text
posts.title
posts.description
motels.name
```

Use only where meaningful.

---

# Schema — Roles

Purpose:

system authorization roles.

Table:

```sql
roles
```

Columns:

```sql
id BIGINT UNSIGNED PK
name VARCHAR(50) UNIQUE NOT NULL
description VARCHAR(255) NULL
created_at DATETIME NOT NULL
updated_at DATETIME NOT NULL
```

Seed values:

```text
ADMIN
LANDLORD
TENANT
```

Rules:

role names immutable in production.

---

# Schema — Users

Purpose:

identity + authentication + profile.

Table:

```sql
users
```

Columns:

```sql
id BIGINT UNSIGNED PK
role_id BIGINT UNSIGNED FK
full_name VARCHAR(150) NOT NULL
email VARCHAR(255) UNIQUE NOT NULL
phone_number VARCHAR(20) UNIQUE NULL
password_hash VARCHAR(255) NOT NULL
avatar_url VARCHAR(500) NULL
status ENUM(...)
email_verified_at DATETIME NULL
last_login_at DATETIME NULL
created_at DATETIME NOT NULL
updated_at DATETIME NOT NULL
deleted_at DATETIME NULL
```

---

User status:

```text
ACTIVE
LOCKED
SUSPENDED
PENDING_VERIFICATION
```

Indexes:

```sql
UNIQUE(email)
UNIQUE(phone_number)
INDEX(role_id)
INDEX(status)
INDEX(created_at)
```

Rules:

email stored lowercase.

Never expose:

```text
password_hash
```

---

# Schema — Refresh Tokens

Purpose:

session continuation.

Table:

```sql
refresh_tokens
```

Columns:

```sql
id BIGINT UNSIGNED PK
user_id BIGINT UNSIGNED FK
token_hash VARCHAR(255) UNIQUE NOT NULL
device_name VARCHAR(255) NULL
ip_address VARCHAR(45) NULL
user_agent TEXT NULL
expires_at DATETIME NOT NULL
revoked_at DATETIME NULL
created_at DATETIME NOT NULL
```

Indexes:

```sql
INDEX(user_id)
INDEX(expires_at)
INDEX(revoked_at)
UNIQUE(token_hash)
```

Rules:

NEVER store raw token.

Only hashed value.

---

# Schema — Motels

Purpose:

landlord-owned property container.

Table:

```sql
motels
```

Columns:

```sql
id BIGINT UNSIGNED PK
owner_id BIGINT UNSIGNED FK
name VARCHAR(255) NOT NULL
description TEXT NULL
address_line VARCHAR(255) NOT NULL
city VARCHAR(120) NOT NULL
district VARCHAR(120) NOT NULL
ward VARCHAR(120) NULL
latitude DECIMAL(10,7) NULL
longitude DECIMAL(10,7) NULL
status ENUM(...)
created_at DATETIME NOT NULL
updated_at DATETIME NOT NULL
deleted_at DATETIME NULL
```

Status:

```text
ACTIVE
HIDDEN
SUSPENDED
```

Indexes:

```sql
INDEX(owner_id)
INDEX(status)
INDEX(city, district)
INDEX(latitude, longitude)
```

Rules:

motels belong to exactly one landlord.

---

# Schema — Rooms

Purpose:

actual rentable units.

Table:

```sql
rooms
```

Columns:

```sql
id BIGINT UNSIGNED PK
motel_id BIGINT UNSIGNED FK
name VARCHAR(255) NOT NULL
description TEXT NULL
price DECIMAL(15,2) NOT NULL
deposit_amount DECIMAL(15,2) DEFAULT 0
area_sqm DECIMAL(8,2) NOT NULL
capacity INT NOT NULL
bedroom_count INT DEFAULT 0
bathroom_count INT DEFAULT 0
status ENUM(...)
created_at DATETIME NOT NULL
updated_at DATETIME NOT NULL
deleted_at DATETIME NULL
```

Status:

```text
AVAILABLE
RESERVED
RENTED
MAINTENANCE
HIDDEN
```

Constraints:

```text
price >= 0
deposit >= 0
capacity > 0
area > 0
```

Indexes:

```sql
INDEX(motel_id)
INDEX(status)
INDEX(price)
INDEX(area_sqm)
INDEX(status, price)
```

---

# Schema — Room Images

Purpose:

multi-image support.

Table:

```sql
room_images
```

Columns:

```sql
id BIGINT UNSIGNED PK
room_id BIGINT UNSIGNED FK
image_url VARCHAR(500) NOT NULL
sort_order INT DEFAULT 0
created_at DATETIME NOT NULL
```

Indexes:

```sql
INDEX(room_id)
INDEX(room_id, sort_order)
```

Rules:

one room = many images.

---

# Schema — Posts

Purpose:

public listing content.

Table:

```sql
posts
```

Columns:

```sql
id BIGINT UNSIGNED PK
room_id BIGINT UNSIGNED FK
title VARCHAR(255) NOT NULL
description TEXT NOT NULL
status ENUM(...)
is_boosted BOOLEAN DEFAULT FALSE
boost_expires_at DATETIME NULL
published_at DATETIME NULL
approved_by BIGINT UNSIGNED FK NULL
created_at DATETIME NOT NULL
updated_at DATETIME NOT NULL
deleted_at DATETIME NULL
```

Status:

```text
DRAFT
PENDING_APPROVAL
PUBLISHED
REJECTED
ARCHIVED
```

Indexes:

```sql
INDEX(room_id)
INDEX(status)
INDEX(is_boosted)
INDEX(published_at)
FULLTEXT(title, description)
```

Rules:

one room can have multiple historical posts if business allows.

Otherwise enforce uniqueness.

---

# Schema — Favorites

Purpose:

tenant saved listings.

Table:

```sql
favorites
```

Columns:

```sql
id BIGINT UNSIGNED PK
user_id BIGINT UNSIGNED FK
post_id BIGINT UNSIGNED FK
created_at DATETIME NOT NULL
```

Constraint:

```sql
UNIQUE(user_id, post_id)
```

Indexes:

```sql
INDEX(user_id)
INDEX(post_id)
```

---

# Schema — Bookings

Purpose:

booking workflow.

Table:

```sql
bookings
```

Columns:

```sql
id BIGINT UNSIGNED PK
tenant_id BIGINT UNSIGNED FK
room_id BIGINT UNSIGNED FK
booking_reference VARCHAR(100) UNIQUE NOT NULL
requested_move_in_date DATE NULL
note TEXT NULL
status ENUM(...)
created_at DATETIME NOT NULL
updated_at DATETIME NOT NULL
cancelled_at DATETIME NULL
```

Status:

```text
PENDING
CONFIRMED
REJECTED
CANCELLED
EXPIRED
COMPLETED
```

Indexes:

```sql
INDEX(tenant_id)
INDEX(room_id)
INDEX(status)
UNIQUE(booking_reference)
```

Rules:

prevent double booking.

Use transactions.

---
# Schema — Reviews

Purpose:

tenant feedback + trust system.

Table:

```sql
reviews
```

Columns:

```sql
id BIGINT UNSIGNED PK
tenant_id BIGINT UNSIGNED FK
motel_id BIGINT UNSIGNED FK
booking_id BIGINT UNSIGNED FK NULL
rating TINYINT NOT NULL
comment TEXT NULL
status ENUM(...)
created_at DATETIME NOT NULL
updated_at DATETIME NOT NULL
deleted_at DATETIME NULL
```

Status:

```text
VISIBLE
HIDDEN
FLAGGED
REMOVED
```

Constraints:

```text
rating between 1 and 5
```

Indexes:

```sql
INDEX(tenant_id)
INDEX(motel_id)
INDEX(status)
INDEX(created_at)
```

Rules:

only verified tenants may review.

Recommended:

```sql
UNIQUE(tenant_id, booking_id)
```

Prevent duplicate review spam.

---

# Schema — Service Plans

Purpose:

technical entitlement templates for paid landlord capabilities.

Table:

```sql
service_plans
```

Columns:

```sql
id BIGINT UNSIGNED PK
code VARCHAR(50) UNIQUE NOT NULL
name VARCHAR(120) UNIQUE NOT NULL
description TEXT NULL
listing_quota INT NOT NULL
boost_quota INT NOT NULL
analytics_enabled BOOLEAN NOT NULL
image_quota INT NOT NULL
is_active BOOLEAN NOT NULL
created_at DATETIME NOT NULL
updated_at DATETIME NOT NULL
```

Rules:

service plans define what features and quotas are unlocked.

They are not directly purchased by landlords.

---

# Schema — Packages

Purpose:

commercial products sold to landlords.

Table:

```sql
packages
```

Columns:

```sql
id BIGINT UNSIGNED PK
service_plan_id BIGINT UNSIGNED FK
name VARCHAR(120) UNIQUE NOT NULL
description TEXT NULL
price DECIMAL(15,2) NOT NULL
duration_days INT NOT NULL
is_active BOOLEAN NOT NULL
created_at DATETIME NOT NULL
updated_at DATETIME NOT NULL
```

Constraints:

```text
price >= 0
duration_days > 0
```

Seed examples:

```text
STARTER_MONTHLY
PRO_MONTHLY
PRO_QUARTERLY_PROMO
```

Rules:

packages reference service plans.

Package price/duration may vary while the underlying service plan entitlement stays stable.

---

# Schema — Subscriptions

Purpose:

track purchased package ownership and applied entitlement snapshot.

Table:

```sql
subscriptions
```

Columns:

```sql
id BIGINT UNSIGNED PK
user_id BIGINT UNSIGNED FK
package_id BIGINT UNSIGNED FK
service_plan_id BIGINT UNSIGNED FK
payment_id BIGINT UNSIGNED FK NULL
status ENUM(...)
started_at DATETIME NOT NULL
expires_at DATETIME NOT NULL
remaining_listing_quota INT NOT NULL
remaining_boost_quota INT NOT NULL
created_at DATETIME NOT NULL
updated_at DATETIME NOT NULL
```

Status:

```text
PENDING
ACTIVE
EXPIRED
CANCELLED
FAILED
```

Indexes:

```sql
INDEX(user_id)
INDEX(package_id)
INDEX(service_plan_id)
INDEX(status)
INDEX(expires_at)
```

Rules:

one user can have subscription history.

Do NOT overwrite old subscriptions.

Historical tracking required.

---

# Schema — Payments

Purpose:

financial transaction tracking.

Table:

```sql
payments
```

Columns:

```sql
id BIGINT UNSIGNED PK
user_id BIGINT UNSIGNED FK
subscription_id BIGINT UNSIGNED FK NULL
amount DECIMAL(15,2) NOT NULL
currency VARCHAR(10) NOT NULL
provider VARCHAR(50) NOT NULL
provider_transaction_id VARCHAR(255) UNIQUE NULL
payment_reference VARCHAR(100) UNIQUE NOT NULL
status ENUM(...)
provider_payload JSON NULL
paid_at DATETIME NULL
created_at DATETIME NOT NULL
updated_at DATETIME NOT NULL
```

Status:

```text
PENDING
SUCCESS
FAILED
REFUNDED
CANCELLED
```

Indexes:

```sql
INDEX(user_id)
INDEX(subscription_id)
INDEX(status)
INDEX(created_at)
UNIQUE(payment_reference)
UNIQUE(provider_transaction_id)
```

Rules:

never trust frontend payment status.

Backend verification required.

---

# Schema — Coupons

Purpose:

discount management.

Table:

```sql
coupons
```

Columns:

```sql
id BIGINT UNSIGNED PK
code VARCHAR(100) UNIQUE NOT NULL
description VARCHAR(255) NULL
discount_type ENUM(...)
discount_value DECIMAL(15,2) NOT NULL
max_discount_amount DECIMAL(15,2) NULL
min_order_amount DECIMAL(15,2) NULL
usage_limit INT NULL
used_count INT DEFAULT 0
expires_at DATETIME NULL
is_active BOOLEAN NOT NULL
created_at DATETIME NOT NULL
updated_at DATETIME NOT NULL
```

Discount types:

```text
PERCENT
FIXED
```

Constraints:

```text
discount_value >= 0
used_count >= 0
```

Indexes:

```sql
UNIQUE(code)
INDEX(expires_at)
INDEX(is_active)
```

---

# Schema — Coupon Redemptions

Purpose:

usage history.

Table:

```sql
coupon_redemptions
```

Columns:

```sql
id BIGINT UNSIGNED PK
coupon_id BIGINT UNSIGNED FK
user_id BIGINT UNSIGNED FK
payment_id BIGINT UNSIGNED FK
created_at DATETIME NOT NULL
```

Indexes:

```sql
INDEX(coupon_id)
INDEX(user_id)
INDEX(payment_id)
```

Optional constraint:

```sql
UNIQUE(coupon_id, user_id)
```

If coupon is single-use per user.

---

# Schema — Activity Logs

Purpose:

audit trail.

Table:

```sql
activity_logs
```

Columns:

```sql
id BIGINT UNSIGNED PK
user_id BIGINT UNSIGNED FK NULL
action VARCHAR(255) NOT NULL
entity_type VARCHAR(100) NOT NULL
entity_id BIGINT UNSIGNED NULL
ip_address VARCHAR(45) NULL
metadata JSON NULL
created_at DATETIME NOT NULL
```

Indexes:

```sql
INDEX(user_id)
INDEX(entity_type, entity_id)
INDEX(created_at)
```

Rules:

append-only.

Never edit audit history.

---

# Schema — Notifications

Purpose:

system notifications.

Table:

```sql
notifications
```

Columns:

```sql
id BIGINT UNSIGNED PK
user_id BIGINT UNSIGNED FK
title VARCHAR(255) NOT NULL
message TEXT NOT NULL
type ENUM(...)
is_read BOOLEAN NOT NULL
read_at DATETIME NULL
created_at DATETIME NOT NULL
```

Types:

```text
BOOKING
PAYMENT
SYSTEM
PROMOTION
SECURITY
```

Indexes:

```sql
INDEX(user_id)
INDEX(is_read)
INDEX(created_at)
```

---

# Schema — Reports

Purpose:

abuse/moderation reporting.

Table:

```sql
reports
```

Columns:

```sql
id BIGINT UNSIGNED PK
reporter_id BIGINT UNSIGNED FK
target_type ENUM(...)
target_id BIGINT UNSIGNED NOT NULL
reason VARCHAR(255) NOT NULL
details TEXT NULL
status ENUM(...)
reviewed_by BIGINT UNSIGNED FK NULL
reviewed_at DATETIME NULL
created_at DATETIME NOT NULL
```

Target types:

```text
POST
REVIEW
USER
MOTEL
```

Status:

```text
OPEN
UNDER_REVIEW
RESOLVED
DISMISSED
```

Indexes:

```sql
INDEX(reporter_id)
INDEX(target_type, target_id)
INDEX(status)
```

---

# Foreign Key Delete Strategy

Mandatory explicit behavior.

Recommended:

roles -> users:

```text
RESTRICT
```

users -> refresh_tokens:

```text
CASCADE
```

users -> motels:

```text
RESTRICT
```

motels -> rooms:

```text
RESTRICT
```

rooms -> room_images:

```text
CASCADE
```

users -> activity_logs:

```text
SET NULL
```

---

# Transaction Strategy

Use DB transactions for critical flows.

Mandatory:

```text
booking confirmation
payment completion
subscription activation
coupon redemption
refund processing
room status transition
```

Spring:

```java
@Transactional
```

---

# Double Booking Prevention

Must prevent race conditions.

Example:

2 tenants book same room simultaneously.

Protection:

```text
transaction
select for update
unique business checks
optimistic locking
```

Never rely only on frontend checks.

---

# Migration Strategy

Schema changes must be versioned.

Approved tools:

```text
Flyway
Liquibase
```

Never manually edit production DB.

Bad:

```text
direct phpmyadmin patching
manual prod SQL edits
```

---

# Migration Naming Standard

Examples:

```text
V1__initial_schema.sql
V2__add_refresh_tokens.sql
V3__add_payments.sql
V4__add_indexes.sql
```

---

# Seed Data Strategy

Separate seed from migrations where practical.

Seed:

```text
roles
default service plans
default packages
system configs
```

Never mix test junk into production seeds.

---

# Backup Strategy

Minimum:

```text
daily automated backup
retention policy
restore verification
```

Critical because:

```text
payments
bookings
user data
audit logs
```

---

# Performance Rules

Large tables expected:

```text
payments
activity_logs
notifications
bookings
```

Strategies:

```text
proper indexing
pagination
archival strategy
query optimization
```

Never:

```sql
SELECT * FROM huge_table
```

without pagination.

---

# Query Design Rules

Always:

```text
select needed columns only
paginate list endpoints
use indexes
avoid N+1 queries
```

---

Bad:

```sql
SELECT *
```

Good:

```sql
SELECT id, title, price
```

---

# Soft Delete Query Rule

All application queries must exclude deleted rows unless explicitly needed.

Pattern:

```sql
WHERE deleted_at IS NULL
```

---

# Data Integrity Rules

Database must enforce:

```text
valid foreign keys
uniqueness
non-negative monetary values
valid enum states
rating bounds
duplicate prevention
```

App logic alone is insufficient.

---

# RoomHub Database Source Of Truth

This document governs:

```text
schema structure
constraints
FK behavior
transactions
indexes
migration rules
performance rules
audit rules
soft delete behavior
```

All RoomHub database implementations must comply.

---
