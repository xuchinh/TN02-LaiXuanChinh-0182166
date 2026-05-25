# RoomHub


I want all UI labels, card titles, and inventory-related text to be displayed in Vietnamese, as this system is specifically designed for Vietnamese users.

Production-style full-stack rental property management platform for landlords, tenants, and administrators.

RoomHub is a graduation project designed with real-world software engineering architecture principles, focusing on maintainability, scalability, modularity, and production-grade backend/frontend development practices.

---

# Project Overview

RoomHub is a web-based rental management ecosystem that allows:

- landlords to manage rental properties, rooms, listings, subscriptions, and tenant interactions
- tenants to search for rental listings, request bookings, leave reviews, and save favorite listings
- administrators to moderate the platform, manage users, control subscriptions, and enforce business rules

This project is intentionally designed beyond a basic CRUD graduation project.

The architecture follows production-inspired patterns used in enterprise applications.

---

# Core Business Domains

The system consists of multiple business domains:

- Authentication & Authorization
- User Management
- Rental Property Management
- Room Management
- Rental Listing Management
- Booking System
- Review & Rating System
- Blog / Content System
- Subscription & Premium Features
- Payment Management
- Coupon / Discount System
- Moderation & Reporting
- Role-Based Access Control
- Feature Toggle Management
- Analytics / Admin Dashboard

---

# System Actors

## 1. Tenant

A tenant is an end-user searching for rental accommodations.

Capabilities:

- register account
- login/logout
- refresh authentication session
- manage profile
- browse rental listings
- search with filters
- save favorite listings
- request room booking
- cancel booking
- review completed rental experience
- read blog content
- report abusive content

Business restrictions:

- cannot manage properties
- cannot boost listings
- cannot access admin features
- cannot review without completed booking

---

## 2. Landlord

A landlord manages rental inventory and listings.

Capabilities:

- register landlord account
- login/logout
- manage profile
- create rental properties
- manage rooms
- upload room images
- create rental listings
- edit/delete owned listings
- receive booking requests
- approve/reject bookings
- purchase premium subscriptions
- use premium listing features
- manage rental analytics
- respond to tenant interactions

Business restrictions:

- can only manage owned resources
- cannot access admin governance modules
- premium features require active subscription

---

## 3. Administrator

Platform governance role.

Capabilities:

- manage users
- lock/unlock accounts
- moderate listings
- moderate reviews
- manage reports
- manage subscriptions
- manage coupons
- manage feature toggles
- monitor payment transactions
- platform analytics
- role/permission governance

Business restrictions:

- admin actions must be auditable
- destructive actions should be controlled

---

# High-Level Architecture

RoomHub follows a separated frontend/backend architecture.

```text
Frontend SPA
    ↓
REST API
    ↓
Spring Boot Backend
    ↓
Service Layer
    ↓
Repository Layer
    ↓
MySQL Database
# Project Structure

Current backend structure:

```text
roomhub/
├── src/
│   ├── main/
│   │   ├── java/com/chinh/roomhub/
│   │   │   ├── RoomhubApplication.java
│   │   │   │
│   │   │   ├── common/
│   │   │   ├── config/
│   │   │   ├── exception/
│   │   │   ├── security/
│   │   │   ├── auth/
│   │   │   ├── users/
│   │   │   ├── motels/
│   │   │   ├── rooms/
│   │   │   ├── posts/
│   │   │   ├── bookings/
│   │   │   ├── reviews/
│   │   │   ├── blogs/
│   │   │   ├── payments/
│   │   │   ├── subscriptions/
│   │   │   ├── admin/
│   │   │   └── utils/
│   │   │
│   │   └── resources/
│   │       ├── application.properties
│   │       └── static/
│   │
│   └── test/
│
├── roomhub.sql
├── pom.xml
└── README.md
```

---

# Backend Architecture Philosophy

The backend follows modular feature-based architecture.

Each business domain is isolated into its own module.

Example:

```text
auth/
users/
motels/
rooms/
bookings/
payments/
serviceplans/
packages/
```

This approach improves:

- maintainability
- scalability
- testability
- code ownership clarity
- AI-assisted development consistency

---

# Layered Architecture

Each feature module should follow consistent layering.

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

Responsibilities:

## Controller Layer

Purpose:

HTTP boundary layer.

Responsibilities:

- receive requests
- validate DTO input
- call services
- return standardized API response
- never contain business logic

Example:

```java
POST /auth/login
→ AuthController
→ AuthService
→ return ApiResponse
```

---

## Service Layer

Purpose:

Business logic orchestration.

Responsibilities:

- implement business rules
- authorization ownership validation
- transactional workflows
- state transitions
- entity coordination

Example:

Booking confirmation:

```text
validate room availability
validate landlord ownership
create booking
update room status
write audit log
commit transaction
```

Controllers must never do this.

---

## Repository Layer

Purpose:

Database access abstraction.

Responsibilities:

- CRUD operations
- custom queries
- pagination queries
- filtering queries

No business rules here.

---

## DTO Layer

Purpose:

Boundary contracts.

Responsibilities:

- request validation
- response shaping
- API contract stability

DTO prevents exposing internal entity structure.

---

## Entity Layer

Purpose:

Database mapping.

Responsibilities:

- JPA entity definitions
- relationship mapping
- persistence structure

Entities are internal backend models.

Not frontend contracts.

---

## Mapper Layer

Purpose:

Transformation between layers.

Examples:

```text
Entity -> ResponseDTO
RequestDTO -> Entity
```

Benefits:

- separation of concerns
- easier refactoring
- safer API evolution

---

# Request Lifecycle

Standard request flow:

```text
Frontend Request
    ↓
Security Filter
    ↓
JWT Authentication Filter
    ↓
Controller
    ↓
DTO Validation
    ↓
Service Layer
    ↓
Repository Layer
    ↓
Database
    ↓
Response Mapping
    ↓
ApiResponse Wrapper
    ↓
Frontend Response
```

---

# API Response Standard

All APIs must return standardized responses.

Success:

```json
{
  "success": true,
  "message": "Login successful",
  "data": {},
  "timestamp": "2026-01-01T10:00:00Z"
}
```

Validation failure:

```json
{
  "success": false,
  "message": "Validation failed",
  "data": {
    "email": "Invalid email format",
    "password": "Password too short"
  },
  "timestamp": "2026-01-01T10:00:00Z"
}
```

Server error:

```json
{
  "success": false,
  "message": "Internal server error",
  "data": null,
  "timestamp": "2026-01-01T10:00:00Z"
}
```

Benefits:

- predictable frontend integration
- easier debugging
- consistent API contracts
- cleaner error handling

---

# Authentication Model

Authentication strategy:

```text
JWT Access Token + Refresh Token
```

Why:

Access token:

- short-lived
- secure
- stateless API authentication

Refresh token:

- session continuity
- safer re-authentication
- controlled session invalidation

Flow:

```text
Login
→ validate credentials
→ issue access token
→ issue refresh token
→ persist refresh token
→ return tokens
```

Refresh:

```text
refresh token request
→ validate token
→ check database
→ issue new access token
```

Logout:

```text
invalidate refresh token
```

---

# Authorization Model

Role-based access control (RBAC).

Roles:

- ADMIN
- LANDLORD
- TENANT

Examples:

ADMIN:

- manage users
- moderate reports
- feature governance

LANDLORD:

- manage owned motels
- manage rooms
- manage listings

TENANT:

- browse listings
- book rooms
- review rentals

Authorization rules enforced in:

- security filters
- service ownership validation
- feature access checks

---
# Database Architecture Overview

RoomHub uses a production-oriented relational database design.

Database engine:

```text
MySQL 8+
```

Design goals:

- normalized schema
- data integrity
- clear domain separation
- scalable indexing
- maintainable relationships
- transactional consistency

---

## Core Tables

Authentication & security:

```text
roles
users
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

Monetization:

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

Naming rule:

```text
ServicePlan = technical entitlement template
Package = commercial product sold to landlords
Subscription = landlord ownership record after purchase
```

Governance:

```text
reports
system_features
role_feature_permissions
```

---

## Database Philosophy

Business logic must NOT live in database triggers.

Incorrect approach:

```text
database trigger auto-updates room state
```

Correct approach:

```text
BookingService
→ validate booking
→ confirm booking
→ update room status
→ save transaction
→ commit
```

Reason:

Business logic belongs to application layer.

Benefits:

- easier debugging
- better maintainability
- clearer ownership
- testability
- production-grade architecture

---

# Core Feature Modules

RoomHub backend is divided into business modules.

---

## Auth Module

Responsibilities:

- register
- login
- logout
- refresh token
- password hashing
- token validation
- authentication lifecycle

Planned endpoints:

```text
POST /api/v1/auth/register
POST /api/v1/auth/login
POST /api/v1/auth/refresh
POST /api/v1/auth/logout
```

---

## User Module

Responsibilities:

- profile management
- account updates
- avatar updates
- account locking
- admin user management

Planned endpoints:

```text
GET /api/v1/users/me
PUT /api/v1/users/me
GET /api/v1/admin/users
PATCH /api/v1/admin/users/{id}/status
```

---

## Motel Module

Responsibilities:

- create motel
- edit motel
- delete motel
- ownership validation
- listing organization

Planned endpoints:

```text
POST /api/v1/motels
GET /api/v1/motels
GET /api/v1/motels/{id}
PUT /api/v1/motels/{id}
DELETE /api/v1/motels/{id}
```

---

## Room Module

Responsibilities:

- room CRUD
- capacity management
- pricing
- room availability
- image handling

Planned endpoints:

```text
POST /api/v1/rooms
GET /api/v1/rooms
PUT /api/v1/rooms/{id}
DELETE /api/v1/rooms/{id}
```

---

## Post Module

Responsibilities:

- rental listing creation
- public search listings
- listing moderation
- boost premium listings

Planned endpoints:

```text
POST /api/v1/posts
GET /api/v1/posts
GET /api/v1/posts/{id}
PUT /api/v1/posts/{id}
DELETE /api/v1/posts/{id}
```

---

## Booking Module

Responsibilities:

- booking request creation
- booking approval
- cancellation
- rental workflow state transition

Planned endpoints:

```text
POST /api/v1/bookings
PATCH /api/v1/bookings/{id}/approve
PATCH /api/v1/bookings/{id}/cancel
```

---

## Review Module

Responsibilities:

- tenant reviews
- ratings
- abuse reporting

Business rule:

Only verified tenants with completed booking may review.

---

## Blog Module

Responsibilities:

- educational content
- rental guidance
- landlord advice
- tenant knowledge sharing

---

## Payment Module

Responsibilities:

- subscription purchases
- payment transactions
- coupon application
- payment verification

---

## Admin Module

Responsibilities:

- moderation
- analytics
- user governance
- reports
- platform control

---

# Environment Configuration

Create:

```text
src/main/resources/application.properties
```

Example:

```properties
spring.application.name=roomhub

server.port=8080

spring.datasource.url=jdbc:mysql://localhost:3306/roomhub
spring.datasource.username=root
spring.datasource.password=your_password

spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

spring.jpa.hibernate.ddl-auto=validate
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true

application.security.jwt.secret=your_super_secret_key
application.security.jwt.access-token-expiration=900000
application.security.jwt.refresh-token-expiration=604800000

application.cors.allowed-origins=http://localhost:3000,http://localhost:5173
application.cors.allowed-methods=GET,POST,PUT,PATCH,DELETE,OPTIONS
application.cors.allowed-headers=*
application.cors.allow-credentials=true
```

---

# Local Development Setup

## Prerequisites

Install:

- Java 17
- Maven
- MySQL 8+
- IntelliJ IDEA
- Git
- Postman

Optional:

- Docker
- VS Code

---

## Clone Repository

```bash
git clone <repository-url>
cd roomhub
```

---

## Create Database

Run:

```sql
CREATE DATABASE roomhub;
```

Then import:

```text
roomhub.sql
```

---

## Configure Environment

Update:

```text
application.properties
```

Set:

- database credentials
- JWT secret
- CORS origins

---

## Run Backend

Using IntelliJ:

Run:

```text
RoomhubApplication.java
```

Or Maven:

```bash
./mvnw spring-boot:run
```

Windows:

```bash
mvnw.cmd spring-boot:run
```

---

# API Documentation

Swagger/OpenAPI:

```text
http://localhost:8080/swagger-ui/index.html
```

OpenAPI JSON:

```text
http://localhost:8080/v3/api-docs
```

Purpose:

- API inspection
- endpoint testing
- frontend integration
- DTO verification

---
# Development Workflow

RoomHub follows a structured development workflow similar to real-world production teams.

Development philosophy:

- modular implementation
- stable architecture first
- business rules before coding
- API contract consistency
- database-first domain design
- incremental feature delivery
- maintainability over shortcuts

---

## Development Phases

Planned implementation phases:

### Phase 1 — Foundation

Includes:

- Spring Boot initialization
- project structure setup
- MySQL connection
- OpenAPI / Swagger
- CORS configuration
- security baseline
- health check endpoint
- API response wrapper
- global exception handling
- validation foundation

Status:

```text
Completed
```

---

### Phase 2 — Authentication & Authorization

Includes:

- register
- login
- logout
- refresh token
- JWT generation
- JWT validation
- password hashing
- RBAC

Status:

```text
In progress
```

---

### Phase 3 — User Management

Includes:

- profile retrieval
- profile update
- avatar update
- account locking
- admin user management

---

### Phase 4 — Rental Property Management

Includes:

- create motels
- update motels
- delete motels
- ownership validation
- image management

---

### Phase 5 — Room Management

Includes:

- room CRUD
- room availability
- room pricing
- room capacity
- room images

---

### Phase 6 — Listing / Post System

Includes:

- listing creation
- listing moderation
- search exposure
- boost premium listing

---

### Phase 7 — Search System

Includes:

- filtering
- sorting
- pagination
- location search
- keyword search

---

### Phase 8 — Booking System

Includes:

- booking request
- booking approval
- cancellation
- booking state transitions

---

### Phase 9 — Reviews & Blog

Includes:

- tenant reviews
- rating system
- blog content

---

### Phase 10 — Payments & Subscriptions

Includes:

- service plans
- subscriptions
- coupon handling
- payment transaction flow

---

### Phase 11 — Admin Governance

Includes:

- moderation
- analytics
- reports
- platform management

---

### Phase 12 — Optimization & Hardening

Includes:

- performance tuning
- caching
- indexing
- security hardening
- production deployment

---

# Git Workflow

Recommended branch strategy:

```text
main
develop
feature/auth
feature/users
feature/motels
feature/bookings
feature/payments
```

Example:

```bash
git checkout develop
git checkout -b feature/auth
```

Commit examples:

```bash
feat(auth): implement login API
fix(users): validate duplicate email
refactor(bookings): simplify approval flow
docs(api): update auth contract
```

---

# Coding Principles

All development should follow clean architecture principles.

Rules:

---

## Controllers

Controllers MUST:

- receive HTTP requests
- validate DTOs
- delegate to services
- return standardized responses

Controllers MUST NOT:

- contain business logic
- directly access repositories
- perform authorization ownership checks

Incorrect:

```java
controller validates ownership
controller updates database
controller writes business rules
```

Correct:

```java
controller -> service
service handles business logic
```

---

## Services

Services MUST:

- contain business rules
- orchestrate workflows
- validate ownership
- enforce authorization logic
- manage transactions

---

## Repositories

Repositories MUST:

- access database only

Repositories MUST NOT:

- contain business rules
- contain authorization logic

---

## DTOs

DTOs MUST:

- define API contracts
- validate inputs
- separate external contract from internal entities

---

## Entities

Entities MUST:

- represent database structure only

Entities MUST NOT:

- be directly exposed to frontend

---

# Testing Strategy Overview

Testing layers:

---

## Unit Tests

Scope:

- services
- validators
- mappers
- utility logic

Purpose:

business rule correctness

---

## Integration Tests

Scope:

- repository queries
- database integration
- transaction workflows

Purpose:

persistence correctness

---

## API Tests

Scope:

- controller endpoints
- request validation
- authentication behavior
- response structure

Tools:

- Postman
- Swagger
- integration testing framework

---

## Security Tests

Scope:

- unauthorized access
- expired token behavior
- role restriction
- forbidden resource access

---

# Deployment Strategy

Planned deployment targets:

Development:

```text
Local machine
```

Staging:

```text
Railway / Render
```

Production-style simulation:

```text
Docker + VPS
```

Possible architecture:

```text
Frontend
    ↓
Reverse Proxy
    ↓
Spring Boot API
    ↓
MySQL Database
```

---

# Security Philosophy

Security is treated as a core architecture concern.

Implemented / planned:

- JWT authentication
- refresh token validation
- BCrypt password hashing
- RBAC authorization
- endpoint protection
- CORS restrictions
- DTO validation
- input sanitization
- SQL injection prevention via ORM
- XSS protection
- rate limiting
- audit logging

---

# Contribution Rules

If multiple developers or AI agents work on this repository:

Rules:

- follow documented architecture
- do not invent conflicting folder structures
- do not bypass DTO boundaries
- do not place business logic in controllers
- do not expose entities directly
- maintain API response consistency
- preserve naming conventions

---

# AI Agent Instructions

This repository is AI-assisted.

If an AI coding assistant modifies this project:

must follow:

- existing folder structure
- modular architecture
- Spring Boot conventions
- RoomHub business rules
- API contract standards
- database schema consistency

AI MUST NOT:

- generate inconsistent architecture
- bypass service layer
- create duplicate business logic
- violate RBAC rules
- break API response format

---

# Graduation Project Goal

This project is intentionally designed to exceed a simple academic CRUD application.

Target qualities:

- production-inspired architecture
- maintainable codebase
- scalable modular design
- secure authentication model
- realistic business workflows
- professional documentation
- clean engineering practices

RoomHub is built as both:

- a graduation project
- a professional software engineering portfolio project

---
