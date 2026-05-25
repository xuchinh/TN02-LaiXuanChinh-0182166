# RoomHub API Request / Response Schemas

I want all UI labels, card titles, and inventory-related text to be displayed in Vietnamese, as this system is specifically designed for Vietnamese users.

Official DTO contract catalog for RoomHub.

This document defines:

- request DTO schemas
- response DTO schemas
- validation constraints
- enum contracts
- pagination DTO contracts
- error response schemas
- auth payload standards

This document is the DTO/API contract source of truth.

---

# DTO Philosophy

Rules:

```text
strict typing
predictable shape
frontend-safe
backend-safe
no entity leakage
validation-first
version-safe
```

Never expose raw JPA entities.

Never invent response shape per endpoint.

---

# Common Response Envelope

Success:

```json
{
  "success": true,
  "message": "Success",
  "data": {},
  "timestamp": "2026-01-01T00:00:00Z"
}
```

---

Failure:

```json
{
  "success": false,
  "message": "Validation failed",
  "errors": [],
  "timestamp": "2026-01-01T00:00:00Z"
}
```

---

# Validation Error Schema

Example:

```json
{
  "success": false,
  "message": "Validation failed",
  "errors": [
    {
      "field": "email",
      "code": "INVALID_EMAIL",
      "message": "Email format invalid"
    }
  ],
  "timestamp": ""
}
```

---

# Pagination Schema

Request:

```text
?page=0
&size=10
&sort=createdAt,desc
```

Response:

```json
{
  "items": [],
  "page": 0,
  "size": 10,
  "totalItems": 120,
  "totalPages": 12,
  "hasNext": true,
  "hasPrevious": false
}
```

---

# AUTH DTOs

## RegisterRequest

```json
{
  "fullName": "Nguyen Van A",
  "email": "user@test.com",
  "password": "StrongPassword123!",
  "phoneNumber": "0900000000",
  "role": "TENANT"
}
```

Validation:

```text
fullName:
required
min 2
max 150

email:
required
valid email
lowercase normalized

password:
required
min 8
max 100
uppercase required
lowercase required
number required
special char required

phoneNumber:
optional
valid VN phone format

role:
required
TENANT or LANDLORD only
```

---

## RegisterResponse

```json
{
  "id": 1,
  "email": "user@test.com",
  "fullName": "Nguyen Van A",
  "role": "TENANT",
  "createdAt": ""
}
```

---

## LoginRequest

```json
{
  "email": "user@test.com",
  "password": "StrongPassword123!"
}
```

Validation:

```text
email required
password required
```

---

## LoginResponse

```json
{
  "accessToken": "jwt-token",
  "expiresIn": 900,
  "user": {
    "id": 1,
    "fullName": "Nguyen Van A",
    "email": "user@test.com",
    "role": "TENANT",
    "avatarUrl": null,
    "status": "ACTIVE"
  }
}
```

Notes:

```text
refresh token = httpOnly cookie
not in JSON body
```

---

## RefreshTokenResponse

```json
{
  "accessToken": "new-jwt-token",
  "expiresIn": 900
}
```

---

## ChangePasswordRequest

```json
{
  "currentPassword": "OldPass123!",
  "newPassword": "NewPass123!"
}
```

Validation:

same password policy.

---

## ForgotPasswordRequest

```json
{
  "email": "user@test.com"
}
```

---

## ResetPasswordRequest

```json
{
  "token": "reset-token",
  "newPassword": "NewPass123!"
}
```

---

## MeResponse

```json
{
  "id": 1,
  "fullName": "Nguyen Van A",
  "email": "user@test.com",
  "phoneNumber": "0900000000",
  "role": "TENANT",
  "avatarUrl": "",
  "status": "ACTIVE",
  "emailVerified": true,
  "createdAt": ""
}
```

---

# USER DTOs

## UpdateProfileRequest

```json
{
  "fullName": "Updated Name",
  "phoneNumber": "0900000000",
  "avatarUrl": "https://..."
}
```

Validation:

```text
fullName optional
max 150

phoneNumber optional
valid format

avatarUrl optional
valid URL
```

---

## UserSummaryResponse

```json
{
  "id": 1,
  "fullName": "User",
  "email": "user@test.com",
  "role": "TENANT",
  "status": "ACTIVE",
  "createdAt": ""
}
```

---

# ENUM CONTRACTS

## UserRole

```text
TENANT
LANDLORD
ADMIN
```

---

## UserStatus

```text
ACTIVE
LOCKED
SUSPENDED
PENDING_VERIFICATION
DELETED
```

---

## SortDirection

```text
asc
desc
```

---

# SECURITY RESPONSE DTOs

## UnauthorizedResponse

```json
{
  "success": false,
  "message": "Unauthorized"
}
```

---

## ForbiddenResponse

```json
{
  "success": false,
  "message": "Forbidden"
}
```

---

## NotFoundResponse

```json
{
  "success": false,
  "message": "Resource not found"
}
```

---

## ConflictResponse

```json
{
  "success": false,
  "message": "Conflict"
}
```

---
# MOTEL DTOs

## CreateMotelRequest

```json
{
  "name": "RoomHub Residence",
  "description": "Near university, secure area",
  "addressLine": "123 Xuan Thuy Street",
  "city": "Hanoi",
  "district": "Cau Giay",
  "ward": "Dich Vong",
  "latitude": 21.036,
  "longitude": 105.782
}
```

Validation:

```text
name:
required
min 3
max 150

description:
optional
max 5000

addressLine:
required
max 255

city:
required
max 100

district:
required
max 100

ward:
optional
max 100

latitude:
optional
range -90 to 90

longitude:
optional
range -180 to 180
```

---

## UpdateMotelRequest

```json
{
  "name": "Updated Motel",
  "description": "Updated description",
  "addressLine": "456 New Street",
  "city": "Hanoi",
  "district": "Nam Tu Liem",
  "ward": "My Dinh"
}
```

All fields optional.

---

## MotelSummaryResponse

```json
{
  "id": 1,
  "name": "RoomHub Residence",
  "city": "Hanoi",
  "district": "Cau Giay",
  "status": "ACTIVE",
  "roomCount": 24,
  "createdAt": ""
}
```

---

## MotelDetailResponse

```json
{
  "id": 1,
  "name": "RoomHub Residence",
  "description": "Near university",
  "addressLine": "123 Xuan Thuy Street",
  "city": "Hanoi",
  "district": "Cau Giay",
  "ward": "Dich Vong",
  "latitude": 21.036,
  "longitude": 105.782,
  "status": "ACTIVE",
  "roomCount": 24,
  "owner": {
    "id": 2,
    "fullName": "Landlord Name"
  },
  "createdAt": "",
  "updatedAt": ""
}
```

---

# ROOM DTOs

## CreateRoomRequest

```json
{
  "motelId": 1,
  "name": "Room A101",
  "description": "Air conditioned room",
  "price": 3500000,
  "depositAmount": 1000000,
  "areaSqm": 24,
  "capacity": 2,
  "bedroomCount": 1,
  "bathroomCount": 1
}
```

Validation:

```text
motelId required

name:
required
min 2
max 120

description:
optional
max 5000

price:
required
>= 0

depositAmount:
optional
>= 0

areaSqm:
required
> 0

capacity:
required
>= 1

bedroomCount:
>= 0

bathroomCount:
>= 0
```

---

## UpdateRoomRequest

```json
{
  "name": "Updated Room",
  "description": "Updated desc",
  "price": 4000000,
  "depositAmount": 1500000,
  "capacity": 3,
  "status": "AVAILABLE"
}
```

Partial update.

---

## RoomSummaryResponse

```json
{
  "id": 1,
  "name": "Room A101",
  "price": 3500000,
  "depositAmount": 1000000,
  "areaSqm": 24,
  "capacity": 2,
  "status": "AVAILABLE",
  "thumbnailUrl": "https://...",
  "createdAt": ""
}
```

---

## RoomDetailResponse

```json
{
  "id": 1,
  "motelId": 1,
  "name": "Room A101",
  "description": "Air conditioned",
  "price": 3500000,
  "depositAmount": 1000000,
  "areaSqm": 24,
  "capacity": 2,
  "bedroomCount": 1,
  "bathroomCount": 1,
  "status": "AVAILABLE",
  "images": [],
  "createdAt": "",
  "updatedAt": ""
}
```

---

# ROOM IMAGE DTOs

## UploadRoomImageResponse

```json
{
  "id": 100,
  "url": "https://cloudinary.com/image.jpg",
  "isPrimary": false,
  "uploadedAt": ""
}
```

---

## RoomImageResponse

```json
{
  "id": 100,
  "url": "https://cloudinary.com/image.jpg",
  "isPrimary": true
}
```

---

# POST DTOs

## CreatePostRequest

```json
{
  "roomId": 1,
  "title": "Phòng trọ gần đại học",
  "description": "Đầy đủ nội thất"
}
```

Validation:

```text
roomId required

title:
required
min 10
max 200

description:
required
min 20
max 10000
```

---

## UpdatePostRequest

```json
{
  "title": "Updated listing title",
  "description": "Updated listing description"
}
```

Partial update.

---

## PostSummaryResponse

```json
{
  "id": 1,
  "title": "Studio near university",
  "price": 3500000,
  "city": "Hanoi",
  "district": "Cau Giay",
  "thumbnailUrl": "https://...",
  "status": "PUBLISHED",
  "createdAt": ""
}
```

---

## PostDetailResponse

```json
{
  "id": 1,
  "title": "Studio near university",
  "description": "Full furnished",
  "status": "PUBLISHED",
  "room": {
    "id": 1,
    "name": "Room A101",
    "price": 3500000,
    "depositAmount": 1000000,
    "areaSqm": 24,
    "capacity": 2
  },
  "motel": {
    "id": 1,
    "name": "RoomHub Residence",
    "city": "Hanoi",
    "district": "Cau Giay"
  },
  "images": [],
  "landlord": {
    "id": 10,
    "fullName": "Owner Name",
    "avatarUrl": ""
  },
  "createdAt": "",
  "updatedAt": ""
}
```

---

# SEARCH DTOs

## SearchPostsRequest (Query Params)

```text
keyword=
city=
district=
ward=
minPrice=
maxPrice=
minArea=
maxArea=
capacity=
sort=
page=
size=
```

Validation:

```text
minPrice >= 0
maxPrice >= minPrice
minArea > 0
maxArea >= minArea
capacity >= 1
page >= 0
size 1..100
```

---

## SearchSuggestionResponse

```json
{
  "keywords": [
    "studio",
    "cheap room"
  ],
  "locations": [
    "Cau Giay",
    "Ha Dong"
  ]
}
```

---

# ENUM CONTRACTS

## MotelStatus

```text
ACTIVE
INACTIVE
SUSPENDED
DELETED
```

---

## RoomStatus

```text
AVAILABLE
RESERVED
RENTED
MAINTENANCE
HIDDEN
DELETED
```

---

## PostStatus

```text
DRAFT
PENDING_APPROVAL
PUBLISHED
REJECTED
ARCHIVED
DELETED
```

---
# BOOKING DTOs

## CreateBookingRequest

```json
{
  "roomId": 15,
  "requestedMoveInDate": "2026-06-01",
  "note": "Can move in after 6 PM"
}
```

Validation:

```text
roomId:
required
positive integer

requestedMoveInDate:
required
must be future or today (business rule dependent)

note:
optional
max 1000
```

---

## BookingSummaryResponse

```json
{
  "id": 100,
  "roomId": 15,
  "roomName": "Room A101",
  "postId": 50,
  "tenant": {
    "id": 3,
    "fullName": "Nguyen Van B"
  },
  "status": "PENDING",
  "requestedMoveInDate": "2026-06-01",
  "createdAt": ""
}
```

---

## BookingDetailResponse

```json
{
  "id": 100,
  "room": {
    "id": 15,
    "name": "Room A101",
    "price": 3500000
  },
  "tenant": {
    "id": 3,
    "fullName": "Nguyen Van B",
    "phoneNumber": "0900000000"
  },
  "landlord": {
    "id": 10,
    "fullName": "Owner Name"
  },
  "status": "PENDING",
  "requestedMoveInDate": "2026-06-01",
  "note": "Can move in after 6 PM",
  "rejectionReason": null,
  "createdAt": "",
  "updatedAt": ""
}
```

---

## RejectBookingRequest

```json
{
  "reason": "Room no longer available"
}
```

Validation:

```text
required
max 1000
```

---

# FAVORITE DTOs

## AddFavoriteRequest

```json
{
  "postId": 20
}
```

Validation:

```text
postId required
positive integer
```

---

## FavoriteSummaryResponse

```json
{
  "id": 1,
  "post": {
    "id": 20,
    "title": "Studio near university",
    "price": 3500000,
    "thumbnailUrl": "https://..."
  },
  "savedAt": ""
}
```

---

# REVIEW DTOs

## CreateReviewRequest

```json
{
  "motelId": 1,
  "bookingId": 100,
  "rating": 5,
  "comment": "Great place"
}
```

Validation:

```text
motelId required
bookingId required
rating 1..5
comment required
min 5
max 3000
```

---

## UpdateReviewRequest

```json
{
  "rating": 4,
  "comment": "Updated review"
}
```

---

## ReviewResponse

```json
{
  "id": 10,
  "author": {
    "id": 3,
    "fullName": "Nguyen Van B",
    "avatarUrl": ""
  },
  "rating": 5,
  "comment": "Great place",
  "createdAt": "",
  "updatedAt": ""
}
```

---

# NOTIFICATION DTOs

## NotificationResponse

```json
{
  "id": 1000,
  "type": "BOOKING_CONFIRMED",
  "title": "Booking confirmed",
  "message": "Your booking has been confirmed",
  "read": false,
  "metadata": {
    "bookingId": 100
  },
  "createdAt": ""
}
```

---

## MarkNotificationReadResponse

```json
{
  "updated": true
}
```

---

# REPORT DTOs

## CreateReportRequest

```json
{
  "targetType": "POST",
  "targetId": 10,
  "reason": "Spam",
  "details": "Repeated fake content"
}
```

Validation:

```text
targetType required
targetId required
reason required
max 255
details optional
max 3000
```

---

## ReportResponse

```json
{
  "id": 900,
  "targetType": "POST",
  "targetId": 10,
  "reason": "Spam",
  "status": "OPEN",
  "createdAt": ""
}
```

---

# RECENT HISTORY DTOs

## TrackRecentViewRequest

```json
{
  "postId": 10
}
```

---

## RecentViewResponse

```json
{
  "id": 1,
  "post": {
    "id": 10,
    "title": "Studio",
    "thumbnailUrl": "https://..."
  },
  "viewedAt": ""
}
```

---

# RECOMMENDATION DTOs

## RecommendationPostResponse

```json
{
  "postId": 15,
  "title": "Suggested room",
  "price": 4200000,
  "city": "Hanoi",
  "district": "Cau Giay",
  "score": 0.92,
  "thumbnailUrl": "https://..."
}
```

---

# ENUM CONTRACTS

## BookingStatus

```text
PENDING
CONFIRMED
REJECTED
CANCELLED
COMPLETED
EXPIRED
```

---

## NotificationType

```text
BOOKING_CREATED
BOOKING_CONFIRMED
BOOKING_REJECTED
BOOKING_CANCELLED
PAYMENT_SUCCESS
PAYMENT_FAILED
SUBSCRIPTION_EXPIRING
SUBSCRIPTION_ACTIVATED
REPORT_RESOLVED
SYSTEM_ANNOUNCEMENT
```

---

## ReportTargetType

```text
POST
REVIEW
USER
MOTEL
ROOM
```

---

## ReportStatus

```text
OPEN
IN_REVIEW
RESOLVED
DISMISSED
```

---
# PAYMENT DTOs

## CreateSubscriptionPaymentRequest

```json
{
  "packageId": 2,
  "couponCode": "WELCOME10"
}
```

Validation:

```text
packageId:
required
positive integer

couponCode:
optional
max 50
uppercase normalized
```

---

## CreateSubscriptionPaymentResponse

```json
{
  "paymentReference": "PAY-20260519-ABC123",
  "paymentProvider": "VNPAY",
  "paymentUrl": "https://provider.com/pay/...",
  "amount": 900000,
  "currency": "VND",
  "status": "PENDING"
}
```

---

## PaymentStatusResponse

```json
{
  "id": 100,
  "paymentReference": "PAY-20260519-ABC123",
  "provider": "VNPAY",
  "status": "SUCCESS",
  "originalAmount": 1000000,
  "discountAmount": 100000,
  "finalAmount": 900000,
  "paidAt": "",
  "createdAt": ""
}
```

---

## RefundPaymentRequest

```json
{
  "paymentReference": "PAY-123",
  "reason": "Manual refund"
}
```

Validation:

```text
paymentReference required
reason required
max 1000
```

---

# SUBSCRIPTION DTOs

## SubscriptionResponse

```json
{
  "id": 50,
  "status": "ACTIVE",
  "package": {
    "id": 2,
    "name": "Pro Landlord",
    "servicePlanId": 2,
    "servicePlanName": "Pro"
  },
  "startedAt": "",
  "expiresAt": "",
  "remainingPostQuota": 10,
  "remainingBoostQuota": 2
}
```

---

## SubscriptionHistoryResponse

```json
{
  "id": 49,
  "packageName": "Starter",
  "status": "EXPIRED",
  "startedAt": "",
  "expiresAt": ""
}
```

---

# PACKAGE DTOs

Packages are commercial products.

Each package references one service plan.

## PackageResponse

```json
{
  "id": 2,
  "servicePlanId": 2,
  "servicePlanName": "Pro",
  "name": "Pro Landlord",
  "description": "Higher posting quota",
  "price": 1000000,
  "durationDays": 30,
  "active": true
}
```

---

## CreatePackageRequest

```json
{
  "servicePlanId": 2,
  "name": "Pro Landlord",
  "description": "Premium plan",
  "price": 1000000,
  "durationDays": 30
}
```

Validation:

```text
name required
max 150

description optional
max 2000

price >= 0
durationDays > 0
servicePlanId required
servicePlanId positive integer
```

---

## UpdatePackageRequest

```json
{
  "price": 1200000,
  "durationDays": 60
}
```

Partial update.

---

# SERVICE PLAN DTOs

Service plans are technical entitlement templates.

## ServicePlanResponse

```json
{
  "id": 2,
  "code": "PRO",
  "name": "Pro",
  "description": "Professional landlord entitlement set",
  "listingQuota": 50,
  "boostQuota": 10,
  "analyticsEnabled": true,
  "imageQuota": 100,
  "active": true
}
```

---

## CreateServicePlanRequest

```json
{
  "code": "PRO",
  "name": "Pro",
  "description": "Professional landlord entitlement set",
  "listingQuota": 50,
  "boostQuota": 10,
  "analyticsEnabled": true,
  "imageQuota": 100
}
```

Validation:

```text
code required
code unique
name required
listingQuota >= 0
boostQuota >= 0
imageQuota >= 0
```

---

# COUPON DTOs

## ValidateCouponRequest

```json
{
  "code": "WELCOME10",
  "packageId": 2
}
```

---

## ValidateCouponResponse

```json
{
  "valid": true,
  "discountType": "PERCENTAGE",
  "discountValue": 10,
  "discountAmount": 100000,
  "finalAmount": 900000
}
```

---

## CreateCouponRequest

```json
{
  "code": "WELCOME10",
  "discountType": "PERCENTAGE",
  "discountValue": 10,
  "maxRedemptions": 100,
  "expiresAt": "2026-12-31T23:59:59Z"
}
```

Validation:

```text
code required
uppercase normalized
unique

discountValue > 0
maxRedemptions >= 1
```

---

# FILE UPLOAD DTOs

## UploadImageResponse

```json
{
  "id": 500,
  "url": "https://cdn.roomhub.com/uploads/image.jpg",
  "fileName": "image.jpg",
  "mimeType": "image/jpeg",
  "sizeBytes": 523421,
  "uploadedAt": ""
}
```

---

# ADMIN USER DTOs

## AdminUserSummaryResponse

```json
{
  "id": 1,
  "fullName": "Nguyen Van Admin",
  "email": "admin@roomhub.com",
  "role": "ADMIN",
  "status": "ACTIVE",
  "createdAt": ""
}
```

---

## AdminUserDetailResponse

```json
{
  "id": 1,
  "fullName": "Nguyen Van Admin",
  "email": "admin@roomhub.com",
  "phoneNumber": "0900000000",
  "role": "ADMIN",
  "status": "ACTIVE",
  "lastLoginAt": "",
  "createdAt": "",
  "updatedAt": ""
}
```

---

# DASHBOARD DTOs

## AdminDashboardSummaryResponse

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

## AdminAnalyticsResponse

```json
{
  "revenueTrend": [],
  "subscriptionTrend": [],
  "bookingTrend": [],
  "reportTrend": []
}
```

---

## LandlordDashboardResponse

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

# AUDIT DTOs

## AuditLogResponse

```json
{
  "id": 10000,
  "actorUserId": 1,
  "actorEmail": "admin@roomhub.com",
  "action": "PAYMENT_REFUND",
  "entityType": "PAYMENT",
  "entityId": 100,
  "metadata": {},
  "createdAt": ""
}
```

---

# HEALTH DTOs

## HealthResponse

```json
{
  "status": "UP",
  "timestamp": ""
}
```

Production minimal version:

```json
{
  "status": "UP"
}
```

---

# ENUM CONTRACTS

## PaymentStatus

```text
PENDING
SUCCESS
FAILED
CANCELLED
REFUNDED
EXPIRED
```

---

## PaymentProvider

```text
VNPAY
MOMO
ZALOPAY
STRIPE
MANUAL
```

---

## SubscriptionStatus

```text
ACTIVE
EXPIRED
CANCELLED
PENDING
SUSPENDED
```

---

## DiscountType

```text
PERCENTAGE
FIXED_AMOUNT
```

---

## AuditEntityType

```text
USER
POST
BOOKING
PAYMENT
SUBSCRIPTION
COUPON
REPORT
ROOM
MOTEL
```

---

# DTO DESIGN RULES

Mandatory:

```text
request DTO != entity
response DTO != entity
no password hash exposure
no internal DB flags leakage
no refresh token in JSON
explicit enums only
strict validation
```

---

# NULLABILITY RULES

Contract must be explicit.

Nullable examples:

```text
avatarUrl
rejectionReason
paidAt (pending payment)
```

Non-null examples:

```text
id
status
createdAt
```

---

# DATE/TIME STANDARD

Use:

```text
ISO-8601 UTC
```

Example:

```text
2026-05-19T14:30:00Z
```

Never locale-specific datetime strings.

---

# MONEY STANDARD

Use:

```text
integer minor units OR explicit integer VND
```

For RoomHub:

```text
integer VND
```

Example:

```json
{
  "price": 3500000
}
```

Never float for money.

---

# DTO SOURCE OF TRUTH

This document governs:

```text
request contracts
response contracts
validation expectations
enum contracts
pagination schema
error schema
```

All backend DTOs and frontend TS types must comply.

---
