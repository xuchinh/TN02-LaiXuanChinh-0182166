# RoomHub Security Rules

I want all UI labels, card titles, and inventory-related text to be displayed in Vietnamese, as this system is specifically designed for Vietnamese users.

Production-grade security rules for RoomHub backend and frontend.

This document is the official security source of truth.

Purpose:

- prevent common security vulnerabilities
- enforce safe authentication design
- secure API access
- protect user data
- harden file uploads
- reduce attack surface
- standardize security implementation
- force AI-generated code to follow secure patterns

This document is mandatory.

---

# Security Philosophy

Security is layered.

Never trust:

```text
frontend
client-side validation
browser state
request payloads
user role claims
query parameters
file names
JWT payload without verification
```

Always trust only:

```text
validated backend logic
verified JWT signatures
database authorization checks
server-side validation
```

---

# Core Security Principles

Mandatory:

- least privilege
- defense in depth
- fail secure
- explicit authorization
- secure by default
- token expiration
- zero trust client mindset
- validation at every boundary
- minimal data exposure
- strong password handling

---

# Threat Model

RoomHub must defend against:

```text
unauthorized API access
token theft
JWT forgery
refresh token abuse
horizontal privilege escalation
vertical privilege escalation
SQL injection
XSS
CSRF
file upload abuse
path traversal
mass assignment
broken access control
brute force login attacks
credential stuffing
ID enumeration
sensitive data leakage
race conditions
payment callback forgery
```

---

# Authentication Standard

Official authentication architecture:

```text
JWT Access Token + Refresh Token
```

Required.

NOT session-only auth.

---

# Why JWT

Benefits:

```text
stateless access validation
scalable APIs
frontend/backend separation
mobile/web friendly
microservice migration readiness
```

---

# Access Token Rules

Purpose:

short-lived API authorization.

Properties:

```text
signed
short expiration
contains minimal claims
verifiable server-side
```

Recommended expiry:

```text
15 minutes
```

Acceptable:

```text
10–30 minutes
```

Never:

```text
24 hours
7 days
30 days
```

Too dangerous.

---

# Refresh Token Rules

Purpose:

session continuation.

Properties:

```text
longer-lived
server-tracked
rotatable
revocable
```

Recommended expiry:

```text
7 days
14 days
30 days
```

depending on product policy.

---

# Access Token Storage

Frontend:

recommended:

```text
memory only
```

Examples:

```text
Zustand
React context
```

Avoid:

```text
localStorage
sessionStorage
```

Reason:

XSS theft risk.

---

# Refresh Token Storage

Required:

```text
httpOnly cookie
secure cookie
sameSite policy
```

Reason:

JS cannot read it.

Reduces XSS theft.

---

# JWT Payload Rules

Include only minimal claims.

Allowed:

```json
{
  "sub": "user-id",
  "email": "user@email.com",
  "role": "TENANT",
  "iat": 123,
  "exp": 456
}
```

Do NOT include:

```text
password
phone
address
payment data
refresh token
sensitive profile info
```

---

# JWT Signing Rules

Required:

strong secret.

Environment variable:

```env
JWT_SECRET=
```

Minimum:

```text
256-bit random secret
```

Never:

```text
hardcoded secrets
weak sample strings
```

Bad:

```text
secret123
jwt-secret
roomhub
```

---

# JWT Verification Rules

Backend MUST verify:

```text
signature
expiration
issuer (optional recommended)
audience (optional recommended)
token type
```

Never trust decoded payload without verification.

---

# Token Rotation Policy

Refresh token rotation recommended.

Flow:

```text
refresh request
validate current refresh token
invalidate old token
issue new refresh token
issue new access token
```

Benefits:

limits replay attacks.

---

# Logout Security

Logout MUST:

```text
invalidate refresh token server-side
clear cookie
destroy session state
```

JWT access token naturally expires.

---

# Refresh Token Database Rules

Store:

```text
hashed refresh token
```

NOT raw plaintext.

Recommended fields:

```text
id
user_id
token_hash
expires_at
is_revoked
created_at
updated_at
device_info (optional)
ip_address (optional)
```

---

# Password Security

Passwords MUST be hashed.

Required:

```text
bcrypt
```

Recommended:

```text
bcrypt cost 10–12
```

Never:

```text
plaintext
SHA1
MD5
base64
custom hashing
```

---

# Password Validation Policy

Minimum:

```text
8 characters
```

Recommended:

```text
12+
```

Require:

```text
uppercase
lowercase
number
special character
```

Example regex policy.

---

# Login Error Messaging

Never leak exact auth reason.

Bad:

```text
email not found
wrong password
```

Good:

```text
Invalid credentials
```

Prevents account enumeration.

---

# Brute Force Protection

Protect login endpoints.

Required strategies:

```text
rate limiting
temporary lockouts
IP throttling
captcha (optional)
```

Example:

```text
5 failed attempts / 15 minutes
```

---

# Account Lock Policy

Optional recommended:

after repeated failures:

```text
temporary lock
```

Example:

```text
15 minutes
```

---

# Role Model

Official roles:

```text
TENANT
LANDLORD
ADMIN
```

No arbitrary roles.

---

# Authorization Principle

Authentication:

```text
who are you?
```

Authorization:

```text
what can you do?
```

Separate concerns.

---
# Authorization Architecture

Authentication does NOT equal authorization.

Example:

User has valid JWT.

That does NOT mean:

```text
user can access every resource
```

Backend must explicitly authorize every sensitive action.

---

# RBAC Standard

Official roles:

```text
TENANT
LANDLORD
ADMIN
```

Responsibilities:

TENANT:

```text
browse listings
save favorites
create booking requests
manage own profile
review rented rooms
```

LANDLORD:

```text
manage motels
manage rooms
create posts
manage bookings
buy subscriptions
boost posts
```

ADMIN:

```text
manage users
moderate listings
view analytics
resolve reports
manage platform settings
```

---

# RBAC Enforcement Rule

Frontend hiding buttons is NOT security.

Bad:

```tsx
if (user.role === "ADMIN") {
  show admin button
}
```

Only UX.

Backend MUST validate.

Example:

```java
@PreAuthorize("hasRole('ADMIN')")
```

or service-level authorization checks.

---

# Ownership Validation

Critical rule:

resource ownership must always be verified.

Examples:

```text
tenant can only view own bookings
landlord can only edit own motels
landlord can only manage own rooms
user can only update own profile
```

---

Example:

Bad:

```java
bookingRepository.findById(id)
```

then update directly.

Attack:

user changes:

```text
/bookings/999
```

to access another user's booking.

---

Good:

```java
bookingRepository.findByIdAndUserId(id, currentUserId)
```

or explicit ownership validation.

---

# IDOR Prevention

IDOR:

```text
Insecure Direct Object Reference
```

Example attack:

```text
GET /users/10
GET /users/11
GET /users/12
```

User enumerates other accounts.

Prevent by:

```text
ownership checks
role checks
scoped queries
```

Never trust raw IDs.

---

# Horizontal Privilege Escalation

Definition:

user accesses another user's same-level resources.

Example:

tenant accesses another tenant booking.

Prevent with:

```text
ownership validation
scoped repository queries
```

---

# Vertical Privilege Escalation

Definition:

low privilege acts like higher privilege.

Example:

tenant calls:

```text
/admin/users
```

Prevent with:

```text
RBAC
method security
backend authorization checks
```

---

# DTO Security Rules

DTOs are security boundaries.

Never bind entities directly from request.

Bad:

```java
public ResponseEntity<?> create(@RequestBody User user)
```

Danger:

mass assignment.

---

Attack:

client sends:

```json
{
  "email": "x@test.com",
  "password": "123",
  "role": "ADMIN",
  "isDeleted": false
}
```

If entity binds directly:

catastrophic.

---

Good:

explicit DTO:

```java
RegisterRequest
```

Only allowed fields.

---

# Mass Assignment Protection

Never expose sensitive writable fields.

Examples:

forbidden from public DTOs:

```text
role
status
isDeleted
subscriptionLevel
paymentStatus
createdAt
updatedAt
passwordHash
```

Client must never control system fields.

---

# Input Validation Rules

Validate ALL external input.

Sources:

```text
request body
path variables
query params
multipart uploads
headers (when relevant)
```

Never trust client payload.

---

# Bean Validation Rules

Use:

```text
jakarta validation
```

Examples:

```java
@NotBlank
@NotNull
@Email
@Size
@Min
@Max
@Pattern
@Positive
```

---

Example:

```java
@NotBlank
@Email
private String email;
```

---

# Business Validation Rules

DTO validation is NOT enough.

Need domain validation.

Examples:

```text
room exists?
room available?
booking state valid?
user owns motel?
subscription active?
coupon expired?
```

Business validation belongs in services.

---

# Path Variable Validation

Validate IDs.

Bad:

```java
@GetMapping("/{id}")
```

without validation.

Good:

```java
@Positive Long id
```

Prevent invalid input abuse.

---

# Query Parameter Validation

Examples:

pagination:

```java
@Min(0)
page
```

```java
@Min(1)
@Max(100)
size
```

Sorting whitelist.

Never trust raw sort strings blindly.

---

# File Upload Security

Uploads are dangerous.

Threats:

```text
malware
oversized files
path traversal
fake mime types
script uploads
storage abuse
```

---

# Upload Validation Rules

Validate:

```text
content type
extension
size
filename
scan policy (optional)
```

Allowed examples:

```text
jpg
jpeg
png
webp
```

Reject:

```text
exe
sh
php
jsp
js
html
svg (optional caution)
```

---

# File Size Limits

Set explicit limits.

Example:

```text
5MB per image
```

Never unlimited uploads.

---

# Filename Rules

Never trust client filename.

Bad:

```text
../../../system/file
```

Generate safe names:

```text
UUID
hash-based
timestamp-based
```

---

# Storage Rules

Preferred:

```text
Cloudinary / object storage
```

Avoid public executable server directories.

---

# CORS Security

CORS is NOT auth.

Purpose:

browser origin control.

---

Bad:

```text
*
```

with credentials.

Dangerous.

---

Good:

explicit origins.

Example:

```env
ALLOWED_ORIGINS=http://localhost:3000
```

Production:

exact frontend domain only.

---

# Allowed Methods

Whitelist:

```text
GET
POST
PUT
PATCH
DELETE
OPTIONS
```

Only required methods.

---

# Allowed Headers

Whitelist:

```text
Authorization
Content-Type
Accept
```

Only needed headers.

---

# Credentials Policy

If using cookies:

```text
allowCredentials=true
```

Then NEVER wildcard origins.

---

# CSRF Rules

If auth uses:

```text
httpOnly cookies
```

CSRF matters.

Mitigate:

```text
SameSite
CSRF tokens
strict origin policy
```

---

If pure Bearer token in Authorization header:

CSRF risk lower.

Still evaluate architecture carefully.

---

# SQL Injection Prevention

Mandatory:

parameterized queries only.

Safe:

```text
JPA repository methods
prepared statements
Criteria API
Specification
```

Danger:

string concatenation queries.

Bad:

```java
"SELECT * FROM users WHERE email='" + email + "'"
```

Never.

---

# JPQL Safety

Even custom JPQL:

use parameters.

Good:

```java
@Query("SELECT u FROM User u WHERE u.email = :email")
```

---

# Native Query Safety

Use only when necessary.

Always parameterized.

---

# Sort Injection Prevention

Never trust:

```text
?sort=passwordHash
```

Whitelist allowed fields.

Example:

```text
price
createdAt
rating
```

Reject arbitrary field names.

---
# XSS Protection

XSS:

```text
Cross Site Scripting
```

Attack:

malicious script executes in victim browser.

Examples:

```text
stored XSS
reflected XSS
DOM XSS
```

Threats:

```text
token theft
session hijacking
credential theft
defacement
malicious redirects
```

---

# Stored XSS Risk In RoomHub

High-risk user inputs:

```text
reviews
blog comments
profile bio
motel description
room description
post description
support messages
```

User-generated content is dangerous.

---

# XSS Mitigation Rules

Required:

```text
input validation
output encoding
HTML sanitization
CSP headers
safe frontend rendering
```

---

# Dangerous Frontend Pattern

Bad:

```tsx
dangerouslySetInnerHTML
```

Avoid unless sanitized.

---

# HTML Sanitization

If rich text is allowed:

sanitize server-side.

Allowed tags whitelist only.

Example:

```text
b
i
strong
em
ul
li
p
```

Reject scripts.

Never allow:

```text
script
iframe
object
embed
onerror
onclick
javascript:
```

---

# Output Encoding

Never render raw user content directly.

Escape:

```text
<
>
"
'
&
```

Frontend frameworks help, but do not assume full safety.

---

# Content Security Policy

Recommended headers:

```text
Content-Security-Policy
```

Example policy:

```text
default-src 'self';
img-src 'self' https:;
script-src 'self';
style-src 'self' 'unsafe-inline';
```

Adjust for Cloudinary/CDN usage.

---

# Security Headers

Recommended response headers:

```text
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
Referrer-Policy: strict-origin-when-cross-origin
Permissions-Policy
Content-Security-Policy
```

---

# Clickjacking Protection

Prevent iframe embedding.

Use:

```text
X-Frame-Options: DENY
```

or CSP frame-ancestors.

---

# MIME Sniffing Protection

Use:

```text
X-Content-Type-Options: nosniff
```

Prevents browser MIME guessing.

---

# Sensitive Data Exposure

Never expose:

```text
password hashes
refresh tokens
internal stack traces
SQL errors
secret keys
payment provider secrets
admin-only data
```

---

# DTO Response Rules

Response DTOs must expose only safe fields.

Bad:

```json
{
  "passwordHash": "...",
  "refreshToken": "..."
}
```

Forbidden.

---

Good:

```json
{
  "id": 1,
  "name": "John",
  "email": "john@test.com"
}
```

---

# Error Message Security

Production errors must NOT leak internals.

Bad:

```text
SQLSyntaxErrorException at line ...
```

Bad:

```text
NullPointerException ...
```

Good:

```text
Internal server error
```

Detailed logs stay server-side only.

---

# Logging Security

Logs are sensitive.

Never log:

```text
passwords
JWTs
refresh tokens
payment secrets
full card data
sensitive personal data
```

---

Bad:

```java
log.info("login token {}", token)
```

Forbidden.

---

# Audit Logging

Log important security actions.

Examples:

```text
login success
login failure
password reset
role changes
account lock
payment attempts
admin actions
suspicious access
```

---

Recommended fields:

```text
user_id
action
ip
timestamp
entity
entity_id
```

---

# Rate Limiting

Protect abuse-prone endpoints.

High-risk:

```text
/auth/login
/auth/register
/auth/refresh
/password-reset
/payment callbacks
file uploads
search endpoints
```

---

Example policies:

Login:

```text
5 requests / 15 minutes / IP
```

Refresh:

```text
10 requests / 15 minutes
```

Uploads:

```text
strict quota
```

---

# Credential Stuffing Defense

Mitigate automated login abuse.

Controls:

```text
rate limiting
temporary lockout
IP throttling
device fingerprint (optional)
captcha (optional)
```

---

# Password Reset Security

If implemented:

Rules:

```text
single-use token
short expiry
server validation
invalidate after use
```

Recommended:

```text
15 minutes expiry
```

Never:

predictable reset tokens.

---

# Email Verification Security

If email verification exists:

Rules:

```text
signed token
short expiry
single use
```

Prevent replay.

---

# Secrets Management

Secrets belong in environment variables.

Examples:

```env
JWT_SECRET=
DB_PASSWORD=
CLOUDINARY_SECRET=
VNPAY_SECRET=
MAIL_PASSWORD=
```

Never hardcode secrets.

---

# Secret Rotation

Production secrets should be rotatable.

Especially:

```text
JWT secrets
payment secrets
API keys
mail credentials
```

---

# Git Security

Never commit:

```text
.env
application-prod.properties
real credentials
private keys
service account files
```

Required:

```gitignore
.env
*.pem
*.key
```

---

# Payment Security

Payment endpoints are high risk.

Rules:

```text
server-side verification only
signed callback validation
idempotency checks
status verification
```

Never trust frontend payment success claims.

---

# Payment Callback Validation

Must verify:

```text
provider signature
transaction reference
amount
currency
status
duplicate callback
```

---

Bad:

frontend says:

```text
payment success
```

backend trusts it.

Forbidden.

---

# Idempotency Rules

Critical for payments/bookings.

Prevent duplicate processing.

Example:

same callback arrives twice.

System must NOT:

```text
charge twice
activate twice
create duplicate subscription
```

Use:

```text
unique transaction IDs
processed flags
transaction checks
```

---

# Transaction Safety

Critical operations require transactions.

Examples:

```text
booking confirmation
payment activation
subscription creation
refund flows
```

Use:

```java
@Transactional
```

---

# Race Condition Prevention

Threats:

```text
double booking
duplicate payments
concurrent state corruption
```

Mitigations:

```text
database constraints
locking
transaction isolation
optimistic locking where appropriate
```

---

# Database Constraint Security

Enforce invariants in DB too.

Examples:

```text
unique email
unique coupon code
foreign keys
status constraints
non-negative price
```

App logic alone is insufficient.

---

# API Enumeration Protection

Avoid exposing predictable enumeration surfaces.

Examples:

```text
sequential user IDs
admin-only counters
verbose existence checks
```

Mitigate with:

```text
authorization
generic responses
ownership checks
UUID where useful
```

---

# Search Abuse Protection

Search endpoints can be abused.

Protect:

```text
pagination limits
rate limiting
query length caps
sort whitelist
cache where appropriate
```

---

# File Upload Malware Risk

Optional advanced:

virus scanning before persistence.

If unavailable:

strict file type policy.

---

# Backup Security

Backups contain sensitive data.

Rules:

```text
encrypted storage
restricted access
retention policy
restore testing
```

---

# Deployment Security

Production requirements:

```text
HTTPS only
secure headers
production env configs
debug disabled
restricted DB access
least privilege credentials
```

---

# Database Access Security

Production DB user should NOT be root.

Create limited DB account.

Avoid:

```text
full superuser app credentials
```

---

# Admin Security

Admin endpoints require extra protection.

Recommendations:

```text
strict RBAC
audit logs
optional MFA
IP restriction (optional)
enhanced monitoring
```

---

# Monitoring & Alerting

Monitor:

```text
failed logins
suspicious API spikes
payment failures
unexpected exceptions
auth anomalies
```

---

# Dependency Security

Dependencies can introduce vulnerabilities.

Rules:

```text
keep dependencies updated
remove unused libraries
audit vulnerable packages
```

Examples:

```text
npm audit
mvn dependency-check
```

---

# Production Build Rules

Frontend:

```text
production optimized build
no debug configs
no exposed secrets
```

Backend:

```text
prod profile only
debug disabled
safe logging
```

---

# Security Testing Checklist

Must test:

```text
auth bypass
RBAC bypass
IDOR
SQL injection
XSS
file upload abuse
rate limit behavior
token expiration
refresh token replay
payment replay
```

---

# AI Security Enforcement Rules

AI-generated code MUST NOT:

```text
store plaintext passwords
store raw refresh tokens
disable auth checks
trust frontend roles
build raw SQL concatenation
accept unrestricted uploads
return sensitive DTO fields
hardcode secrets
disable validation
```

---

# Security Source Of Truth

This document governs:

```text
authentication
authorization
token handling
RBAC
validation
upload security
payment security
deployment hardening
logging security
frontend security
backend security
```

All RoomHub implementations must comply.

---
