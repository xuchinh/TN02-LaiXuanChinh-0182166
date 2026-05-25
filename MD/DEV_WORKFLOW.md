# RoomHub Development Workflow

I want all UI labels, card titles, and inventory-related text to be displayed in Vietnamese, as this system is specifically designed for Vietnamese users.

Official development workflow for RoomHub.

This document defines:

- coding conventions
- Git workflow
- branching rules
- commit rules
- pull request standards
- environment setup
- Definition of Done
- testing expectations
- AI code generation rules
- team collaboration rules

This document is the engineering workflow source of truth.

---

# Development Philosophy

RoomHub development must be:

```text
predictable
maintainable
reviewable
scalable
secure
testable
team-friendly
```

No chaotic coding.

No random architecture decisions.

No “just make it work” production code.

---

# Engineering Principles

Mandatory:

```text
clean architecture
single responsibility
separation of concerns
strong typing
security first
consistency over personal preference
backend as source of truth
modular feature design
reusable code
documented decisions
```

---

# Golden Rule

Before writing code:

ask:

```text
Does this match RoomHub architecture docs?
```

If not:

do not implement.

Architecture docs override developer preference.

---

# Mandatory Reference Documents

All implementation must comply with:

```text
README.md
SYSTEM_ARCHITECTURE.md
BUSINESS_RULES.md
API_CONTRACT.md
BACKEND_STRUCTURE.md
FRONTEND_STRUCTURE.md
SECURITY_RULES.md
DATABASE_RULES.md
DEV_WORKFLOW.md
```

No contradictions allowed.

---

# Tech Stack

Official RoomHub stack:

Backend:

```text
Java
Spring Boot
Spring Security
Spring Data JPA
MySQL
Flyway
Maven
JWT
```

Frontend:

```text
Next.js
TypeScript
React
TanStack Query
Zustand
Axios
React Hook Form
Zod
Tailwind CSS
Shadcn UI
```

Infra:

```text
GitHub
Docker (future)
Cloudinary
VNPay / payment provider
```

---

# Local Environment Rules

Minimum versions:

Backend:

```text
Java 17+
Maven 3.9+
MySQL 8+
```

Frontend:

```text
Node 20+
npm 10+
```

---

# Environment Variable Rules

Never hardcode secrets.

Required files:

Backend:

```text
.env
application-dev.yml
application-prod.yml
```

Frontend:

```text
.env.local
```

---

Examples:

Backend:

```env
DB_URL=
DB_USERNAME=
DB_PASSWORD=
JWT_SECRET=
JWT_REFRESH_SECRET=
CLOUDINARY_API_KEY=
VNPAY_SECRET=
```

Frontend:

```env
NEXT_PUBLIC_API_BASE_URL=
NEXT_PUBLIC_CLOUDINARY_CLOUD_NAME=
```

---

# Git Workflow Standard

Official model:

```text
feature branch workflow
```

NOT:

```text
direct commits to main
```

Forbidden.

---

# Branching Strategy

Main branches:

```text
main
develop
```

Purpose:

main:

```text
production-ready stable code
```

develop:

```text
integration branch
```

---

Feature branches:

Pattern:

```text
feature/<module>-<short-description>
```

Examples:

```text
feature/auth-login
feature/booking-workflow
feature/payment-vnpay
feature/admin-user-management
```

---

Bugfix branches:

Pattern:

```text
bugfix/<issue>
```

Examples:

```text
bugfix/login-token-refresh
bugfix/booking-status-race
```

---

Hotfix branches:

Pattern:

```text
hotfix/<issue>
```

Examples:

```text
hotfix/payment-callback-validation
hotfix/admin-auth-bypass
```

Production-critical only.

---

# Branch Protection Rules

Protect:

```text
main
develop
```

Rules:

```text
no direct push
PR required
review required
CI checks required
```

---

# Commit Philosophy

Commits must be:

```text
small
atomic
reviewable
meaningful
```

Bad:

```text
"fix stuff"
"update"
"done"
```

Forbidden.

---

# Commit Convention

Use:

```text
Conventional Commits
```

Format:

```text
type(scope): message
```

Examples:

```text
feat(auth): add JWT login endpoint
feat(booking): implement booking request flow
fix(payment): prevent duplicate callback processing
refactor(user): extract profile mapper
docs(api): update auth contract
test(auth): add login integration tests
```

---

Commit types:

```text
feat
fix
refactor
docs
test
chore
perf
security
build
ci
```

---

# Commit Size Rule

Avoid giant commits.

Good:

```text
one logical change
```

Bad:

```text
entire auth + booking + payments in one commit
```

---

# Pull Request Rules

PRs are mandatory.

No direct merge to protected branches.

Every PR must include:

```text
purpose
scope
testing summary
screenshots (frontend)
breaking changes
migration notes
```

---

# PR Size Rule

Preferred:

small to medium PRs.

Avoid:

monster PRs.

Bad:

```text
10,000 lines changed
```

Hard to review.

---

# PR Naming Convention

Examples:

```text
[AUTH] Implement refresh token flow
[BOOKING] Add tenant booking request API
[PAYMENT] VNPay callback validation
```

---

# Code Review Rules

Review for:

```text
architecture compliance
security
performance
readability
duplication
business rule correctness
naming consistency
```

Not just “works on my machine”.

---
# Definition of Done (DoD)

A task is NOT complete just because code compiles.

A task is complete only when ALL conditions pass.

Mandatory checklist:

```text
requirements implemented
architecture compliant
security compliant
database migration included (if needed)
API contract updated (if needed)
tests written
manual testing completed
lint passes
build passes
no debug leftovers
documentation updated
PR reviewed
```

---

# Backend Definition of Done

Backend feature complete only if:

```text
controller implemented
service implemented
DTOs implemented
validation added
authorization added
error handling added
repository logic implemented
transaction handling correct
integration tested
security reviewed
```

---

# Frontend Definition of Done

Frontend feature complete only if:

```text
UI implemented
responsive behavior checked
API integration working
loading states implemented
error states implemented
empty states implemented
form validation implemented
type safety maintained
query invalidation correct
auth protection correct
```

---

# Testing Expectations

Minimum expectation:

test critical business logic.

Testing is not optional.

---

# Backend Testing Pyramid

Required levels:

```text
unit tests
integration tests
```

Optional later:

```text
e2e tests
performance tests
security tests
```

---

# Backend Unit Testing Targets

Good unit test targets:

```text
service logic
business rules
validators
mappers
calculations
authorization rules
```

Bad unit test targets:

```text
simple getters/setters
trivial DTO constructors
```

---

# Backend Integration Testing Targets

Test:

```text
auth endpoints
booking workflow
payment workflow
subscription activation
database persistence
repository queries
security restrictions
```

---

# Frontend Testing Strategy

Recommended:

```text
component tests
hook tests
integration tests
```

Later optional:

```text
Playwright e2e
```

---

# Manual Testing Rule

Every feature must be manually validated.

Checklist:

```text
happy path
validation failure
auth failure
network failure
empty state
edge cases
role restrictions
```

---

# Backend Code Style

Rules:

```text
thin controllers
fat services
explicit DTOs
no business logic in controllers
repositories for persistence only
no god services
constructor injection only
```

---

# Controller Rules

Controllers handle:

```text
routing
request mapping
validation trigger
response formatting
```

Controllers do NOT handle:

```text
business rules
complex authorization
database logic
payment logic
```

Bad:

```java
@PostMapping
public ResponseEntity<?> pay(...) {
   // 200 lines business logic
}
```

Forbidden.

---

# Service Rules

Services own:

```text
business logic
workflow orchestration
authorization checks
transactions
domain validation
```

---

# Repository Rules

Repositories only handle:

```text
data access
queries
persistence
```

Repositories do NOT contain:

```text
business workflows
authorization logic
payment orchestration
```

---

# DTO Rules

DTOs are mandatory.

Request DTO:

input boundary.

Response DTO:

safe output boundary.

Never expose entities directly.

Forbidden:

```java
return User entity
```

---

# Mapper Rules

Mapping must be explicit.

Use:

```text
manual mapper
MapStruct (optional)
```

Never leak persistence entities to API layer.

---

# Exception Handling Rules

Global exception handling required.

Use:

```text
@ControllerAdvice
```

Centralize:

```text
validation errors
not found
access denied
business exceptions
unexpected failures
```

---

# Logging Rules

Use structured meaningful logs.

Good:

```java
Booking created for user {} room {}
```

Bad:

```java
here
test
123
```

---

Log levels:

```text
INFO
WARN
ERROR
DEBUG (dev only)
```

Production debug logging minimized.

---

# Frontend Coding Rules

Rules:

```text
feature modular architecture
typed API contracts
thin pages
reusable components
hooks for async logic
query-driven server state
minimal global state
```

---

# Frontend Component Rules

Components must be small.

Good:

```text
RoomCard
BookingModal
PaymentSummary
ReviewList
```

Bad:

```text
MegaDashboardComponent.tsx
```

---

# Page Rules

Pages compose features.

Pages should NOT contain:

```text
heavy business logic
raw API calls
complex state orchestration
```

---

# Hook Rules

Custom hooks own async behavior.

Examples:

```text
useLogin
useBookings
useCreateBooking
usePayments
```

Hooks responsibilities:

```text
query
mutation
error handling
cache invalidation
```

---

# State Management Rules

Use Zustand ONLY for:

```text
auth state
theme
small UI state
```

Do NOT store server resources globally.

Bad:

```text
bookings in Zustand
posts in Zustand
payments in Zustand
```

Use React Query instead.

---

# API Layer Rules

Frontend API access must be centralized.

Folder:

```text
src/lib/api
```

Pattern:

```text
axios instance
feature API modules
interceptors
```

Forbidden:

```tsx
axios.get() directly inside component
```

---

# Form Rules

Use:

```text
React Hook Form
Zod
```

Mandatory:

```text
validation
typed forms
error feedback
```

---

# Naming Conventions

Consistent naming required.

---

Backend Java:

Classes:

```text
PascalCase
```

Examples:

```text
UserService
BookingController
PaymentRepository
```

Methods:

```text
camelCase
```

Examples:

```text
createBooking()
validatePayment()
findActiveSubscription()
```

Variables:

```text
camelCase
```

Constants:

```text
UPPER_SNAKE_CASE
```

---

Frontend:

Components:

```text
PascalCase
```

Examples:

```text
LoginForm.tsx
RoomCard.tsx
PaymentModal.tsx
```

Hooks:

```text
useSomething
```

Examples:

```text
useAuth
useBookings
usePayments
```

Files:

```text
kebab-case OR aligned standard
```

Be consistent.

---

# Folder Naming Rules

Good:

```text
auth
booking
payment
review
admin
shared
```

Bad:

```text
misc
stuff
temp
newfolder2
```

---

# Code Duplication Rule

Avoid duplication.

If reused:

extract.

Examples:

```text
validation logic
API response mapping
UI primitives
shared hooks
```

---

# Magic Values Rule

Avoid hardcoded mystery values.

Bad:

```java
if (attempts > 5)
```

Good:

```java
MAX_LOGIN_ATTEMPTS
```

---

# Comment Rules

Code should be self-explanatory.

Comments explain WHY.

Not obvious WHAT.

Bad:

```java
// increment i
i++;
```

Good:

```java
// prevent duplicate payment callback processing
```

---
# Linting Rules

Code formatting must be automated.

No manual style wars.

---

Frontend:

Required:

```text
ESLint
Prettier
TypeScript strict mode
```

Commands:

```bash
npm run lint
npm run type-check
npm run build
```

All must pass before merge.

---

Backend:

Required:

```text
Maven build validation
compiler warnings review
optional Checkstyle / Spotless
```

Commands:

```bash
mvn clean test
mvn verify
```

Must pass before merge.

---

# Formatting Rules

Never mix formatting styles.

Examples:

consistent:

```text
indentation
quotes
line length
import order
spacing
```

Formatting handled by tooling, not opinion.

---

# Dependency Management Rules

Dependencies are security risk + maintenance cost.

Rule:

minimum necessary dependencies only.

Before adding a library ask:

```text
Can existing stack already solve this?
```

---

Bad:

adding package for trivial utility.

Good:

use native solution.

---

# Dependency Approval Rules

New dependency review criteria:

```text
maintenance quality
security history
community adoption
bundle impact
license compatibility
```

Reject abandoned libraries.

---

# Version Pinning Rules

Avoid floating chaos.

Preferred:

explicit versions.

Frontend:

```json
"axios": "x.y.z"
```

Backend:

controlled Maven versions.

---

# Dead Dependency Rule

Remove unused packages.

Never accumulate junk dependencies.

Audit regularly.

---

# Migration Workflow

Schema changes MUST be migration-based.

Never manual DB drift.

Process:

```text
update entity model
create migration
test migration locally
verify rollback strategy
commit migration
```

---

# Migration Review Rules

Migration review checklist:

```text
safe for existing data
indexes correct
constraints correct
FK behavior correct
rollback possible
production-safe execution time
```

---

# Breaking Schema Changes

Dangerous operations:

```text
drop columns
rename columns
change types
delete constraints
mass data transforms
```

Require explicit review.

---

# API Change Workflow

API contract changes require:

```text
API_CONTRACT.md update
frontend compatibility review
backend implementation review
breaking change communication
```

No silent API drift.

---

# Breaking API Rules

Examples:

breaking:

```text
rename response field
remove endpoint
change auth requirement
change enum values
change payload shape
```

Require coordination.

---

# Frontend Integration Workflow

Recommended flow:

```text
contract defined
types generated / aligned
API wrapper implemented
hooks implemented
UI integration
manual validation
```

Avoid ad hoc direct wiring.

---

# Release Workflow

Suggested release flow:

```text
feature -> develop
test on integration
stabilize
merge to main
tag release
deploy
```

---

# Release Tagging Convention

Examples:

```text
v0.1.0
v0.2.0
v1.0.0
```

Semantic versioning preferred.

---

# Hotfix Workflow

Critical production issue:

flow:

```text
hotfix branch
fix
test
review
merge main
back-merge develop
```

Never emergency patch random branches.

---

# CI/CD Expectations

Minimum CI checks:

Frontend:

```text
lint
type check
build
```

Backend:

```text
compile
unit tests
integration tests
```

Optional later:

```text
security scan
dependency scan
docker build
e2e
```

---

# CI Failure Rule

Broken CI:

NO merge.

Forbidden:

```text
merge anyway
fix later
```

---

# Debug Artifact Rule

Never commit:

```text
console.log spam
temporary bypass code
debug credentials
TODO security bypass
test hacks
```

Examples:

bad:

```ts
console.log(token)
```

bad:

```java
permitAll() // temporary
```

Forbidden.

---

# Feature Flag Rule

Experimental features should be controlled.

Optional:

```text
feature flags
env toggles
admin switches
```

Avoid unstable production exposure.

---

# Documentation Update Rule

If implementation changes architecture behavior:

documentation update required.

Examples:

```text
new auth flow
new payment flow
schema change
new API contract
new module
```

---

# Knowledge Sharing Rule

Important engineering decisions must be documented.

Avoid tribal knowledge.

---

# AI Code Generation Rules

AI-generated code is NOT trusted automatically.

Mandatory review required.

---

AI-generated code MUST be checked for:

```text
security flaws
architecture violations
hallucinated APIs
bad dependency suggestions
incorrect business logic
poor naming
missing validation
performance issues
```

---

# AI Forbidden Patterns

Reject AI-generated code that:

```text
returns entities directly
stores plaintext secrets
uses raw SQL concatenation
trusts frontend authorization
skips DTO validation
duplicates large logic blocks
hardcodes credentials
mixes concerns
creates giant god classes
```

---

# Copy-Paste Rule

Never blindly paste code.

Understand before merge.

---

# Code Ownership Rule

Developer owns merged code quality.

“AI wrote it” is not a valid excuse.

---

# Anti-Chaos Rules

Forbidden:

```text
random folder creation
architecture bypass
duplicate services
multiple coding styles
silent API changes
manual production fixes
temporary hacks becoming permanent
```

---

# Refactor Rules

Allowed when:

```text
improves clarity
reduces duplication
improves architecture compliance
improves testability
improves performance safely
```

Refactor must not silently break behavior.

---

# Performance Review Rules

Review hotspots:

```text
N+1 queries
large payloads
unpaginated endpoints
excess rerenders
duplicate API requests
heavy frontend bundles
```

---

# Security Review Rule

Every auth/payment/admin change requires explicit security review.

High-risk modules:

```text
auth
payments
subscriptions
admin
file uploads
booking state transitions
```

---

# Merge Readiness Checklist

Before merge:

```text
architecture compliant
security compliant
tests passing
CI green
docs updated
no debug leftovers
review completed
migration safe
```

---

# Team Communication Rule

If uncertain:

ask before architectural deviation.

Do NOT invent competing patterns.

---

# RoomHub Development Source Of Truth

This document governs:

```text
workflow
branching
commits
PRs
testing
release flow
code quality
AI usage
dependency policy
documentation discipline
team consistency
```

All RoomHub development must comply.

---
