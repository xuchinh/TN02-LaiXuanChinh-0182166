# ROOMHUB - BACKEND & API DEVELOPMENT PLAN

## Kien truc Backend Production-Level cho he thong quan ly nha tro

Dua tren:

- Phan tich he thong RoomHub
- MySQL schema production-level
- Cau truc project Spring Boot hien tai

Tai lieu nay dinh huong theo:

- Senior Backend Engineer mindset
- Production-ready architecture
- Clean architecture
- REST API best practices
- Enterprise scalability

## 1. Phan Tich Backend Architecture

### 1.1 Vai tro Backend trong RoomHub

Backend la "bo nao" cua he thong.

Nhiem vu chinh:

- Xu ly business logic
- Authentication & Authorization
- Quan ly du lieu
- Validation
- Bao mat
- Quan ly transaction
- Tra REST API cho frontend

### 1.2 Request / Response Flow

```text
React Frontend
    -> HTTP Request
Spring Boot Controller
    ->
Service Layer
    ->
Repository Layer (JPA)
    ->
MySQL Database
    ->
Response JSON
```

### 1.3 Authentication Flow

Login:

```text
Client Login
    ->
Validate credentials
    ->
Generate JWT Access Token
    ->
Generate Refresh Token
    ->
Return tokens
```

### 1.4 Authorization Flow

Su dung RBAC (Role Based Access Control).

Roles:

- `ADMIN`
- `LANDLORD`
- `TENANT`

Vi du:

- Chi `LANDLORD` duoc tao motel.
- Chi `ADMIN` duoc duyet post.

### 1.5 Vi sao chon REST API

REST phu hop do an vi:

- De hieu
- Chuan pho bien
- De debug
- Frontend React de tich hop
- Swagger ho tro tot

### 1.6 Vi sao khong dung GraphQL

GraphQL:

- Phuc tap hon
- Kho security hon
- Khong can thiet cho RoomHub
- Tang do kho bao tri

REST hop hon cho:

- CRUD-heavy systems
- Project tot nghiep
- Backend modular

### 1.7 JWT + Refresh Token

Access Token:

- Song ngan, khoang 15 phut.

Refresh Token:

- Song dai, khoang 7 ngay.

Loi ich:

- Bao mat tot hon
- Tranh login lien tuc
- Production-standard

## 2. De Xuat Tech Stack

| Thanh phan | Cong nghe |
| --- | --- |
| Backend | Spring Boot |
| Security | Spring Security + JWT |
| Database | MySQL |
| ORM | Hibernate + JPA |
| Build Tool | Maven |
| Validation | Hibernate Validator |
| Upload | Cloudinary |
| API Docs | Swagger/OpenAPI |
| Cache | Redis (optional) |

### 2.1 Vi sao chon Spring Boot

Uu diem:

- Enterprise standard
- Security manh
- JPA cuc manh
- Dependency Injection
- Production-ready

Phu hop do an vi:

- Giang vien danh gia cao
- Structure ro rang
- Backend lon de mo rong

## 3. Thiet Ke Cau Truc Thu Muc

Structure production-level:

```text
src/main/java/com/chinh/roomhub
|
+-- RoomhubApplication.java
|
+-- config
+-- security
+-- common
+-- exception
+-- utils
|
+-- auth
|   +-- controller
|   +-- service
|   +-- repository
|   +-- dto
|   +-- entity
|   +-- mapper
|
+-- users
+-- motels
+-- rooms
+-- posts
+-- bookings
+-- reviews
+-- payments
+-- packages
+-- subscriptions
```

### 3.1 Giai thich tung folder

| Folder | Vai tro |
| --- | --- |
| controller | REST endpoints |
| service | Business logic |
| repository | Database layer |
| entity | JPA entities |
| dto | Request/Response DTO |
| mapper | Convert DTO <-> Entity |
| security | JWT, filters |
| config | Bean configuration |
| exception | Error handling |

### 3.2 Vi sao scalable

Structure nay:

- Module hoa
- De maintain
- De onboarding
- De test
- De mo rong microservices

## 4. Chia Giai Doan Phat Trien

### Phase 1 - Khoi Tao Backend

Muc tieu: tao nen tang sach va chuan production.

Build:

- Setup Spring Boot
- Connect MySQL
- `application.properties`
- Global response format
- Logging
- Exception handler
- Validation config
- Swagger

API:

- `/health`

Security:

- CORS
- Hidden stacktrace

Output:

- Backend chay on dinh
- Connected database
- Swagger hoat dong

### Phase 2 - Authentication & Authorization

Build:

- Register
- Login
- JWT
- Refresh token
- Logout

APIs:

| Method | Endpoint |
| --- | --- |
| POST | `/auth/register` |
| POST | `/auth/login` |
| POST | `/auth/refresh` |
| POST | `/auth/logout` |

Validation:

- Register DTO
- Email unique
- Password >= 8 chars
- Regex password

Security:

- BCrypt hashing
- JWT expiration
- Rate limit login

Business logic:

- Default role = `TENANT`
- Verify email optional

Output:

- Auth hoan chinh
- Secure APIs

### Phase 3 - User Management

Build:

- Get profile
- Update profile
- Lock account
- User listing

APIs:

| Method | Endpoint |
| --- | --- |
| GET | `/users/me` |
| PUT | `/users/me` |
| GET | `/admin/users` |
| PATCH | `/admin/users/{id}/status` |

Logic:

- Soft delete
- Role validation
- Self-update only

### Phase 4 - Motel Management

Build:

- CRUD motel
- Upload images
- Pagination

APIs:

| Method | Endpoint |
| --- | --- |
| POST | `/motels` |
| GET | `/motels` |
| GET | `/motels/{id}` |
| PUT | `/motels/{id}` |
| DELETE | `/motels/{id}` |

Business logic:

- Ownership validation
- Only landlord can create motel
- Soft delete motel

### Phase 5 - Room Management

Build:

- CRUD room
- Room pricing
- Room status

Room status:

```text
available
rented
maintenance
```

Logic:

- Price > 0
- Capacity > 0
- Auto rented status

### Phase 6 - Posts System

Build:

- Create posts
- Moderate posts
- Boost posts

APIs:

| Method | Endpoint |
| --- | --- |
| POST | `/posts` |
| GET | `/posts` |
| PATCH | `/posts/{id}/approve` |

Logic:

- Premium package required for boost
- Pending approval before public

### Phase 7 - Search System

Build:

- Filter
- Sorting
- Pagination
- Full-text search

Filters:

- City
- District
- Price
- Area

Optimization:

- DB indexes
- Search caching

### Phase 8 - Bookings

Build:

- Booking request
- Confirm booking
- Cancel booking

Logic:

- Khong cho double booking
- Auto rented status
- Transaction handling

### Phase 9 - Reviews & Blogs

Build:

- Rating
- Comments
- Blog CRUD

Logic:

- Chi tenant da thue moi duoc review.

### Phase 10 - Payments & Packages

Build:

- Packages
- Coupon
- VNPay mock

Logic:

- Package expiration
- Boost quota
- Subscription history

### Phase 11 - Admin System

Build:

- Dashboard analytics
- Moderate content
- User reports

### Phase 12 - Security & Optimization

Security:

- Rate limiting
- XSS protection
- SQL Injection prevention
- Sanitization

Optimization:

- Query optimization
- Redis cache
- Lazy loading

## 5. Thiet Ke API Chuan REST

Naming convention:

Dung:

```text
GET /motels
POST /motels
GET /motels/{id}
```

Sai:

```text
/getMotels
/createMotel
```

Response format:

```json
{
  "success": true,
  "message": "Login successful",
  "data": {}
}
```

Status codes:

| Code | Meaning |
| --- | --- |
| 200 | Success |
| 201 | Created |
| 400 | Validation error |
| 401 | Unauthorized |
| 403 | Forbidden |
| 404 | Not found |
| 500 | Internal error |

## 6. Validation Strategy

DTO validation:

```java
@NotBlank
@Email
private String email;
```

Upload validation:

- File size
- Image type
- Sanitize filename

## 7. Error Handling

Global exception handler:

```text
@ControllerAdvice
```

Error response:

```json
{
  "success": false,
  "message": "Email already exists",
  "errors": []
}
```

## 8. Security Chuan Production

Security layers:

- Authentication: JWT
- Authorization: RBAC
- Password: BCrypt
- API Security: HTTPS, rate limiting, CORS

## 9. Database Strategy

Migration:

- Flyway hoac Liquibase

Indexing:

- Email
- City
- District
- Price

Transaction:

```java
@Transactional
```

Dung cho booking/payment.

## 10. Testing Strategy

Unit test:

- Service layer

Integration test:

- API testing

Tools:

- JUnit
- Mockito
- Postman

## 11. Deployment

Development:

- Localhost

Production:

- Docker
- Railway
- Render
- VPS

Docker strategy:

```text
Frontend Container
Backend Container
MySQL Container
```

## 12. Best Practices

Clean code:

- Method nho
- Ten ro nghia

SOLID principles:

- Single Responsibility
- Controller khong chua business logic

Reusable services:

- Upload service
- Mail service
- JWT service

## Ket Luan

Kien truc nay giup RoomHub:

- Production-level
- Scalable
- De maintain
- De bao ve do an
- Chuan enterprise mindset

Huong trien khai nay phu hop voi:

- Spring Boot
- React
- MySQL

Va dung voi cau truc project hien tai.
