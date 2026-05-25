# RoomHub API Contract

I want all UI labels, card titles, and inventory-related text to be displayed in Vietnamese, as this system is specifically designed for Vietnamese users.

Production-style API contract documentation for the RoomHub platform.

This document defines:

- REST endpoint conventions
- request/response contracts
- authentication rules
- status code standards
- pagination schema
- error response schema
- validation expectations

This file is the API source of truth for:

- backend engineers
- frontend engineers
- Postman collections
- Swagger consistency
- AI coding assistants

---

# API Philosophy

RoomHub follows strict REST API design.

Principles:

- predictable endpoints
- resource-oriented naming
- consistent response schema
- strict validation
- explicit authentication
- role-safe access control
- frontend-friendly contracts

API should feel production-grade.

---

# Base API Configuration

Base URL:

```text
/api/v1
```

Examples:

```text
/api/v1/auth/login
/api/v1/users/me
/api/v1/motels
/api/v1/bookings
```

---

# Content Type

Default request:

```http
Content-Type: application/json
```

Response:

```http
application/json
```

File upload:

```http
multipart/form-data
```

---

# Authentication Header

Protected endpoints require:

```http
Authorization: Bearer <access_token>
```

Example:

```http
Authorization: Bearer eyJhbGciOi...
```

Missing token:

```http
401 Unauthorized
```

Invalid token:

```http
401 Unauthorized
```

Expired token:

```http
401 Unauthorized
```

---

# Standard API Response Format

ALL successful API responses must follow:

```json
{
  "success": true,
  "message": "Operation successful",
  "data": {}
}
```

---

## Success Without Payload

Example:

```json
{
  "success": true,
  "message": "Logout successful",
  "data": null
}
```

---

## Success With Payload

Example:

```json
{
  "success": true,
  "message": "Profile retrieved successfully",
  "data": {
    "id": 1,
    "email": "user@example.com"
  }
}
```

---

# Standard Error Response Format

ALL failed responses must follow:

```json
{
  "success": false,
  "message": "Validation failed",
  "errors": {}
}
```

---

## Validation Error Example

```json
{
  "success": false,
  "message": "Validation failed",
  "errors": {
    "email": "Email is required",
    "password": "Password must be at least 8 characters"
  }
}
```

---

## Unauthorized Example

```json
{
  "success": false,
  "message": "Unauthorized",
  "errors": null
}
```

---

## Forbidden Example

```json
{
  "success": false,
  "message": "Access denied",
  "errors": null
}
```

---

## Not Found Example

```json
{
  "success": false,
  "message": "Resource not found",
  "errors": null
}
```

---

## Server Error Example

```json
{
  "success": false,
  "message": "Internal server error",
  "errors": null
}
```

---

# HTTP Status Code Standards

RoomHub uses proper HTTP semantics.

---

## 200 OK

Use when:

successful read/update.

Examples:

```text
GET profile
GET listings
PUT profile update
```

---

## 201 Created

Use when:

new resource created.

Examples:

```text
register
create motel
create booking
create review
```

---

## 204 No Content

Optional for delete operations.

Example:

```text
delete favorite
```

For consistency, returning ApiResponse is acceptable instead.

---

## 400 Bad Request

Use when:

client request invalid.

Examples:

- validation failure
- malformed input
- invalid business request

---

## 401 Unauthorized

Use when:

authentication missing or invalid.

Examples:

- no token
- expired token
- invalid JWT

---

## 403 Forbidden

Use when:

authenticated but not allowed.

Examples:

- tenant accessing landlord endpoint
- ownership violation
- admin-only route access

---

## 404 Not Found

Use when:

resource missing.

Examples:

- room not found
- motel not found
- booking not found

---

## 409 Conflict

Use when:

state conflict / duplicate constraints.

Examples:

- duplicate email
- duplicate favorite
- booking conflict
- duplicate review

---

## 422 Unprocessable Entity

Optional.

Use when:

business rule violation.

Examples:

```text
subscription expired
boost quota exhausted
coupon invalid
```

---

## 500 Internal Server Error

Unexpected failures only.

---

# REST Naming Convention

Correct:

```text
GET /motels
GET /motels/{id}
POST /motels
PUT /motels/{id}
DELETE /motels/{id}
```

Incorrect:

```text
/getAllMotels
/createMotel
/deleteMotelById
```

Rules:

- nouns only
- plural resources
- verbs via HTTP methods

---

# Pagination Contract

Paginated responses:

```json
{
  "success": true,
  "message": "Motels retrieved successfully",
  "data": {
    "items": [],
    "pagination": {
      "page": 1,
      "size": 10,
      "totalItems": 125,
      "totalPages": 13,
      "hasNext": true,
      "hasPrevious": false
    }
  }
}
```

---

# Sorting Contract

Query params:

```http
?sort=createdAt,desc
```

Examples:

```http
?sort=price,asc
?sort=publishedAt,desc
```

---

# Filtering Contract

Examples:

```http
?city=hanoi
?district=hoang-mai
?minPrice=1000000
?maxPrice=5000000
?status=AVAILABLE
```

Combined:

```http
/api/v1/search?city=hanoi&minPrice=1000000&maxPrice=5000000
```

---

# Date Format Standard

Use:

```text
ISO 8601
```

Example:

```json
"createdAt": "2026-06-01T10:30:00Z"
```

Never inconsistent custom formats.

---

# ID Strategy

Primary IDs:

recommended:

```text
BIGINT AUTO_INCREMENT
```

API exposure:

```json
"id": 123
```

Future upgrade possible:

UUID.

For graduation scope:

BIGINT is practical.

---
# Authentication API

Authentication endpoints manage account access and session lifecycle.

---

## Register

Endpoint:

```http
POST /api/v1/auth/register
```

Access:

```text
PUBLIC
```

Purpose:

Create new tenant or landlord account.

---

### Request Body

```json
{
  "fullName": "Nguyen Van A",
  "email": "vana@example.com",
  "password": "StrongPassword@123",
  "role": "TENANT"
}
```

---

### Validation

fullName:

- required
- min length
- max length

email:

- required
- valid email
- unique

password:

- required
- minimum 8 chars
- uppercase
- lowercase
- number
- special character

role:

allowed:

```text
TENANT
LANDLORD
```

Forbidden:

```text
ADMIN
```

---

### Success Response

```http
201 Created
```

```json
{
  "success": true,
  "message": "Registration successful",
  "data": {
    "id": 1,
    "email": "vana@example.com",
    "role": "TENANT"
  }
}
```

---

### Failure Cases

Duplicate email:

```http
409 Conflict
```

Validation failure:

```http
400 Bad Request
```

---

# Login

Endpoint:

```http
POST /api/v1/auth/login
```

Access:

```text
PUBLIC
```

---

### Request Body

```json
{
  "email": "vana@example.com",
  "password": "StrongPassword@123"
}
```

---

### Business Rules

Must validate:

- user exists
- password matches
- account active
- account not locked

Security:

generic failure message.

Do NOT expose:

```text
email exists
wrong password
```

---

### Success Response

```http
200 OK
```

```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": {
      "id": 1,
      "fullName": "Nguyen Van A",
      "email": "vana@example.com",
      "role": "TENANT"
    },
    "accessToken": "jwt_access_token",
    "refreshToken": "jwt_refresh_token"
  }
}
```

---

### Failure

```http
401 Unauthorized
```

---

# Refresh Token

Endpoint:

```http
POST /api/v1/auth/refresh
```

Access:

```text
PUBLIC
```

---

### Request Body

```json
{
  "refreshToken": "jwt_refresh_token"
}
```

---

### Business Rules

Must validate:

- token exists
- token not revoked
- token not expired
- token belongs to active user

---

### Success Response

```json
{
  "success": true,
  "message": "Token refreshed successfully",
  "data": {
    "accessToken": "new_access_token",
    "refreshToken": "new_refresh_token"
  }
}
```

---

### Failure

```http
401 Unauthorized
```

---

# Logout

Endpoint:

```http
POST /api/v1/auth/logout
```

Access:

```text
AUTHENTICATED
```

---

### Request Body

```json
{
  "refreshToken": "jwt_refresh_token"
}
```

---

### Business Rules

Must:

- invalidate refresh token
- revoke session continuation

---

### Success

```json
{
  "success": true,
  "message": "Logout successful",
  "data": null
}
```

---

# User API

---

## Get Current Profile

Endpoint:

```http
GET /api/v1/users/me
```

Access:

```text
AUTHENTICATED
```

---

### Success

```json
{
  "success": true,
  "message": "Profile retrieved successfully",
  "data": {
    "id": 1,
    "fullName": "Nguyen Van A",
    "email": "vana@example.com",
    "phone": "0123456789",
    "role": "TENANT",
    "status": "ACTIVE",
    "avatarUrl": "https://..."
  }
}
```

---

# Update Current Profile

Endpoint:

```http
PUT /api/v1/users/me
```

Access:

```text
AUTHENTICATED
```

---

### Request Body

```json
{
  "fullName": "Updated Name",
  "phone": "0988888888",
  "avatarUrl": "https://..."
}
```

---

### Rules

Cannot update:

- role
- account status
- email directly (unless dedicated flow)

---

### Success

```http
200 OK
```

---

# Change Password

Endpoint:

```http
PUT /api/v1/users/me/password
```

Access:

```text
AUTHENTICATED
```

---

### Request

```json
{
  "currentPassword": "OldPass@123",
  "newPassword": "NewPass@123"
}
```

---

### Rules

Must validate:

- current password correct
- new password strong
- new password different

---

# Admin User Management API

---

## Get All Users

Endpoint:

```http
GET /api/v1/admin/users
```

Access:

```text
ADMIN
```

---

### Query Params

```http
?page=1
&size=20
&status=ACTIVE
&role=TENANT
```

---

### Success

Paginated response.

---

## Lock User

Endpoint:

```http
PATCH /api/v1/admin/users/{id}/lock
```

Access:

```text
ADMIN
```

---

## Unlock User

Endpoint:

```http
PATCH /api/v1/admin/users/{id}/unlock
```

Access:

```text
ADMIN
```

---

## Suspend User

Endpoint:

```http
PATCH /api/v1/admin/users/{id}/suspend
```

Access:

```text
ADMIN
```

---

# Motel API

---

## Create Motel

Endpoint:

```http
POST /api/v1/motels
```

Access:

```text
LANDLORD
```

---

### Request

```json
{
  "name": "Happy Motel",
  "address": "123 Street",
  "city": "Hanoi",
  "district": "Hoang Mai",
  "ward": "Dinh Cong",
  "description": "Affordable rooms",
  "contactPhone": "0123456789"
}
```

---

### Validation

Required:

- name
- address
- city
- district
- contactPhone

---

### Success

```http
201 Created
```

```json
{
  "success": true,
  "message": "Motel created successfully",
  "data": {
    "id": 10
  }
}
```

---

# Get Motels

Endpoint:

```http
GET /api/v1/motels
```

Access:

```text
PUBLIC or AUTHENTICATED (business choice)
```

Query:

```http
?page=1
&size=10
&city=hanoi
&district=hoang-mai
```

---

# Get Motel Detail

Endpoint:

```http
GET /api/v1/motels/{id}
```

---

# Update Motel

Endpoint:

```http
PUT /api/v1/motels/{id}
```

Access:

```text
LANDLORD OWNER
```

---

### Rules

Must validate:

```text
motel.owner_id == authenticated landlord
```

---

# Delete Motel

Endpoint:

```http
DELETE /api/v1/motels/{id}
```

Soft delete preferred.

---

# Room API

---

## Create Room

Endpoint:

```http
POST /api/v1/rooms
```

Access:

```text
LANDLORD
```

---

### Request

```json
{
  "motelId": 10,
  "name": "Room A101",
  "price": 2500000,
  "capacity": 2,
  "area": 20,
  "description": "Nice room"
}
```

---

### Validation

price:

```text
> 0
```

capacity:

```text
>= 1
```

area:

```text
> 0
```

Ownership:

```text
landlord owns motel
```

---

# Update Room

Endpoint:

```http
PUT /api/v1/rooms/{id}
```

---

# Delete Room

Endpoint:

```http
DELETE /api/v1/rooms/{id}
```

---

# Update Room Status

Endpoint:

```http
PATCH /api/v1/rooms/{id}/status
```

---

### Request

```json
{
  "status": "AVAILABLE"
}
```

Allowed:

```text
AVAILABLE
INACTIVE
```

System-controlled:

```text
RENTED
PENDING
```

not manually arbitrary.

---

# Get Rooms

Endpoint:

```http
GET /api/v1/rooms
```

Supports:

- pagination
- filtering
- sorting

---
# Post / Listing API

Posts are public rental listings.

---

## Create Post

Endpoint:

```http
POST /api/v1/posts
```

Access:

```text
LANDLORD
```

---

### Request Body

```json
{
  "roomId": 12,
  "title": "Affordable room near university",
  "description": "Clean room with air conditioner and wifi included.",
  "price": 2500000
}
```

---

### Validation

Must validate:

- room exists
- landlord owns room
- room active
- room not deleted
- title required
- description required
- price positive

---

### Business Logic

Default status:

```text
PENDING_APPROVAL
```

Public visibility:

```text
NOT visible yet
```

Admin moderation required.

---

### Success Response

```http
201 Created
```

```json
{
  "success": true,
  "message": "Post created successfully",
  "data": {
    "id": 101,
    "status": "PENDING_APPROVAL"
  }
}
```

---

# Get Public Posts

Endpoint:

```http
GET /api/v1/posts
```

Access:

```text
PUBLIC
```

---

### Query Params

```http
?page=1
&size=10
&sort=publishedAt,desc
&city=hanoi
&district=hoang-mai
&minPrice=1000000
&maxPrice=5000000
```

---

### Response

Paginated response.

Only return:

```text
APPROVED
```

posts.

---

# Get Post Detail

Endpoint:

```http
GET /api/v1/posts/{id}
```

Access:

```text
PUBLIC
```

---

### Rules

Public users may only see:

```text
APPROVED
```

Owner may see own draft/pending posts.

Admin may see all.

---

# Update Post

Endpoint:

```http
PUT /api/v1/posts/{id}
```

Access:

```text
LANDLORD OWNER
```

---

### Rules

Must validate:

```text
post.owner_id == authenticated user
```

Editing approved post may trigger:

```text
PENDING_APPROVAL
```

again if moderation policy enabled.

---

# Delete Post

Endpoint:

```http
DELETE /api/v1/posts/{id}
```

Access:

```text
LANDLORD OWNER
```

Soft delete preferred.

---

# Boost Post

Endpoint:

```http
POST /api/v1/posts/{id}/boost
```

Access:

```text
LANDLORD
```

---

### Business Rules

Must validate:

- ownership
- active subscription
- boost quota available

Failure:

```http
422 Unprocessable Entity
```

---

### Success

```json
{
  "success": true,
  "message": "Post boosted successfully",
  "data": null
}
```

---

# Favorites API

Favorites are tenant-only saved listings.

---

## Add Favorite

Endpoint:

```http
POST /api/v1/favorites
```

Access:

```text
TENANT
```

---

### Request

```json
{
  "postId": 100
}
```

---

### Rules

Prevent duplicates.

Constraint:

```text
tenant_id + post_id unique
```

---

# Get Favorites

Endpoint:

```http
GET /api/v1/favorites
```

Access:

```text
TENANT
```

---

# Remove Favorite

Endpoint:

```http
DELETE /api/v1/favorites/{postId}
```

Access:

```text
TENANT
```

---

# Booking API

Booking is workflow-driven.

---

## Create Booking

Endpoint:

```http
POST /api/v1/bookings
```

Access:

```text
TENANT
```

---

### Request

```json
{
  "roomId": 12,
  "preferredDate": "2026-07-01T09:00:00Z",
  "message": "I would like to visit this room."
}
```

---

### Validation

Must validate:

- tenant authenticated
- room exists
- room available
- room active
- tenant not duplicate booking

---

### Success

```http
201 Created
```

```json
{
  "success": true,
  "message": "Booking request created successfully",
  "data": {
    "id": 300,
    "status": "PENDING"
  }
}
```

---

# Get My Bookings

Endpoint:

```http
GET /api/v1/bookings/me
```

Access:

```text
TENANT
```

---

# Get Landlord Bookings

Endpoint:

```http
GET /api/v1/bookings/landlord
```

Access:

```text
LANDLORD
```

---

### Purpose

Return booking requests for landlord-owned rooms.

---

# Approve Booking

Endpoint:

```http
PATCH /api/v1/bookings/{id}/approve
```

Access:

```text
LANDLORD OWNER
```

---

### Business Logic

Must validate:

- landlord owns room
- booking exists
- booking pending
- room still available

Atomic transaction:

```text
booking -> APPROVED
room -> RENTED
```

---

# Reject Booking

Endpoint:

```http
PATCH /api/v1/bookings/{id}/reject
```

Access:

```text
LANDLORD OWNER
```

---

# Cancel Booking

Endpoint:

```http
PATCH /api/v1/bookings/{id}/cancel
```

Access:

```text
TENANT OWNER
```

---

### Rules

Only own pending booking.

---

# Complete Booking

Endpoint:

```http
PATCH /api/v1/bookings/{id}/complete
```

Access:

```text
LANDLORD OWNER / ADMIN
```

---

### Purpose

Mark completed stay to enable review eligibility.

---

# Review API

Reviews are verified tenant feedback.

---

## Create Review

Endpoint:

```http
POST /api/v1/reviews
```

Access:

```text
TENANT
```

---

### Request

```json
{
  "bookingId": 300,
  "rating": 5,
  "content": "Very clean and comfortable room."
}
```

---

### Validation

Must validate:

- booking exists
- booking belongs to tenant
- booking completed
- no duplicate review
- rating 1–5

---

### Success

```http
201 Created
```

---

# Get Reviews

Endpoint:

```http
GET /api/v1/reviews
```

Access:

```text
PUBLIC
```

---

### Query Params

```http
?roomId=12
?motelId=8
```

Only visible reviews.

---

# Report Review

Endpoint:

```http
POST /api/v1/reviews/{id}/report
```

Access:

```text
AUTHENTICATED
```

---

# Blog API

Informational content.

---

## Get Blogs

Endpoint:

```http
GET /api/v1/blogs
```

Access:

```text
PUBLIC
```

---

Only:

```text
PUBLISHED
```

blogs.

---

## Get Blog Detail

Endpoint:

```http
GET /api/v1/blogs/{id}
```

---

## Create Blog

Endpoint:

```http
POST /api/v1/admin/blogs
```

Access:

```text
ADMIN
```

---

### Request

```json
{
  "title": "How to choose a rental room",
  "content": "Long article content..."
}
```

---

## Update Blog

Endpoint:

```http
PUT /api/v1/admin/blogs/{id}
```

Access:

```text
ADMIN
```

---

## Delete Blog

Endpoint:

```http
DELETE /api/v1/admin/blogs/{id}
```

Access:

```text
ADMIN
```

---
# Payment API

Payment APIs handle landlord premium purchases.

---

## Create Payment Order

Endpoint:

```http
POST /api/v1/payments/create
```

Access:

```text
LANDLORD
```

---

### Request Body

```json
{
  "packageId": 2,
  "couponCode": "WELCOME10"
}
```

---

### Validation

Must validate:

- authenticated landlord
- package exists
- package active
- coupon valid (if provided)
- coupon not expired
- coupon usage limit not exceeded

---

### Business Logic

Flow:

```text
select package
apply discount
create payment order
generate transaction reference
return payment redirect data
```

---

### Success Response

```json
{
  "success": true,
  "message": "Payment order created successfully",
  "data": {
    "paymentId": 501,
    "transactionRef": "TXN_20260601_ABC123",
    "amount": 450000,
    "paymentUrl": "https://sandbox-payment-provider..."
  }
}
```

---

# Payment Callback

Endpoint:

```http
POST /api/v1/payments/callback
```

Access:

```text
PUBLIC (provider callback)
```

---

### Purpose

Payment gateway callback notification.

Example:

VNPay / mock provider response.

---

### Business Logic

Must:

- validate signature
- validate transaction reference
- verify pending payment
- mark payment SUCCESS or FAILED
- activate subscription

Atomic transaction required.

---

# Payment History

Endpoint:

```http
GET /api/v1/payments/history
```

Access:

```text
LANDLORD
```

---

Response:

paginated payment records.

---

# Subscription API

Subscriptions unlock premium landlord features.

---

## Get My Subscription

Endpoint:

```http
GET /api/v1/subscriptions/me
```

Access:

```text
LANDLORD
```

---

### Response

```json
{
  "success": true,
  "message": "Subscription retrieved successfully",
  "data": {
    "packageName": "Pro",
    "servicePlanName": "Pro",
    "status": "ACTIVE",
    "startDate": "2026-06-01T00:00:00Z",
    "endDate": "2026-07-01T00:00:00Z",
    "boostQuotaRemaining": 8
  }
}
```

---

# Package API

Packages are commercial products sold to landlords.

They reference service plans for technical entitlements.

```text
Package -> ServicePlan
```

Service plans define quotas and feature access.

Packages define price, duration, public display, and sale availability.

Landlords purchase packages, not service plans directly.

---

## Get Public Packages

Endpoint:

```http
GET /api/v1/packages
```

Access:

```text
PUBLIC
```

---

Response:

```json
{
  "success": true,
  "message": "Packages retrieved successfully",
  "data": [
    {
      "id": 1,
      "name": "Basic",
      "servicePlanId": 1,
      "price": 199000
    }
  ]
}
```

---

# Admin Package API

---

## Create Package

Endpoint:

```http
POST /api/v1/admin/packages
```

Access:

```text
ADMIN
```

---

Request:

```json
{
  "name": "Pro",
  "servicePlanId": 2,
  "price": 499000,
  "durationDays": 30,
  "isActive": true
}
```

Validation:

- service plan exists
- service plan active
- price >= 0
- durationDays > 0

---

# Update Package

Endpoint:

```http
PUT /api/v1/admin/packages/{id}
```

Access:

```text
ADMIN
```

---

# Deactivate Package

Endpoint:

```http
PATCH /api/v1/admin/packages/{id}/deactivate
```

Access:

```text
ADMIN
```

Soft disable preferred.

---

# Service Plan API

Service plans are technical entitlement templates.

They are admin-managed and referenced by packages.

---

## Get Service Plans

Endpoint:

```http
GET /api/v1/admin/service-plans
```

Access:

```text
ADMIN
```

---

## Create Service Plan

Endpoint:

```http
POST /api/v1/admin/service-plans
```

Access:

```text
ADMIN
```

Request:

```json
{
  "code": "PRO",
  "name": "Pro",
  "listingQuota": 50,
  "boostQuota": 10,
  "analyticsEnabled": true,
  "imageQuota": 100
}
```

---

## Update Service Plan

Endpoint:

```http
PUT /api/v1/admin/service-plans/{id}
```

Access:

```text
ADMIN
```

Changing service plan entitlements affects future package purchases.

Existing active subscriptions should keep stored quota snapshots unless explicitly migrated.

---

# Coupon API

Coupons are controlled discounts.

---

## Validate Coupon

Endpoint:

```http
POST /api/v1/coupons/validate
```

Access:

```text
AUTHENTICATED
```

---

Request:

```json
{
  "code": "WELCOME10",
  "packageId": 2
}
```

---

Response:

```json
{
  "success": true,
  "message": "Coupon valid",
  "data": {
    "discountAmount": 50000
  }
}
```

---

# Admin Coupon API

---

## Create Coupon

Endpoint:

```http
POST /api/v1/admin/coupons
```

Access:

```text
ADMIN
```

---

## Update Coupon

Endpoint:

```http
PUT /api/v1/admin/coupons/{id}
```

---

## Disable Coupon

Endpoint:

```http
PATCH /api/v1/admin/coupons/{id}/disable
```

---

# Admin Moderation API

Platform governance endpoints.

---

## Approve Post

Endpoint:

```http
PATCH /api/v1/admin/posts/{id}/approve
```

Access:

```text
ADMIN
```

---

## Reject Post

Endpoint:

```http
PATCH /api/v1/admin/posts/{id}/reject
```

---

## Hide Review

Endpoint:

```http
PATCH /api/v1/admin/reviews/{id}/hide
```

---

## Remove Review

Endpoint:

```http
PATCH /api/v1/admin/reviews/{id}/remove
```

---

## Get Reports

Endpoint:

```http
GET /api/v1/admin/reports
```

---

## Resolve Report

Endpoint:

```http
PATCH /api/v1/admin/reports/{id}/resolve
```

---

# File Upload API

Media upload endpoints.

---

## Upload Single Image

Endpoint:

```http
POST /api/v1/uploads/image
```

Access:

```text
AUTHENTICATED
```

Content-Type:

```http
multipart/form-data
```

---

### Validation

Must validate:

- file exists
- file size limit
- MIME type allowed
- extension allowed

Allowed:

```text
jpg
jpeg
png
webp
```

Rejected:

```text
exe
js
php
svg (optional security choice)
```

---

### Response

```json
{
  "success": true,
  "message": "Upload successful",
  "data": {
    "url": "https://cdn.roomhub.com/uploads/image.jpg"
  }
}
```

---

# Health API

Infrastructure monitoring endpoint.

---

## Health Check

Endpoint:

```http
GET /api/v1/health
```

Access:

```text
PUBLIC
```

---

Response:

```json
{
  "success": true,
  "message": "Service healthy",
  "data": {
    "status": "UP",
    "timestamp": "2026-06-01T10:00:00Z"
  }
}
```

---

# Swagger / OpenAPI Rules

Documentation endpoints:

```text
/v3/api-docs
/swagger-ui
```

Public access:

allowed.

---

# Authorization Matrix

Quick access rules.

| Endpoint Category | Tenant | Landlord | Admin |
|--------|--------|----------|-------|
| Auth | YES | YES | internal |
| Profile | YES | YES | YES |
| Public search | YES | YES | YES |
| Favorites | YES | NO | NO |
| Booking create | YES | NO | NO |
| Booking manage | NO | YES | YES |
| Motel CRUD | NO | YES | YES (optional) |
| Room CRUD | NO | YES | YES (optional) |
| Post CRUD | NO | YES | YES |
| Reviews create | YES | NO | NO |
| Blogs public | YES | YES | YES |
| Blogs manage | NO | NO | YES |
| Packages public | YES | YES | YES |
| Payments | NO | YES | YES |
| Coupons admin | NO | NO | YES |

---

# Security Contract Rules

JWT:

```text
Access token required for protected APIs
```

Refresh token:

```text
revocable
database-backed
```

Password:

never returned.

Sensitive tokens:

never logged.

Admin APIs:

strict RBAC only.

Ownership validation mandatory.

---

# API Versioning Rule

Current:

```text
/api/v1
```

Future:

```text
/api/v2
```

Never break frontend silently.

---

# DTO Contract Rule

Entities must NEVER be returned directly.

Always use:

```text
DTO / Response DTO
```

Reason:

security
maintainability
schema control

---

# API Source of Truth

All backend and frontend implementation must follow this contract.

AI coding assistants must NOT invent conflicting endpoints or schemas.

This file governs:

- controllers
- request DTOs
- response DTOs
- frontend API services
- Swagger consistency
- Postman testing

---
