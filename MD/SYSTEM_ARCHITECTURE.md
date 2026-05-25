# RoomHub System Architecture

I want all UI labels, card titles, and inventory-related text to be displayed in Vietnamese, as this system is specifically designed for Vietnamese users.

Production-style architectural documentation for the RoomHub platform.

This document defines the technical architecture, system boundaries, module interactions, design principles, and engineering decisions for the RoomHub graduation project.

This file serves as a source of truth for:

- backend development
- frontend development
- AI coding assistants
- architecture consistency
- engineering decision alignment

---

# Architecture Philosophy

RoomHub is intentionally designed using production-inspired architecture rather than a simple academic CRUD structure.

Primary engineering goals:

- maintainability
- modularity
- scalability
- security
- clean separation of concerns
- predictable API contracts
- long-term extensibility

Architectural philosophy:

```text
simple where possible
strict where necessary
modular by default
business logic in service layer
security first
API contract consistency
```

---

# System Type

RoomHub is a:

```text
Full-stack web application
```

Architecture model:

```text
Frontend SPA + REST API Backend + Relational Database
```

System classification:

```text
multi-role rental management platform
```

Actors:

- tenant
- landlord
- administrator

---

# High-Level System Architecture

```text
┌──────────────────────────────┐
│          Frontend SPA        │
│   React / Next.js / Vite     │
└──────────────┬───────────────┘
               │
               │ HTTPS / JSON
               │
               ▼
┌──────────────────────────────┐
│      Spring Boot Backend     │
│       REST API Layer         │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│      Service Layer           │
│ Business Logic / Workflows   │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│      Repository Layer        │
│ Database Access / Queries    │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│         MySQL Database       │
└──────────────────────────────┘
```

---

# Architectural Layers

RoomHub backend follows layered architecture.

---

## Presentation Layer

Purpose:

HTTP interaction boundary.

Components:

- REST controllers
- request mapping
- response serialization
- DTO validation entry point

Responsibilities:

- receive HTTP requests
- deserialize JSON
- trigger validation
- call service layer
- return standardized API response

Must NOT:

- contain business logic
- directly query database
- perform transaction orchestration

---

## Security Layer

Purpose:

request protection and access control.

Components:

- JWT authentication filter
- security config
- authentication entry point
- authorization enforcement

Responsibilities:

- validate access tokens
- authenticate users
- enforce protected routes
- reject unauthorized requests

Security boundary occurs before business logic execution.

---

## Service Layer

Purpose:

business orchestration.

This is the most important backend layer.

Responsibilities:

- business rules
- workflows
- ownership validation
- state transitions
- transaction boundaries
- coordination between repositories

Examples:

Booking approval:

```text
validate landlord ownership
validate room availability
validate booking status
update booking
update room
write audit log
commit transaction
```

Controllers must never do this.

---

## Repository Layer

Purpose:

data persistence abstraction.

Responsibilities:

- CRUD
- filtering
- pagination
- custom queries
- optimized fetch operations

Must NOT:

- contain business rules
- contain security logic
- perform workflow orchestration

---

## Database Layer

Purpose:

persistent storage.

Responsibilities:

- relational consistency
- foreign key enforcement
- indexing
- transactional durability

Business logic should not live here.

No trigger-heavy architecture.

---

# Request Lifecycle

Standard authenticated request lifecycle:

```text
Frontend request
    ↓
HTTP request enters backend
    ↓
Spring Security filter chain
    ↓
JWT validation
    ↓
authentication context creation
    ↓
controller endpoint
    ↓
DTO validation
    ↓
service layer
    ↓
repository queries
    ↓
database execution
    ↓
entity mapping
    ↓
API response wrapper
    ↓
JSON response
```

---

# Authentication Architecture

Authentication model:

```text
JWT Access Token + Refresh Token
```

Reasoning:

Access token:

- stateless
- lightweight
- scalable
- fast validation

Refresh token:

- persistent session continuity
- safer reauthentication
- explicit revocation support

---

## Login Flow

```text
User login request
    ↓
validate credentials
    ↓
verify password hash
    ↓
generate access token
    ↓
generate refresh token
    ↓
persist refresh token
    ↓
return authentication response
```

---

## Access Request Flow

```text
frontend sends access token
    ↓
JWT filter intercepts request
    ↓
validate token signature
    ↓
validate expiration
    ↓
extract user identity
    ↓
load user context
    ↓
authorize endpoint access
```

---

## Refresh Flow

```text
refresh request
    ↓
validate refresh token
    ↓
check token exists in database
    ↓
check not revoked
    ↓
issue new access token
```

---

## Logout Flow

```text
logout request
    ↓
invalidate refresh token
    ↓
session terminated
```

---

# Authorization Model

Authorization strategy:

```text
RBAC (Role-Based Access Control)
```

Core roles:

- ADMIN
- LANDLORD
- TENANT
# Role-Based Access Control (RBAC)

RoomHub uses RBAC for authorization enforcement.

---

## TENANT

Allowed:

- register
- login
- logout
- refresh session
- manage own profile
- browse public listings
- search rental properties
- save favorite listings
- create booking requests
- cancel own booking
- review completed rentals
- report abusive content
- read blog content

Restricted:

- cannot create motels
- cannot manage rooms
- cannot create rental listings
- cannot approve bookings
- cannot access admin modules
- cannot use premium landlord features

---

## LANDLORD

Allowed:

- register
- login
- logout
- manage own profile
- create motels
- update owned motels
- delete owned motels
- create rooms
- manage owned rooms
- create listings
- edit owned listings
- approve/reject booking requests
- purchase subscriptions
- use premium listing features
- view landlord analytics

Restricted:

- cannot manage other landlords' properties
- cannot manage platform governance
- cannot moderate unrelated content

Critical rule:

Ownership validation is mandatory.

Example:

Incorrect:

```text
LANDLORD updates any motel by ID
```

Correct:

```text
LANDLORD updates only motel.owner_id == authenticated_user.id
```

---

## ADMIN

Allowed:

- manage users
- lock/unlock accounts
- moderate listings
- moderate reviews
- manage reports
- manage coupons
- manage subscriptions
- manage service plans
- manage system features
- view analytics
- platform governance

Restricted:

- admin actions should be auditable
- destructive actions should be controlled

---

# Feature Permission Model

RoomHub supports feature-level access governance.

Architecture:

```text
roles
system_features
role_feature_permissions
```

Purpose:

dynamic access control.

Example:

```text
LANDLORD
→ POST_BOOST
→ allowed
```

```text
TENANT
→ POST_BOOST
→ denied
```

This allows future scalability without hardcoding every permission.

---

# Backend Module Architecture

Backend is organized by business domain.

Structure:

```text
src/main/java/com/chinh/roomhub/
```

Modules:

```text
common/
config/
exception/
security/

auth/
users/
motels/
rooms/
posts/
bookings/
reviews/
blogs/
payments/
serviceplans/
packages/
subscriptions/
admin/
utils/
```

---

# Shared Core Modules

## common

Purpose:

shared reusable components.

Examples:

- ApiResponse
- constants
- enums
- shared DTOs

---

## config

Purpose:

framework configuration.

Examples:

- OpenAPI config
- Security config
- CORS config
- Jackson config
- JPA config

---

## exception

Purpose:

centralized error handling.

Examples:

- GlobalExceptionHandler
- custom exceptions
- domain exception mapping

---

## security

Purpose:

authentication/authorization infrastructure.

Examples:

- JWT filter
- token provider
- user principal
- authentication entry point
- security utilities

---

## utils

Purpose:

helper utilities.

Examples:

- date formatting
- string normalization
- file helpers
- token helpers

Utilities must remain generic.

No business logic here.

---

# Feature Module Design

Every business module should follow consistent structure.

Example:

```text
auth/
├── controller
├── service
├── repository
├── dto
├── entity
├── mapper
```

Optional:

```text
validator
specification
converter
event
```

---

# Why Feature-Based Architecture

Alternative bad architecture:

```text
controllers/
services/
repositories/
entities/
```

Problem:

everything becomes mixed.

Example:

```text
50 unrelated controllers together
60 services together
```

Hard to maintain.

Feature-based approach:

```text
auth isolated
users isolated
motels isolated
bookings isolated
```

Benefits:

- modularity
- easier onboarding
- domain ownership clarity
- cleaner AI generation
- scalable refactoring
- simpler testing

---

# Frontend Architecture

Frontend is designed as API-driven SPA architecture.

High-level model:

```text
UI Layer
    ↓
State Layer
    ↓
API Client Layer
    ↓
REST Backend
```

Frontend responsibilities:

- user interaction
- form validation
- route handling
- token storage
- API communication
- optimistic UX behaviors

Frontend must NOT:

- contain backend business rules
- trust authorization assumptions
- expose sensitive secrets

---

# Frontend Module Boundaries

Suggested frontend modules:

```text
auth/
users/
motels/
rooms/
posts/
bookings/
reviews/
blogs/
admin/
shared/
```

Shared frontend concerns:

- UI components
- layouts
- hooks
- API client
- auth context
- route guards

---

# API Communication Model

Communication protocol:

```text
HTTPS + JSON REST
```

Pattern:

```text
frontend request
→ Authorization header
→ backend validates token
→ backend executes business logic
→ standardized JSON response
```

Headers:

```http
Authorization: Bearer <access_token>
Content-Type: application/json
```

---

# REST API Versioning

Convention:

```text
/api/v1/
```

Examples:

```text
/api/v1/auth/login
/api/v1/users/me
/api/v1/motels
```

Reason:

future compatibility.

Example:

```text
/api/v2/
```

without breaking frontend clients.

---

# API Design Philosophy

RoomHub follows resource-based REST naming.

Correct:

```text
GET /motels
GET /motels/{id}
POST /motels
PUT /motels/{id}
DELETE /motels/{id}
```

Avoid:

```text
/getAllMotels
/createMotel
/deleteRoomById
```

REST should be resource-oriented.

---
# Database Architecture

RoomHub uses a relational database architecture.

Engine:

```text
MySQL 8+
```

Architecture style:

```text
normalized relational domain model
```

Primary goals:

- data integrity
- consistency
- predictable relationships
- scalable querying
- transactional correctness

---

## Database Domains

Authentication domain:

```text
users
roles
refresh_tokens
activity_logs
```

Rental domain:

```text
motels
rooms
room_images
posts
post_images
favorites
bookings
reviews
```

Content domain:

```text
blog_posts
```

Monetization domain:

```text
service_plans
service_plan_features
packages
subscriptions
subscription_orders
payment_transactions
coupons
coupon_usages
```

Monetization naming rule:

```text
ServicePlan = technical entitlement template
Package = commercial product sold to landlords
Subscription = landlord ownership record after purchase
```

Governance domain:

```text
reports
system_features
role_feature_permissions
```

---

# Relational Design Philosophy

Database responsibilities:

- persistence
- referential integrity
- indexing
- transactional durability

Database should NOT own business workflows.

Bad example:

```text
trigger auto-approves bookings
trigger auto-creates subscription
```

Correct:

```text
BookingService
SubscriptionService
PaymentService
```

Application layer owns business logic.

Reason:

- easier debugging
- better testing
- cleaner architecture
- maintainability
- safer refactoring

---

# Transaction Strategy

Critical workflows require transaction boundaries.

Examples:

---

## Booking Confirmation

Atomic operations:

```text
validate booking
validate room
validate ownership
update booking status
update room availability
write activity log
commit
```

If failure occurs:

```text
rollback
```

---

## Subscription Purchase

Atomic operations:

```text
create payment transaction
validate payment
create subscription
consume coupon
write order record
commit
```

---

## Review Submission

Atomic validation:

```text
verify completed booking
verify tenant identity
ensure review uniqueness
save review
commit
```

---

# Indexing Strategy

Indexes are required for production-style performance.

Examples:

Users:

```text
email
role_id
status
```

Motels:

```text
owner_id
district
city
status
```

Rooms:

```text
motel_id
status
price
capacity
```

Posts:

```text
room_id
status
is_boosted
published_at
```

Bookings:

```text
tenant_id
room_id
status
created_at
```

Reviews:

```text
room_id
tenant_id
rating
```

Payments:

```text
user_id
status
transaction_reference
```

Subscriptions:

```text
user_id
plan_id
status
expires_at
```

Purpose:

fast filtering and scalable search.

---

# Search Architecture

Search strategy for RoomHub:

Phase 1:

database filtering + indexed queries

Example:

```text
price range
district
capacity
availability
keyword
```

Implementation:

repository query layer.

---

Phase 2 (future scalability):

optional external search engine:

```text
Elasticsearch / Meilisearch
```

Only if project scale demands.

For graduation project:

optimized MySQL filtering is sufficient.

---

# Caching Strategy

Initial strategy:

```text
no distributed cache
```

Reason:

keep architecture manageable.

Future optimization:

```text
Redis
```

Use cases:

- hot listing cache
- popular search cache
- feature config cache
- token blacklist cache

---

# Security Architecture

Security is a first-class architecture concern.

---

## Authentication

Model:

```text
JWT + Refresh Token
```

Access token:

- short-lived
- stateless
- sent with API requests

Refresh token:

- persisted
- revocable
- session continuity

---

## Password Security

Passwords must NEVER be stored in plaintext.

Algorithm:

```text
BCrypt
```

Flow:

```text
register
→ hash password
→ store hash
```

Login:

```text
compare raw password with stored hash
```

---

## Authorization

Strategy:

```text
RBAC
```

Enforcement layers:

- endpoint access
- service ownership validation
- feature permission checks

---

## Input Validation

Protection via:

- DTO validation
- bean validation
- request sanitization
- file validation

---

## ORM Safety

SQL injection mitigation:

```text
Spring Data JPA
parameterized ORM queries
```

Avoid:

```text
raw concatenated SQL strings
```

---

## CORS

Restrict frontend origins.

Development:

```text
localhost frontend
```

Production:

explicit trusted domains only.

---

## Rate Limiting

Planned for hardening phase.

Protect:

- login endpoint
- refresh endpoint
- payment endpoints
- public search abuse

---

# File Upload Architecture

Supported uploads:

- user avatars
- motel images
- room images
- post images

Phase 1:

```text
local storage
```

Production-ready evolution:

```text
Cloudinary / S3
```

Architecture:

```text
frontend upload
→ validation
→ storage service
→ metadata persistence
```

Validation:

- MIME type
- file size
- extension whitelist

---

# Deployment Topology

Development:

```text
Frontend localhost
Backend localhost
MySQL localhost
```

---

Staging:

```text
Frontend hosting
Backend hosting
Managed MySQL
```

---

Production-style:

```text
Internet
   ↓
Reverse Proxy (Nginx)
   ↓
Spring Boot API
   ↓
MySQL
```

Optional:

```text
Redis
Cloudinary
Monitoring
```

---

# Scalability Philosophy

RoomHub is not over-engineered initially.

Strategy:

build clean first.

Then optimize.

Scalable design principles:

- modular feature boundaries
- stateless API
- DTO contracts
- repository abstraction
- transactional service layer
- index-aware database design

---

# Engineering Decision Summary

Why REST:

- simpler frontend integration
- predictable contracts
- faster graduation implementation
- widely understood
- Swagger-friendly

Why Spring Boot:

- production maturity
- strong ecosystem
- security integration
- JPA support
- clean architecture fit

Why MySQL:

- relational consistency
- excellent tooling
- easy deployment
- ideal for RoomHub domain

Why JWT:

- stateless auth
- scalable
- frontend friendly

Why modular architecture:

- maintainability
- feature isolation
- clean AI collaboration
- easier testing

---

# Architecture Source of Truth

All contributors (human or AI) must follow this architecture.

Must NOT:

- move business logic into controllers
- bypass service layer
- expose entities directly
- hardcode permissions inconsistently
- create conflicting folder structures
- violate API response standards

This document is the architectural contract for RoomHub.

---
