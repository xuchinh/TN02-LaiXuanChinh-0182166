# RoomHub Business Rules

I want all UI labels, card titles, and inventory-related text to be displayed in Vietnamese, as this system is specifically designed for Vietnamese users.

Production-style business rules documentation for the RoomHub platform.

This document defines the domain logic, constraints, permissions, workflows, and business behavior of the system.

This file is the business source of truth for:

- backend development
- frontend behavior alignment
- API design
- validation rules
- database constraints
- AI coding assistants

Without this file, AI often generates incorrect business logic.

---

# Business Philosophy

RoomHub is not a simple CRUD application.

Business logic must reflect realistic rental platform behavior.

Core principles:

- ownership enforcement
- role separation
- state-driven workflows
- auditable actions
- transactional consistency
- explicit permission control
- subscription-based feature gating

---

# System Roles

Three primary business actors exist.

```text
TENANT
LANDLORD
ADMIN
```

---

# TENANT Business Rules

Tenant is a consumer searching for rental accommodation.

Allowed:

- register account
- login
- logout
- refresh session
- manage own profile
- browse public listings
- search listings
- save favorites
- request booking
- cancel own booking
- review completed rental
- report abusive content
- read blogs

Forbidden:

- create motels
- manage rooms
- create listings
- approve bookings
- boost listings
- access admin modules
- manage subscriptions for landlord tools

---

## Tenant Identity Rules

Tenant must have:

```text
unique email
verified credentials
active account status
```

Blocked tenant:

```text
cannot authenticate
```

Locked tenant:

```text
cannot perform protected actions
```

---

# LANDLORD Business Rules

Landlord owns rental inventory.

Allowed:

- register landlord account
- manage profile
- create motels
- update owned motels
- delete owned motels
- create rooms
- manage rooms
- create rental listings
- manage owned listings
- approve/reject bookings
- purchase subscriptions
- use premium features
- view owned analytics

Forbidden:

- manage unrelated landlord resources
- access admin governance
- bypass ownership validation

---

## Ownership Rule (Critical)

This is one of the most important business rules.

A landlord may ONLY modify owned resources.

Required validation:

```text
resource.owner_id == authenticated_user.id
```

Applies to:

- motels
- rooms
- posts
- booking approvals
- analytics
- subscription management

Example:

Incorrect:

```text
landlord updates motel by ID only
```

Correct:

```text
find motel
check ownership
allow update
```

---

# ADMIN Business Rules

Administrator governs the platform.

Allowed:

- manage users
- moderate listings
- moderate reviews
- manage reports
- manage subscriptions
- manage coupons
- manage service plans
- manage feature toggles
- view analytics
- platform governance

Forbidden:

- silent destructive behavior
- untracked governance actions

Recommendation:

admin actions should be audit logged.

---

# Account Lifecycle Rules

Account statuses:

```text
ACTIVE
LOCKED
SUSPENDED
DELETED
```

---

## ACTIVE

User may:

- authenticate
- access authorized features
- perform normal workflows

---

## LOCKED

Meaning:

temporary administrative restriction.

Behavior:

```text
login denied
token refresh denied
protected API access denied
```

---

## SUSPENDED

Meaning:

serious violation / moderation restriction.

Behavior:

stronger than LOCKED.

---

## DELETED

Soft delete preferred.

Behavior:

```text
account hidden
authentication denied
data retained for integrity
```

Hard delete is dangerous due to relational dependencies.

---

# Authentication Rules

Authentication model:

```text
JWT Access Token + Refresh Token
```

---

## Access Token Rules

Properties:

- short lifetime
- stateless
- API authorization token

Example:

```text
15 minutes
```

Rules:

expired token:

```text
request denied
```

invalid signature:

```text
request denied
```

tampered token:

```text
request denied
```

---

## Refresh Token Rules

Properties:

- persistent
- revocable
- database-backed

Rules:

refresh token must:

- exist
- belong to user
- not be revoked
- not be expired

Invalid refresh token:

```text
session denied
```

---

## Logout Rule

Logout must invalidate refresh token.

Otherwise:

session remains reusable.

---

# Registration Rules

Required:

- full name
- email
- password
- role selection

Validation:

email:

```text
must be unique
must be valid format
```

password:

```text
minimum length
uppercase recommended
lowercase recommended
number recommended
special character recommended
```

Role:

allowed:

```text
TENANT
LANDLORD
```

Admin registration should NOT be public.

---

# Login Rules

Required:

```text
email
password
```

Validation:

- account exists
- password matches
- account active
- account not locked

Failure response:

generic message.

Avoid:

```text
email not found
wrong password
```

Reason:

security information leakage.
# Motel Business Rules

A motel is a landlord-owned rental property container.

A motel contains rooms.

Relationship:

```text
LANDLORD
   ↓
 MOTEL
   ↓
 ROOMS
```

---

## Motel Creation Rules

Only:

```text
LANDLORD
```

may create motels.

TENANT:

```text
forbidden
```

ADMIN:

normally does not create landlord inventory.

Required fields:

- motel name
- address
- city
- district
- ward
- description
- contact phone

Optional:

- thumbnail image
- gallery images
- amenities

Validation:

motel name:

```text
required
max length enforced
```

address:

```text
required
```

phone:

```text
valid phone format
```

description:

```text
length constrained
```

---

## Motel Ownership Rules

Critical:

Landlord may only manage owned motels.

Validation:

```text
motel.owner_id == authenticated_user.id
```

Protected actions:

- update motel
- delete motel
- view private analytics
- manage motel rooms

---

## Motel Deletion Rules

Hard delete is discouraged.

Preferred:

```text
soft delete
```

Reason:

motels may already have:

- rooms
- bookings
- reviews
- payment references

Behavior:

deleted motel:

```text
hidden from public listings
```

---

## Motel Visibility Rules

States:

```text
ACTIVE
INACTIVE
DELETED
```

ACTIVE:

visible.

INACTIVE:

hidden from public discovery.

DELETED:

soft removed.

---

# Room Business Rules

Rooms are child resources of motels.

Relationship:

```text
MOTEL
   ↓
 ROOM
```

Only landlord owner may manage rooms.

---

## Room Creation Rules

Required:

- motel_id
- room name / room code
- price
- capacity
- area
- room status

Optional:

- description
- images
- amenities

---

## Room Validation Rules

Price:

```text
must be positive
```

Invalid:

```text
0
negative
```

Capacity:

```text
must be >= 1
```

Area:

```text
must be positive
```

---

## Room Status Rules

States:

```text
AVAILABLE
PENDING
RENTED
INACTIVE
DELETED
```

Meaning:

AVAILABLE:

```text
bookable
```

PENDING:

```text
booking request exists
awaiting landlord decision
```

RENTED:

```text
not available
```

INACTIVE:

```text
temporarily hidden
```

DELETED:

```text
soft removed
```

---

## Room Ownership Rules

Landlord must own parent motel.

Validation:

```text
room.motel.owner_id == authenticated_user.id
```

---

## Room Booking Restrictions

AVAILABLE:

booking allowed.

PENDING:

new booking usually blocked.

RENTED:

booking forbidden.

INACTIVE:

booking forbidden.

DELETED:

booking forbidden.

---

# Post / Listing Business Rules

Posts expose rooms publicly.

Relationship:

```text
ROOM
   ↓
 POST
```

Not every room must have a public listing.

---

## Post Creation Rules

Only:

```text
LANDLORD
```

Required:

- room reference
- title
- description
- price snapshot
- visibility status

Validation:

room must:

```text
exist
belong to landlord
be active
```

---

## Post Status Rules

States:

```text
DRAFT
PENDING_APPROVAL
APPROVED
REJECTED
ARCHIVED
EXPIRED
```

Meaning:

DRAFT:

not public.

PENDING_APPROVAL:

awaiting moderation.

APPROVED:

publicly searchable.

REJECTED:

not visible.

ARCHIVED:

manual hidden.

EXPIRED:

listing expired.

---

## Public Visibility Rule

Only:

```text
APPROVED
```

posts appear in public search.

---

## Premium Boost Rule

Boosting requires:

active premium subscription.

Validation:

```text
landlord has active plan
boost quota > 0
```

Without subscription:

```text
deny
```

Boost effect:

higher listing visibility.

---

# Favorite Rules

TENANT may save favorite listings.

Constraints:

same tenant cannot duplicate favorite same post.

Unique rule:

```text
(tenant_id, post_id)
```

---

# Search Business Rules

Public search supports:

- keyword
- city
- district
- ward
- price min/max
- area min/max
- room capacity
- room availability
- sort order

Search must return only:

```text
approved + active + public content
```

Never return:

- deleted content
- inactive content
- rejected content
- draft content

---

# Booking Business Rules

Booking is a workflow, not simple CRUD.

Relationship:

```text
TENANT
   ↓
 BOOKING
   ↓
 ROOM
   ↓
 LANDLORD
```

---

## Booking Creation Rules

Only:

```text
TENANT
```

Required:

- room_id
- preferred date
- message (optional)

Validation:

room must:

```text
exist
be available
be active
not deleted
```

Tenant must:

```text
be authenticated
be active
not locked
```

---

## Duplicate Booking Prevention

Prevent spam duplicates.

Rule example:

same tenant + same room + active pending booking:

```text
deny
```

---

## Booking Status Lifecycle

States:

```text
PENDING
APPROVED
REJECTED
CANCELLED
COMPLETED
EXPIRED
```

Flow:

```text
PENDING
   ↓
APPROVED / REJECTED
   ↓
COMPLETED
```

or:

```text
PENDING
   ↓
CANCELLED
```

---

## Approval Rules

Only room owner landlord may approve.

Validation:

```text
booking.room.owner == authenticated landlord
```

Room state check:

must still be available.

Approval effect:

```text
booking -> APPROVED
room -> RENTED
```

Atomic transaction required.

---

## Cancellation Rules

Tenant may cancel own booking.

Landlord may reject pending request.

Completed bookings:

normally immutable.

---

## Room State Synchronization

Approved booking:

```text
room becomes RENTED
```

Cancelled / rejected:

may revert:

```text
AVAILABLE
```

depending on current occupancy state.

This must be handled carefully.

---
# Review Business Rules

Reviews are trust-building platform content.

Relationship:

```text
TENANT
   ↓
 REVIEW
   ↓
 ROOM / MOTEL / LANDLORD EXPERIENCE
```

Reviews are NOT open public comments.

They are controlled domain entities.

---

## Review Creation Rules

Only:

```text
TENANT
```

may create reviews.

LANDLORD:

```text
forbidden
```

ADMIN:

may moderate, not create user reviews.

---

## Eligibility Rules

Tenant must meet ALL conditions:

- authenticated
- active account
- completed rental interaction
- verified association with booking

Validation:

```text
booking exists
booking belongs to tenant
booking status == COMPLETED
```

Without verified booking:

```text
deny review
```

Reason:

prevent fake reviews.

---

## Duplicate Review Prevention

A tenant should not repeatedly review the same booking.

Constraint:

```text
one completed booking = one review
```

Validation:

```text
booking_id unique in reviews
```

---

## Review Rating Rules

Allowed rating range:

```text
1 → 5
```

Invalid:

```text
0
6+
negative
```

---

## Review Content Rules

Validation:

minimum content length.

Example:

```text
>= 10 characters
```

Maximum:

prevent abuse.

Example:

```text
<= 2000 characters
```

Must reject:

- empty content
- script injection
- malicious payloads

---

## Review Moderation Rules

Admin may:

- hide abusive review
- remove spam review
- flag suspicious review

States:

```text
VISIBLE
HIDDEN
REPORTED
REMOVED
```

Only:

```text
VISIBLE
```

appears publicly.

---

# Blog Business Rules

Blogs are informational content.

Purpose:

- tenant education
- landlord education
- rental tips
- housing guides
- legal awareness
- platform trust building

---

## Blog Creation Rules

Allowed:

```text
ADMIN
```

Optional future:

```text
moderated contributor authors
```

For graduation scope:

admin-managed.

---

## Blog Status Rules

States:

```text
DRAFT
PUBLISHED
ARCHIVED
DELETED
```

Visibility:

Only:

```text
PUBLISHED
```

is public.

---

## Blog Editing Rules

Admin may:

- create
- edit
- archive
- delete

Soft delete preferred.

---

# Payment Business Rules

Payments support monetized landlord features.

Tenants do not purchase landlord management plans.

---

## Payment Actors

Allowed purchaser:

```text
LANDLORD
```

Admin:

may manually inspect / moderate.

Tenant:

normally forbidden.

---

## Payment Status Rules

States:

```text
PENDING
SUCCESS
FAILED
CANCELLED
REFUNDED
EXPIRED
```

---

## Payment Integrity Rules

A payment must:

- belong to one user
- reference one order
- store transaction reference
- preserve auditability

Never overwrite historical payment records.

---

## Payment Failure Rules

If payment fails:

subscription must NOT activate.

---

## Payment Retry Rules

Retry allowed if:

```text
FAILED
CANCELLED
EXPIRED
```

Retry forbidden if:

```text
SUCCESS
```

---

# Subscription Business Rules

Subscriptions unlock premium landlord capabilities.

Relationship:

```text
LANDLORD
   ↓
 SUBSCRIPTION
   ↓
 PACKAGE
   ↓
 SERVICE PLAN
```

Meaning:

- Package is the commercial product a landlord buys.
- Service plan is the technical entitlement template applied after purchase.
- Subscription records the landlord's active ownership of a purchased package and the applied service plan snapshot.

---

## Subscription Creation Rules

Subscription created ONLY after:

successful payment.

Flow:

```text
purchase initiated
→ payment success
→ subscription created
```

Never before payment confirmation.

---

## Subscription Status Rules

States:

```text
ACTIVE
EXPIRED
CANCELLED
SUSPENDED
```

Meaning:

ACTIVE:

premium access granted.

EXPIRED:

premium disabled.

CANCELLED:

manual stop.

SUSPENDED:

administrative restriction.

---

## Expiration Rules

Subscription has:

```text
start_date
end_date
```

Current date > end date:

```text
subscription expired
```

Premium access revoked.

---

## Overlapping Subscription Rules

Policy decision:

Recommended:

extend current subscription.

Example:

existing:

```text
30 days remaining
```

new purchase:

```text
+30 days
```

Result:

```text
60 days
```

Avoid duplicate conflicting active subscriptions.

---

# Service Plan Rules

Service plans define technical premium entitlements.

They answer:

```text
What capabilities does this paid tier unlock?
```

Examples:

```text
Basic
Pro
Enterprise
```

Example features:

- listing quota
- boosted listing quota
- analytics access
- image quota
- priority visibility

---

## Service Plan Governance

Admin may:

- create plan
- edit plan
- deactivate plan

Never hard delete historical plans if referenced.

Use:

```text
is_active
```

---

# Package Rules

Packages define commercial products offered to landlords.

They answer:

```text
What does the landlord buy and at what price?
```

Package examples:

```text
Starter Monthly
Pro Monthly
Pro Quarterly Promotion
```

A package MUST reference one service plan.

```text
package.service_plan_id -> service_plans.id
```

Package owns:

- display name
- public description
- price
- duration
- sale visibility
- optional promotional positioning

Package MUST NOT own low-level feature permission logic.

Service plan owns:

- listing quota
- boost quota
- analytics access
- image quota
- feature entitlement values

Admin may:

- create package
- edit package
- deactivate package

Never hard delete historical packages if referenced by subscriptions, orders, payments, or coupon usages.

---

# Coupon Business Rules

Coupons provide promotional discounts.

---

## Coupon Rules

Coupon may define:

- code
- discount percentage
- fixed discount
- expiration date
- usage limit
- user limit

---

## Coupon Validation Rules

Coupon must be:

- active
- not expired
- within usage limit
- applicable to purchase

Otherwise:

```text
deny coupon
```

---

## Coupon Abuse Prevention

Prevent repeated abuse.

Example:

same user usage rule:

```text
one-time usage
```

Track:

```text
coupon_usages
```

---

# Admin Governance Rules

Admin controls platform integrity.

Admin is NOT a superuser without accountability.

---

## Admin User Management

Admin may:

- lock accounts
- suspend accounts
- restore accounts
- inspect account metadata

Admin should NOT:

hard delete active relational users casually.

---

## Admin Listing Moderation

Admin may:

- approve listings
- reject listings
- archive listings
- remove abuse

Moderation required for:

```text
PENDING_APPROVAL
```

---

## Admin Review Moderation

Admin may:

- hide toxic reviews
- remove spam
- resolve abuse reports

---

## Admin Coupon Governance

Admin manages:

- creation
- activation
- expiration
- usage policies

---

## Admin Feature Governance

Dynamic feature control:

```text
system_features
```

Examples:

```text
POST_BOOST
BLOG_ACCESS
ADVANCED_ANALYTICS
MULTI_IMAGE_UPLOAD
```

Admin may toggle platform access.

---

# Reporting Rules

Users may report abuse.

Targets:

- listings
- reviews
- users
- blog content

---

## Report Status Rules

States:

```text
OPEN
IN_REVIEW
RESOLVED
DISMISSED
```

---

## Reporting Restrictions

Prevent abuse:

same user repeatedly reporting same target:

```text
deny duplicates
```

---

# Audit Logging Rules

Critical actions should be logged.

Examples:

- login
- logout
- password change
- account lock
- booking approval
- payment completion
- admin moderation
- subscription activation

Reason:

production accountability.

---

# Soft Delete Policy

Preferred for critical relational entities.

Apply to:

- users
- motels
- rooms
- posts
- blogs
- service plans

Avoid hard delete unless safe.

Reason:

preserve referential integrity.

---

# State Machine Philosophy

RoomHub is state-driven.

Do NOT treat workflows as unrestricted CRUD.

Examples:

Bad:

```text
set any booking status directly
```

Correct:

controlled transitions only.

Example:

```text
PENDING → APPROVED
PENDING → REJECTED
APPROVED → COMPLETED
PENDING → CANCELLED
```

NOT:

```text
COMPLETED → PENDING
```

---

# Business Source of Truth

All implementation must follow this document.

AI agents and developers must NOT invent conflicting rules.

This document governs:

- API logic
- validation
- authorization
- workflows
- domain constraints
- state transitions

---
