# RoomHub API Endpoint Catalog

I want all UI labels, card titles, and inventory-related text to be displayed in Vietnamese, as this system is specifically designed for Vietnamese users.

Official API endpoint catalog for RoomHub.

This document defines:

- endpoint inventory
- request contracts
- response expectations
- auth requirements
- RBAC access rules
- status codes
- pagination standards
- filtering standards
- naming conventions

This is the API implementation source of truth.

---

# API Philosophy

Rules:

```text
RESTful
predictable
versioned
secure
consistent
frontend-friendly
typed-contract driven
```

No random endpoint naming.

No inconsistent payloads.

---

# Base API Standard

Base path:

```text
/api/v1
```

Examples:

```text
/api/v1/auth/login
/api/v1/posts
/api/v1/bookings
```

---

# Response Envelope Standard

All responses:

```json
{
  "success": true,
  "message": "Operation successful",
  "data": {},
  "timestamp": "2026-01-01T00:00:00Z"
}
```

Paginated:

```json
{
  "success": true,
  "message": "Fetched successfully",
  "data": {
    "items": [],
    "page": 0,
    "size": 10,
    "totalItems": 100,
    "totalPages": 10
  },
  "timestamp": ""
}
```

---

# Auth Header Standard

Protected endpoints:

```http
Authorization: Bearer <access_token>
```

---

# RBAC Legend

Legend:

```text
PUBLIC
TENANT
LANDLORD
ADMIN
AUTHENTICATED
```

Meaning:

PUBLIC:

```text
no login required
```

AUTHENTICATED:

```text
any logged-in user
```

---

# HTTP Status Standard

Common statuses:

```text
200 OK
201 Created
204 No Content
400 Bad Request
401 Unauthorized
403 Forbidden
404 Not Found
409 Conflict
422 Unprocessable Entity
429 Too Many Requests
500 Internal Server Error
```

---

# Pagination Standard

Query params:

```text
?page=0
&size=10
```

Optional:

```text
&sort=createdAt,desc
```

Default:

```text
page=0
size=10
```

Max:

```text
size=100
```

---

# Filtering Standard

Examples:

```text
?status=PUBLISHED
?city=Hanoi
?district=CauGiay
?minPrice=1000000
?maxPrice=5000000
```

---

# AUTH MODULE

Base:

```text
/api/v1/auth
```

---
# POST /auth/register

Purpose:

register new user.

Access:

```text
PUBLIC
```

Request:

```json
{
  "fullName": "Nguyen Van A",
  "email": "user@test.com",
  "password": "StrongPassword123!",
  "phoneNumber": "0900000000",
  "role": "TENANT"
}
```

Rules:

allowed roles:

```text
TENANT
LANDLORD
```

Never ADMIN.

Responses:

```text
201 Created
400 Validation error
409 Email exists
```

---

# POST /auth/login

Purpose:

authenticate user.

Access:

```text
PUBLIC
```

Request:

```json
{
  "email": "user@test.com",
  "password": "password"
}
```

Response:

```json
{
  "accessToken": "jwt",
  "user": {}
}
```

Refresh token:

```text
httpOnly cookie
```

Responses:

```text
200
401 invalid credentials
423 locked account
```

---

# POST /auth/refresh

Purpose:

refresh access token.

Access:

```text
PUBLIC (cookie-based validation)
```

Request:

```text
refresh token cookie
```

Response:

```json
{
  "accessToken": "new-jwt"
}
```

Responses:

```text
200
401 invalid refresh token
```

---

# POST /auth/logout

Purpose:

logout current session.

Access:

```text
AUTHENTICATED
```

Behavior:

```text
revoke refresh token
clear cookie
```

Responses:

```text
200
401
```

---

# GET /auth/me

Purpose:

current authenticated user profile.

Access:

```text
AUTHENTICATED
```

Response:

```json
{
  "id": 1,
  "fullName": "A",
  "email": "a@test.com",
  "role": "TENANT",
  "avatarUrl": ""
}
```

---

# PATCH /auth/change-password

Access:

```text
AUTHENTICATED
```

Request:

```json
{
  "currentPassword": "",
  "newPassword": ""
}
```

Responses:

```text
200
400
401
```

---

# POST /auth/forgot-password

Access:

```text
PUBLIC
```

Request:

```json
{
  "email": "user@test.com"
}
```

Response:

generic.

Never reveal account existence.

---

# POST /auth/reset-password

Access:

```text
PUBLIC
```

Request:

```json
{
  "token": "",
  "newPassword": ""
}
```

---

# USERS MODULE

Base:

```text
/api/v1/users
```

---

# GET /users/profile

Access:

```text
AUTHENTICATED
```

Purpose:

own profile.

---

# PATCH /users/profile

Access:

```text
AUTHENTICATED
```

Editable:

```text
fullName
phoneNumber
avatarUrl
```

Not editable:

```text
role
status
passwordHash
emailVerifiedAt
```

---

# DELETE /users/profile

Access:

```text
AUTHENTICATED
```

Behavior:

soft delete own account.

---

# GET /users/{id}

Access:

```text
ADMIN
```

Purpose:

view user detail.

Prevent IDOR.

---
# LANDLORD MODULE

Base:

```text
/api/v1/landlord
```

Access:

```text
LANDLORD
```

Purpose:

landlord-specific dashboard + management operations.

---

# GET /landlord/dashboard

Purpose:

dashboard summary.

Response:

```json
{
  "totalMotels": 10,
  "totalRooms": 120,
  "availableRooms": 80,
  "activePosts": 50,
  "pendingBookings": 12,
  "activeSubscription": {}
}
```

---

# GET /landlord/statistics

Purpose:

analytics.

Optional filters:

```text
?from=2026-01-01
&to=2026-01-31
```

Metrics:

```text
bookings
revenue
views
boost performance
conversion
```

---

# MOTELS MODULE

Base:

```text
/api/v1/motels
```

---

# POST /motels

Access:

```text
LANDLORD
```

Purpose:

create motel.

Request:

```json
{
  "name": "RoomHub Residence",
  "description": "Near university",
  "addressLine": "123 Street",
  "city": "Hanoi",
  "district": "Cau Giay",
  "ward": "Dich Vong",
  "latitude": 21.036,
  "longitude": 105.782
}
```

Response:

```text
201 Created
```

---

# GET /motels

Access:

```text
AUTHENTICATED
```

Purpose:

list motels owned by landlord OR admin management view.

LANDLORD:

returns own motels.

ADMIN:

returns filtered management view.

Filters:

```text
?status=ACTIVE
?page=0
&size=10
```

---

# GET /motels/{id}

Access:

```text
AUTHENTICATED
```

Rules:

LANDLORD:

```text
own motel only
```

ADMIN:

```text
all
```

Prevent IDOR.

---

# PATCH /motels/{id}

Access:

```text
LANDLORD
```

Rules:

owner only.

Editable:

```text
name
description
address
location
status (limited)
```

---

# DELETE /motels/{id}

Access:

```text
LANDLORD
```

Behavior:

soft delete.

Rules:

cannot delete if:

```text
active bookings
active rented rooms
financial dependency
```

Responses:

```text
409 conflict
```

---

# ROOMS MODULE

Base:

```text
/api/v1/rooms
```

---

# POST /rooms

Access:

```text
LANDLORD
```

Purpose:

create room.

Request:

```json
{
  "motelId": 1,
  "name": "Room A101",
  "description": "Air conditioned",
  "price": 3500000,
  "depositAmount": 1000000,
  "areaSqm": 24,
  "capacity": 2,
  "bedroomCount": 1,
  "bathroomCount": 1
}
```

Rules:

motel ownership validation required.

---

# GET /rooms

Access:

```text
AUTHENTICATED
```

Modes:

LANDLORD:

own rooms.

ADMIN:

management.

Optional filters:

```text
?motelId=1
?status=AVAILABLE
```

---

# GET /rooms/{id}

Access:

```text
AUTHENTICATED
```

Rules:

ownership/admin validation.

---

# PATCH /rooms/{id}

Access:

```text
LANDLORD
```

Editable:

```text
pricing
description
capacity
status
```

Rules:

owner only.

---

# DELETE /rooms/{id}

Access:

```text
LANDLORD
```

Behavior:

soft delete.

Blocked if:

```text
active booking
active rental contract
published dependency
```

---

# ROOM IMAGES MODULE

Base:

```text
/api/v1/rooms/{roomId}/images
```

---

# POST /rooms/{roomId}/images

Access:

```text
LANDLORD
```

Content:

```text
multipart/form-data
```

Rules:

```text
ownership required
image validation required
max count limit
size limit
```

Response:

uploaded URLs.

---

# GET /rooms/{roomId}/images

Access:

```text
AUTHENTICATED
```

---

# DELETE /rooms/{roomId}/images/{imageId}

Access:

```text
LANDLORD
```

Rules:

ownership required.

---

# POSTS MODULE

Base:

```text
/api/v1/posts
```

Purpose:

listing marketplace.

---

# POST /posts

Access:

```text
LANDLORD
```

Request:

```json
{
  "roomId": 1,
  "title": "Phòng trọ gần đại học",
  "description": "Đầy đủ nội thất"
}
```

Rules:

```text
room ownership validation
subscription quota validation
business rule validation
```

Response:

```text
201 Created
```

Initial status:

```text
DRAFT or PENDING_APPROVAL
```

depending business flow.

---

# GET /posts

Access:

```text
PUBLIC
```

Purpose:

public marketplace listing.

Filters:

```text
?page=0
&size=12
&city=Hanoi
&district=CauGiay
&minPrice=1000000
&maxPrice=5000000
&status=PUBLISHED
&keyword=studio
```

Sorting:

```text
?sort=createdAt,desc
?sort=price,asc
```

---

# GET /posts/{id}

Access:

```text
PUBLIC
```

Purpose:

listing detail.

Response:

```json
{
  "post": {},
  "room": {},
  "motel": {},
  "images": [],
  "reviews": []
}
```

---

# PATCH /posts/{id}

Access:

```text
LANDLORD
```

Rules:

owner only.

Editable:

```text
title
description
publish state
```

Blocked if:

moderation lock.

---

# DELETE /posts/{id}

Access:

```text
LANDLORD
```

Behavior:

soft delete.

---

# POST /posts/{id/publish}

Access:

```text
LANDLORD
```

Purpose:

publish listing.

Validations:

```text
subscription active
quota available
room eligible
moderation pass (if required)
```

---

# POST /posts/{id/archive}

Access:

```text
LANDLORD
```

Purpose:

archive listing.

---

# MODERATION MODULE

Base:

```text
/api/v1/admin/moderation
```

Access:

```text
ADMIN
```

---

# GET /admin/moderation/posts

Purpose:

pending moderation queue.

Filters:

```text
?status=PENDING_APPROVAL
```

---

# PATCH /admin/moderation/posts/{id}/approve

Access:

```text
ADMIN
```

Purpose:

approve listing.

---

# PATCH /admin/moderation/posts/{id}/reject

Access:

```text
ADMIN
```

Request:

```json
{
  "reason": "Spam / invalid content"
}
```

---

# GET /admin/moderation/reviews

Purpose:

review moderation queue.

---

# PATCH /admin/moderation/reviews/{id}/hide

Access:

```text
ADMIN
```

---

# PATCH /admin/moderation/reviews/{id}/restore

Access:

```text
ADMIN
```

---
# BOOKINGS MODULE

Base:

```text
/api/v1/bookings
```

Purpose:

tenant booking workflow.

---

# POST /bookings

Access:

```text
TENANT
```

Purpose:

create booking request.

Request:

```json
{
  "roomId": 15,
  "requestedMoveInDate": "2026-06-01",
  "note": "Can move in after 6 PM"
}
```

Validations:

```text
room exists
room available
room not deleted
tenant active
tenant cannot book own room
duplicate pending booking prevention
```

Responses:

```text
201 Created
400 validation
404 room not found
409 duplicate/conflict
```

---

# GET /bookings

Access:

```text
AUTHENTICATED
```

Behavior:

TENANT:

```text
own bookings
```

LANDLORD:

```text
bookings for owned rooms
```

ADMIN:

```text
all bookings
```

Filters:

```text
?status=PENDING
?page=0
&size=10
```

---

# GET /bookings/{id}

Access:

```text
AUTHENTICATED
```

Rules:

ownership / authorization required.

Prevent IDOR.

---

# PATCH /bookings/{id}/confirm

Access:

```text
LANDLORD
```

Purpose:

approve booking.

Validations:

```text
owns target room
booking pending
room still available
race-condition safe
```

Effects:

```text
booking -> CONFIRMED
room status -> RESERVED or RENTED
notification dispatch
activity log
```

Responses:

```text
200
404
409
```

---

# PATCH /bookings/{id}/reject

Access:

```text
LANDLORD
```

Request:

```json
{
  "reason": "Room no longer available"
}
```

Effects:

```text
booking -> REJECTED
notification dispatch
```

---

# PATCH /bookings/{id}/cancel

Access:

```text
AUTHENTICATED
```

Rules:

TENANT:

cancel own pending booking.

LANDLORD:

cancel owned booking if business allows.

ADMIN:

override.

---

# PATCH /bookings/{id}/complete

Access:

```text
LANDLORD / ADMIN
```

Purpose:

mark completed.

---

# FAVORITES MODULE

Base:

```text
/api/v1/favorites
```

---

# POST /favorites

Access:

```text
TENANT
```

Request:

```json
{
  "postId": 20
}
```

Rules:

```text
prevent duplicates
post must exist
post must be visible
```

---

# GET /favorites

Access:

```text
TENANT
```

Purpose:

saved listings.

Pagination:

supported.

---

# DELETE /favorites/{postId}

Access:

```text
TENANT
```

Purpose:

remove saved listing.

---

# REVIEWS MODULE

Base:

```text
/api/v1/reviews
```

---

# POST /reviews

Access:

```text
TENANT
```

Purpose:

submit review.

Request:

```json
{
  "motelId": 1,
  "bookingId": 100,
  "rating": 5,
  "comment": "Great place"
}
```

Validations:

```text
verified stay required
booking ownership required
rating 1-5
duplicate prevention
```

---

# GET /reviews

Access:

```text
PUBLIC
```

Filters:

```text
?motelId=1
?page=0
&size=10
```

Only visible reviews.

---

# PATCH /reviews/{id}

Access:

```text
TENANT
```

Rules:

author only
editable within business-defined window

---

# DELETE /reviews/{id}

Access:

```text
TENANT
```

Behavior:

soft delete or hide.

---

# NOTIFICATIONS MODULE

Base:

```text
/api/v1/notifications
```

---

# GET /notifications

Access:

```text
AUTHENTICATED
```

Purpose:

user inbox.

Pagination:

supported.

---

# PATCH /notifications/{id}/read

Access:

```text
AUTHENTICATED
```

Purpose:

mark read.

Ownership required.

---

# PATCH /notifications/read-all

Access:

```text
AUTHENTICATED
```

Purpose:

bulk mark read.

---

# REPORTS MODULE

Base:

```text
/api/v1/reports
```

---

# POST /reports

Access:

```text
AUTHENTICATED
```

Purpose:

report abuse/content.

Request:

```json
{
  "targetType": "POST",
  "targetId": 10,
  "reason": "Spam",
  "details": "Repeated fake content"
}
```

Validations:

```text
valid target type
target exists
rate limiting
```

---

# GET /reports

Access:

```text
ADMIN
```

Filters:

```text
?status=OPEN
```

---

# PATCH /reports/{id}/resolve

Access:

```text
ADMIN
```

---

# PATCH /reports/{id}/dismiss

Access:

```text
ADMIN
```

---

# PUBLIC SEARCH MODULE

Base:

```text
/api/v1/search
```

---

# GET /search/posts

Access:

```text
PUBLIC
```

Purpose:

advanced listing search.

Filters:

```text
keyword
city
district
ward
minPrice
maxPrice
minArea
maxArea
capacity
sort
page
size
```

Example:

```text
/search/posts?city=Hanoi&maxPrice=4000000&capacity=2
```

---

# GET /search/suggestions

Access:

```text
PUBLIC
```

Purpose:

autocomplete.

Query:

```text
?q=studio
```

Returns:

```text
keyword suggestions
location suggestions
```

---

# RECOMMENDATION MODULE

Base:

```text
/api/v1/recommendations
```

---

# GET /recommendations/posts

Access:

```text
AUTHENTICATED
```

Purpose:

personalized recommendations.

Logic sources:

```text
favorites
recent views
search history
location preference
```

Fallback:

popular listings.

---

# RECENT HISTORY MODULE

Base:

```text
/api/v1/history
```

---

# GET /history/recent-views

Access:

```text
AUTHENTICATED
```

Purpose:

recently viewed posts.

---

# POST /history/recent-views

Access:

```text
AUTHENTICATED
```

Request:

```json
{
  "postId": 10
}
```

Purpose:

track views.

Rate-limited / deduplicated.

---
# PAYMENTS MODULE

Base:

```text
/api/v1/payments
```

Purpose:

payment processing + subscription monetization.

---

# POST /payments/create-subscription-payment

Access:

```text
LANDLORD
```

Purpose:

initiate package purchase.

Packages are commercial products.

Each package references a service plan that defines technical entitlements.

Request:

```json
{
  "packageId": 2,
  "couponCode": "WELCOME10"
}
```

Flow:

```text
validate package
load referenced service plan
validate coupon
calculate final amount
create payment record (PENDING)
create provider payment URL/session
```

Response:

```json
{
  "paymentReference": "PAY-20260519-ABC123",
  "paymentUrl": "https://provider.com/pay/..."
}
```

Responses:

```text
200
400 invalid coupon
404 package not found
409 invalid state
```

---

# GET /payments/{paymentReference}

Access:

```text
AUTHENTICATED
```

Purpose:

payment status lookup.

Rules:

ownership required unless ADMIN.

---

# POST /payments/provider/callback

Access:

```text
PUBLIC
```

Purpose:

payment provider callback/webhook.

Examples:

```text
VNPay
MoMo
ZaloPay
Stripe
```

Rules:

```text
signature verification mandatory
idempotency mandatory
never trust raw callback blindly
```

Effects:

```text
payment -> SUCCESS / FAILED
subscription activation
coupon redemption
activity log
notification
```

Responses:

```text
200
400 invalid signature
409 duplicate callback
```

---

# POST /payments/provider/return

Access:

```text
PUBLIC
```

Purpose:

frontend redirect return endpoint.

IMPORTANT:

does NOT finalize payment alone.

Only display status.

Backend callback is source of truth.

---

# POST /payments/refund

Access:

```text
ADMIN
```

Purpose:

refund payment.

Request:

```json
{
  "paymentReference": "PAY-123",
  "reason": "Manual refund"
}
```

Rules:

```text
refundable status validation
provider support validation
authorization validation
```

---

# SUBSCRIPTIONS MODULE

Base:

```text
/api/v1/subscriptions
```

---

# GET /subscriptions/me

Access:

```text
LANDLORD
```

Purpose:

current subscription.

Response:

```json
{
  "status": "ACTIVE",
  "package": {},
  "servicePlan": {},
  "expiresAt": "",
  "remainingPostQuota": 10,
  "remainingBoostQuota": 2
}
```

---

# GET /subscriptions/history

Access:

```text
LANDLORD
```

Purpose:

subscription history.

Pagination:

supported.

---

# GET /packages

Access:

```text
PUBLIC
```

Purpose:

view available commercial packages.

Only active plans visible.

Each package response includes referenced service plan summary.

---

# ADMIN PACKAGE MANAGEMENT

Base:

```text
/api/v1/admin/packages
```

Access:

```text
ADMIN
```

---

# POST /admin/packages

Create package.

---

# GET /admin/packages

List all packages.

---

# PATCH /admin/packages/{id}

Update package.

---

# DELETE /admin/packages/{id}

Soft disable package.

---

# SERVICE PLANS MODULE

Base:

```text
/api/v1/admin/service-plans
```

Access:

```text
ADMIN
```

Purpose:

manage technical entitlement templates used by packages.

Service plans are not purchased directly.

---

# POST /admin/service-plans

Create service plan.

---

# GET /admin/service-plans

List service plans.

---

# PATCH /admin/service-plans/{id}

Update service plan.

---

# PATCH /admin/service-plans/{id}/deactivate

Soft disable service plan.

---

# COUPONS MODULE

Base:

```text
/api/v1/coupons
```

---

# POST /coupons/validate

Access:

```text
AUTHENTICATED
```

Purpose:

coupon pre-validation.

Request:

```json
{
  "code": "WELCOME10",
  "packageId": 2
}
```

Response:

```json
{
  "valid": true,
  "discountAmount": 100000,
  "finalAmount": 900000
}
```

---

# ADMIN COUPON MANAGEMENT

Base:

```text
/api/v1/admin/coupons
```

Access:

```text
ADMIN
```

Endpoints:

```text
POST   /admin/coupons
GET    /admin/coupons
GET    /admin/coupons/{id}
PATCH  /admin/coupons/{id}
DELETE /admin/coupons/{id}
```

---

# FILE UPLOAD MODULE

Base:

```text
/api/v1/uploads
```

Purpose:

media upload.

---

# POST /uploads/images

Access:

```text
AUTHENTICATED
```

Content:

```text
multipart/form-data
```

Rules:

```text
mime validation
size validation
virus scanning (future)
ownership rules
rate limiting
```

Response:

```json
{
  "url": "https://cloudinary.com/..."
}
```

Allowed:

```text
jpg
jpeg
png
webp
```

Blocked:

```text
exe
js
html
svg (unless sanitized)
```

---

# ADMIN USERS MODULE

Base:

```text
/api/v1/admin/users
```

Access:

```text
ADMIN
```

---

# GET /admin/users

Purpose:

user management.

Filters:

```text
?role=LANDLORD
?status=ACTIVE
?page=0
&size=20
```

---

# GET /admin/users/{id}

User detail.

---

# PATCH /admin/users/{id}/lock

Lock user.

---

# PATCH /admin/users/{id}/unlock

Unlock user.

---

# PATCH /admin/users/{id}/suspend

Suspend user.

---

# PATCH /admin/users/{id}/activate

Activate user.

---

# ADMIN DASHBOARD MODULE

Base:

```text
/api/v1/admin/dashboard
```

Access:

```text
ADMIN
```

---

# GET /admin/dashboard/summary

Response metrics:

```json
{
  "totalUsers": 1000,
  "totalLandlords": 200,
  "totalTenants": 800,
  "activePosts": 320,
  "pendingModeration": 14,
  "monthlyRevenue": 15000000
}
```

---

# GET /admin/dashboard/analytics

Metrics:

```text
growth
revenue
subscriptions
booking trends
report trends
moderation stats
```

Date filters:

supported.

---

# AUDIT MODULE

Base:

```text
/api/v1/admin/audit
```

Access:

```text
ADMIN
```

---

# GET /admin/audit/logs

Filters:

```text
?userId=1
?entityType=PAYMENT
?from=...
?to=...
```

Pagination:

required.

---

# SECURITY MODULE

Base:

```text
/api/v1/admin/security
```

Access:

```text
ADMIN
```

Examples:

```text
failed login attempts
suspicious activity
token revocations
blocked IP review
```

---

# HEALTH MODULE

Base:

```text
/api/v1/health
```

---

# GET /health

Access:

```text
PUBLIC (environment dependent)
```

Response:

```json
{
  "status": "UP"
}
```

Production:

minimal exposure preferred.

---

# API VERSIONING RULE

Current:

```text
v1
```

Breaking changes:

new version.

Example:

```text
/api/v2/auth/login
```

Do NOT silently break clients.

---

# IDEMPOTENCY RULE

Mandatory for:

```text
payment callbacks
refunds
critical transactional actions
```

---

# RATE LIMIT TARGETS

Apply protection to:

```text
login
register
forgot password
reset password
reports
uploads
payment endpoints
```

---

# API SECURITY RULES

Mandatory:

```text
JWT validation
RBAC enforcement
ownership checks
input validation
output sanitization
IDOR prevention
mass assignment prevention
rate limiting
CSRF strategy (if cookie auth)
secure file validation
```

---

# API SOURCE OF TRUTH

This document governs:

```text
endpoint inventory
request design
auth requirements
RBAC access
pagination
filters
status expectations
security constraints
```

All RoomHub API implementation must comply.

---
