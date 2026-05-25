# RoomHub Backend Structure Guide

I want all UI labels, card titles, and inventory-related text to be displayed in Vietnamese, as this system is specifically designed for Vietnamese users.

Production-grade backend architecture rules for the RoomHub system.

This document defines the official Spring Boot backend architecture.

Purpose:

- prevent messy code generation
- enforce clean architecture
- keep AI assistants consistent
- standardize naming conventions
- make project scalable
- improve maintainability
- support production-style development

This file is the backend source of truth.

---

# Technology Baseline

Official backend stack:

```text
Java 17
Spring Boot 3+
Spring Security
Spring Data JPA
Hibernate
MySQL 8+
JWT
Maven
Swagger / OpenAPI
Bean Validation
Lombok
MapStruct (recommended)
```

Optional later:

```text
Redis
Docker
Testcontainers
Flyway
Cloudinary
RabbitMQ
Elasticsearch
```

---

# Architecture Philosophy

RoomHub follows:

```text
Modular Monolith Architecture
```

NOT microservices.

Reason:

Graduation project scope.

Benefits:

- simpler deployment
- easier debugging
- lower complexity
- clean separation still possible
- future microservice migration easier

---

# Architectural Principles

Mandatory principles:

- separation of concerns
- single responsibility
- explicit boundaries
- DTO isolation
- layered architecture
- domain-driven module grouping
- no fat controllers
- no direct entity exposure
- no business logic in controllers
- no repository logic in controllers
- reusable services
- global exception handling
- consistent API response format

---

# Backend Root Structure

Official structure:

```text
src/main/java/com/chinh/roomhub
│
├── RoomhubApplication.java
│
├── config
├── common
├── security
├── exception
├── utils
├── infrastructure
│
├── auth
├── users
├── motels
├── rooms
├── posts
├── favorites
├── bookings
├── reviews
├── blogs
├── payments
├── serviceplans
├── packages
├── subscriptions
├── coupons
├── admin
├── uploads
└── health
```

This structure is mandatory.

---

# Why Modular Structure

Bad structure:

```text
controllers/
services/
repositories/
entities/
```

This becomes chaotic.

Example:

```text
50 controllers in one folder
40 services in one folder
huge maintenance nightmare
```

Bad scalability.

---

Good structure:

feature-based modules.

Example:

```text
auth/
users/
bookings/
payments/
```

Benefits:

- domain isolation
- cleaner ownership
- easier onboarding
- simpler testing
- better scaling

---

# Common Shared Layer

Folder:

```text
common
```

Purpose:

cross-cutting shared code.

Structure:

```text
common
├── dto
├── enums
├── constants
├── response
├── pagination
```

Examples:

```text
ApiResponse
PageResponse
BaseEnum
ApplicationConstants
```

Rules:

NO business logic here.

Only reusable shared infrastructure.

---

# Config Layer

Folder:

```text
config
```

Purpose:

application configuration.

Contains:

```text
SecurityConfig
OpenApiConfig
CorsConfig
JacksonConfig
AsyncConfig
JpaConfig
```

Rules:

NO domain logic.

Only framework configuration.

---

# Security Layer

Folder:

```text
security
```

Purpose:

authentication + authorization infrastructure.

Structure:

```text
security
├── jwt
├── filter
├── service
├── handler
├── principal
```

Example:

```text
JwtService
JwtAuthenticationFilter
CustomUserDetailsService
AuthenticationEntryPointHandler
AccessDeniedHandlerImpl
CustomUserPrincipal
```

Responsibilities:

- token parsing
- token validation
- security context population
- unauthorized response
- forbidden response

NO business domain logic.

---

# Exception Layer

Folder:

```text
exception
```

Purpose:

centralized error handling.

Structure:

```text
exception
├── GlobalExceptionHandler
├── custom
└── errorcode
```

Examples:

```text
ResourceNotFoundException
BusinessException
UnauthorizedException
ForbiddenException
ConflictException
ValidationException
```

Benefits:

consistent API errors.

---

# Utility Layer

Folder:

```text
utils
```

Purpose:

stateless helper functions.

Examples:

```text
DateTimeUtils
StringUtils
SlugUtils
FileUtils
PhoneUtils
```

Rules:

NO service orchestration.

NO repository access.

Only pure helpers.

---

# Infrastructure Layer

Folder:

```text
infrastructure
```

Purpose:

external integrations.

Examples:

```text
cloudinary
payment
mail
storage
```

Examples:

```text
CloudinaryStorageService
VnPayClient
EmailSenderService
LocalFileStorageService
```

Reason:

keep third-party code isolated.

---
# Feature Module Standard Structure

Every business domain follows a consistent module structure.

Example:

```text
users
├── controller
├── service
├── repository
├── dto
├── entity
├── mapper
└── specification
```

Optional:

```text
validator
facade
event
```

Rules:

all modules follow consistent architecture.

---

# Controller Layer Rules

Folder:

```text
controller
```

Purpose:

HTTP request entrypoint only.

Example:

```text
AuthController
UserController
MotelController
BookingController
```

Responsibilities:

ONLY:

- receive HTTP request
- validate DTO
- call service
- return response

Controller MUST NOT:

- contain business rules
- query repository
- manipulate entities directly
- perform transaction logic
- parse JWT manually

Bad:

```java
@PostMapping("/login")
public ResponseEntity<?> login(...) {
    User user = userRepository.findByEmail(email);

    if (user == null) {
        ...
    }

    if (!passwordEncoder.matches(...)) {
        ...
    }

    String token = jwtService.generate(...);

    ...
}
```

Wrong.

---

Good:

```java
@PostMapping("/login")
public ResponseEntity<ApiResponse<LoginResponse>> login(
        @Valid @RequestBody LoginRequest request
) {
    return ResponseEntity.ok(
        ApiResponse.success(
            "Login successful",
            authService.login(request)
        )
    );
}
```

---

# Service Layer Rules

Folder:

```text
service
```

Purpose:

business orchestration.

Structure:

```text
service
├── AuthService
├── AuthServiceImpl
```

Responsibilities:

- business logic
- workflow orchestration
- validation beyond DTO
- repository coordination
- transactional operations
- authorization ownership checks

Service MAY:

- call repositories
- call external services
- throw domain exceptions

Service MUST NOT:

- return entities directly to controller
- know HTTP details

---

# Repository Layer Rules

Folder:

```text
repository
```

Purpose:

database access.

Examples:

```text
UserRepository
RoomRepository
BookingRepository
```

Rules:

repositories only handle persistence.

Allowed:

```java
findById()
findByEmail()
existsByEmail()
save()
delete()
```

NOT business logic.

Bad:

```java
approveBookingAndUpdateSubscriptionAndCreateReview()
```

Wrong abstraction.

---

# DTO Layer Rules

Folder:

```text
dto
```

Purpose:

request/response contracts.

Structure:

```text
dto
├── request
└── response
```

Example:

```text
LoginRequest
RegisterRequest
UserProfileResponse
BookingResponse
```

Rules:

DTOs are mandatory.

Entities must NEVER be exposed directly.

---

# Entity Layer Rules

Folder:

```text
entity
```

Purpose:

database model.

Examples:

```text
User
Room
Booking
Payment
Subscription
```

Rules:

Entities represent persistence model only.

Entities MUST NOT:

- contain controller logic
- contain API response formatting
- depend on HTTP layer

Keep entities focused.

---

# Mapper Layer Rules

Folder:

```text
mapper
```

Purpose:

DTO ↔ Entity transformation.

Recommended:

```text
MapStruct
```

Examples:

```text
UserMapper
BookingMapper
PostMapper
```

Responsibilities:

- request DTO → entity
- entity → response DTO

Benefits:

clean services.

---

# Specification Layer

Optional.

Folder:

```text
specification
```

Purpose:

dynamic filtering queries.

Useful for:

```text
search
posts
motels
rooms
admin filtering
```

Examples:

```text
PostSpecification
RoomSpecification
UserSpecification
```

---

# Auth Module Structure

Official structure:

```text
auth
├── controller
│   └── AuthController.java
│
├── service
│   ├── AuthService.java
│   └── AuthServiceImpl.java
│
├── repository
│   └── RefreshTokenRepository.java
│
├── dto
│   ├── request
│   │   ├── LoginRequest.java
│   │   ├── RegisterRequest.java
│   │   └── RefreshTokenRequest.java
│   │
│   └── response
│       ├── LoginResponse.java
│       └── RegisterResponse.java
│
├── entity
│   └── RefreshToken.java
│
└── mapper
```

Responsibilities:

auth lifecycle only.

---

# Users Module Structure

```text
users
├── controller
├── service
├── repository
├── dto
├── entity
├── mapper
└── specification
```

Examples:

```text
UserController
UserService
UserRepository
UserProfileResponse
UpdateProfileRequest
```

Responsibilities:

- profile
- account lifecycle
- admin user management

---

# Motels Module Structure

```text
motels
├── controller
├── service
├── repository
├── dto
├── entity
├── mapper
└── specification
```

Responsibilities:

- motel CRUD
- ownership validation
- motel filtering

---

# Rooms Module Structure

```text
rooms
├── controller
├── service
├── repository
├── dto
├── entity
├── mapper
└── specification
```

Responsibilities:

- room CRUD
- room state
- room availability

---

# Posts Module Structure

```text
posts
├── controller
├── service
├── repository
├── dto
├── entity
├── mapper
└── specification
```

Responsibilities:

- public listings
- moderation lifecycle
- boosting

---

# Favorites Module Structure

```text
favorites
├── controller
├── service
├── repository
├── dto
├── entity
├── mapper
```

Responsibilities:

tenant saved posts.

---

# Bookings Module Structure

```text
bookings
├── controller
├── service
├── repository
├── dto
├── entity
├── mapper
```

Critical domain.

Contains:

workflow transitions:

```text
PENDING
APPROVED
REJECTED
CANCELLED
COMPLETED
```

Transaction-heavy.

---

# Reviews Module Structure

```text
reviews
├── controller
├── service
├── repository
├── dto
├── entity
├── mapper
```

Responsibilities:

verified tenant reviews.

---
# Payments Module Structure

Payments are financial workflow modules.

Structure:

```text
payments
├── controller
│   └── PaymentController.java
│
├── service
│   ├── PaymentService.java
│   └── PaymentServiceImpl.java
│
├── repository
│   └── PaymentRepository.java
│
├── dto
│   ├── request
│   │   ├── CreatePaymentRequest.java
│   │   └── PaymentCallbackRequest.java
│   │
│   └── response
│       ├── PaymentResponse.java
│       └── PaymentHistoryResponse.java
│
├── entity
│   └── Payment.java
│
└── mapper
```

Responsibilities:

- create payment orders
- validate payment callback
- payment history
- transaction reconciliation

Rules:

financial logic must be transactional.

---

# ServicePlans Module Structure

Structure:

```text
serviceplans
├── controller
├── service
├── repository
├── dto
├── entity
├── mapper
```

Responsibilities:

technical entitlement definitions.

Examples:

```text
listing quota
boost quota
analytics access
image quota
```

Rules:

service plans are referenced by packages and subscriptions.

They are not directly purchased through payment APIs.

---

# Packages Module Structure

Structure:

```text
packages
- controller
- service
- repository
- dto
- entity
- mapper
```

Responsibilities:

commercial package definitions sold to landlords.

Examples:

```text
Starter Monthly
Pro Monthly
Pro Quarterly Promotion
```

Rules:

each package references one service plan.

Package owns price, duration, display copy, sale visibility, and promotion positioning.

ServicePlans own technical quotas and feature entitlements.

---

# Subscriptions Module Structure

Structure:

```text
subscriptions
├── controller
├── service
├── repository
├── dto
├── entity
├── mapper
```

Responsibilities:

landlord premium lifecycle.

Examples:

- activation
- expiration
- quota usage
- boost tracking

---

# Coupons Module Structure

Structure:

```text
coupons
├── controller
├── service
├── repository
├── dto
├── entity
├── mapper
```

Responsibilities:

discount validation.

---

# Admin Module Structure

Admin is orchestration-heavy.

Structure:

```text
admin
├── controller
├── service
├── dto
└── mapper
```

Admin often coordinates multiple modules.

Examples:

- approve post
- reject listing
- dashboard analytics
- user moderation
- report resolution

Admin MAY call:

```text
users
posts
reviews
payments
bookings
```

repositories indirectly through services.

Never bypass business services recklessly.

---

# Upload Module Structure

Structure:

```text
uploads
├── controller
├── service
├── dto
```

Infrastructure integration delegated to:

```text
infrastructure/storage
```

Responsibilities:

- image upload
- validation
- storage abstraction

---

# Health Module Structure

Structure:

```text
health
├── controller
└── dto
```

Simple infrastructure diagnostics.

Example:

```text
GET /health
```

No business logic.

---

# Entity Design Rules

Entities represent database persistence.

Example:

```java
@Entity
@Table(name = "users")
public class User {
}
```

Rules:

entities must remain persistence-focused.

Allowed:

- JPA annotations
- relationships
- lifecycle hooks (minimal)

Forbidden:

- HTTP logic
- controller logic
- response formatting
- business orchestration

---

# Entity Inheritance Rule

Recommended shared base entity:

```text
common/entity/BaseEntity
```

Example fields:

```java
id
createdAt
updatedAt
deletedAt
isDeleted
```

Benefits:

consistency.

---

Example:

```java
@MappedSuperclass
public abstract class BaseEntity {
}
```

---

# DTO Naming Convention

Requests:

```text
CreateUserRequest
UpdateProfileRequest
LoginRequest
CreateBookingRequest
```

Responses:

```text
UserProfileResponse
BookingResponse
LoginResponse
```

Rules:

explicit names only.

Bad:

```text
UserDto
DataDto
ResponseDto
RequestDto
```

Too vague.

---

# Controller Naming Convention

Pattern:

```text
<Resource>Controller
```

Examples:

```text
AuthController
UserController
MotelController
BookingController
PaymentController
```

---

# Service Naming Convention

Interface:

```text
UserService
BookingService
```

Implementation:

```text
UserServiceImpl
BookingServiceImpl
```

---

# Repository Naming Convention

Pattern:

```text
<Entity>Repository
```

Examples:

```text
UserRepository
RoomRepository
ReviewRepository
```

---

# Mapper Naming Convention

Pattern:

```text
<Entity>Mapper
```

Examples:

```text
UserMapper
BookingMapper
PaymentMapper
```

---

# Enum Strategy

Shared enums:

```text
common/enums
```

Examples:

```text
Role
UserStatus
RoomStatus
BookingStatus
PaymentStatus
PostStatus
SubscriptionStatus
```

Benefits:

type safety.

---

# Constants Strategy

Shared constants:

```text
common/constants
```

Examples:

```text
SecurityConstants
ApplicationConstants
ValidationConstants
```

Avoid magic strings.

Bad:

```java
if (role.equals("ADMIN"))
```

Good:

```java
if (role == Role.ADMIN)
```

---

# Dependency Rule

Allowed direction:

```text
controller → service → repository
```

NOT:

```text
controller → repository
```

NOT:

```text
repository → service
```

NOT:

```text
entity → controller
```

Strict layering.

---

# Cross Module Communication Rule

Allowed:

```text
BookingService calls RoomService
```

Example:

booking approval updates room status.

Preferred:

service-to-service collaboration.

Avoid:

direct foreign repository access everywhere.

Bad:

```java
BookingService directly manipulates PaymentRepository randomly
```

Creates coupling.

---

# Transaction Rule

Use:

```java
@Transactional
```

Only where needed.

Examples:

Required:

- booking approval
- payment callback
- subscription activation
- post boost quota deduction

Avoid blanket transactions.

---

# Validation Rule

Two layers:

Layer 1:

DTO validation.

Example:

```java
@NotBlank
@Email
@Size
```

Layer 2:

business validation.

Example:

```text
ownership
state transitions
quota checks
duplicate business rules
```

---

# Security Rule

Authentication:

centralized security layer.

Authorization:

service-level ownership validation + RBAC.

Examples:

```text
landlord owns motel?
tenant owns booking?
admin role?
```

Never trust frontend role claims.

---

# Logging Rule

Use:

```java
@Slf4j
```

Log:

- startup
- business events
- warnings
- exceptions

Never log:

```text
password
jwt
refresh token
payment secrets
```

---

# Exception Rule

Throw custom exceptions.

Examples:

```text
ResourceNotFoundException
ConflictException
BusinessException
UnauthorizedException
ForbiddenException
```

Never:

```java
throw new RuntimeException("something");
```

Too generic.

---

# API Response Rule

Controllers must return:

```java
ApiResponse<T>
```

Standardized only.

Never inconsistent JSON.

---

# Query Strategy Rule

Simple lookups:

Spring Data derived methods.

Examples:

```java
findByEmail()
existsById()
```

Complex filtering:

Specification.

Heavy reporting:

custom JPQL/native query.

---

# File Naming Rule

One public class per file.

Names must match class names.

---

# Package Naming Rule

Lowercase only.

Good:

```text
users
auth
payments
```

Bad:

```text
UserModule
AuthModule
```

---

# Code Style Rule

Use constructor injection only.

Good:

```java
@RequiredArgsConstructor
```

Avoid:

```java
@Autowired field injection
```

---

# AI Coding Enforcement Rule

AI-generated backend code MUST follow this structure exactly.

No invented architectures.

No mixing feature boundaries.

No giant god classes.

No dumping everything into controller/service.

This file is the backend implementation source of truth.

---
