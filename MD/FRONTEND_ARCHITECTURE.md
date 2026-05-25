# RoomHub Frontend Structure Guide

I want all UI labels, card titles, and inventory-related text to be displayed in Vietnamese, as this system is specifically designed for Vietnamese users.

Frontend Structure and Style Guide for AI Implementation
1. Purpose of This Guide
This guide defines the required architecture and styling mindset for generating frontend code that matches this project.

Use this document as a strict implementation reference for any AI assistant.

The goal is not to produce generic UI.
The goal is to produce maintainable, role-aware, route-structured, production-style frontend code aligned with this repository.

2. Core Tech Stack and UI Philosophy
Stack
Next.js App Router with TypeScript
NextAuth-based authentication/session flow
Ant Design for enterprise UI building blocks
Tailwind CSS for layout utilities, spacing, and visual tuning
Google font variables integrated through root layout
Philosophy
Build by architecture first, visuals second
Keep UI practical and operational, not decorative
Prioritize predictable navigation, clear information hierarchy, and maintainable module boundaries
3. Route Groups and Responsibility Boundaries
The application is split into route groups with distinct responsibilities:

Public (root) area
Marketing and product explanation pages
Section-based composition from multiple reusable blocks
Uses a main layout shell with header and footer
Guest area
Authentication and onboarding-related routes
Minimal distractions and high task completion focus
Form clarity and direct actions are prioritized
Admin area
Dashboard and management operations
Persistent shell structure:
Sidebar
Header
Content
Footer
Role/status/package-aware navigation and action visibility
Never mix these concerns in one generic layout.

4. Layout Architecture Rules
Global app layout
Registers fonts and global wrappers/providers
Handles application-wide concerns only
Should not contain feature-specific business logic
Public main layout
Vertical shell:
Header
Main content area
Optional footer
Must support full-height page behavior
Public pages should feel readable and content-oriented
Admin dashboard layout
Two-column dashboard shell:
Left: collapsible sidebar navigation
Right: header + content + footer
Content area must preserve stable padding and minimum height
Shell behavior must stay consistent across all admin pages
5. Feature-Based Folder Organization
Organize by business domain, not by generic technical layer.

Preferred structure per feature:

UI components
request/API functions
types/interfaces
optional local assets (SVGs, constants, helpers)
Page files should orchestrate composition, not host heavy logic.

Do not create monolithic files that combine:

API calls
role logic
modal state
table rendering
form validation
in one place.
6. Rendering Strategy: Server vs Client Components
Default rule
Use Server Components unless client interactivity is required.

Use Client Components when needed for:
local state
effects
click handlers
dropdown/modal toggles
browser-only behavior
Boundary guideline
Keep client islands focused and small.
Avoid converting entire pages to client mode when only one interactive block needs it.

7. Styling System Contract
Ant Design responsibilities
Use for:

Layout shell in admin context
Menu, Dropdown, Modal, Form, Table, Result, and enterprise controls
Accessible and consistent interaction behavior
Tailwind responsibilities
Use for:

Spacing rhythm
Flex/grid positioning
Width/height control
Utility-level responsive adjustments
Minor visual refinements around Ant components
Font and design tokens
Respect configured font families and CSS variable integration
Keep typography hierarchy consistent between headings, body text, labels, and metadata
Do not override Ant Design aggressively.
Enhance with Tailwind, do not fight component internals.

8. Visual Language and Style Direction
Required style direction
Clean
Light-background oriented
Structured
Readable
Enterprise-practical
Public page style
Section-based flow with clear narrative:
Introduction
Value proposition
Features/benefits
How it works
Trust/reviews
Consistent spacing between sections
Comfortable line lengths and readable typography
Admin page style
Information density with clarity
Neutral content canvas for tables/forms/cards
Predictable component placement for frequent tasks
Strong action hierarchy for primary vs secondary operations
Avoid
Random template aesthetics
Overly flashy gradients and decorative noise
Inconsistent spacing or ad-hoc typography scaling
9. Role, Status, and Permission-Aware UI Rules
Admin navigation and actions must be driven by user context:

user role
account status
package/feature permissions
Behavior requirements:

Hide unsupported menu items
Prevent unavailable actions from appearing clickable
Compute access before final render whenever possible
Keep menu order deterministic after filtering
Permission logic should be centralized enough to stay maintainable and testable.

10. Data and Request Layer Conventions
Request handling
Put backend calls in dedicated request/helper files
Keep UI components focused on rendering and interaction
Use typed responses and safe optional access
Interaction flow conventions
For detail/update operations:
open modal
load needed data
show state clearly
submit
refresh affected UI
Handle loading, empty, and error states explicitly
Do not scatter API logic across multiple unrelated UI files.

11. Component Design Standards
Component categories
Shell components: page skeleton and persistent layout parts
Section components: structured chunks for public pages
Shared primitives: buttons, compact controls, reusable blocks
Feature components: modals, selectors, tables, feature-specific forms
Props and naming
Use explicit and predictable prop names
Keep component interfaces narrow
Pass only required data, not whole large response objects by default
State strategy
Local state for local UI concerns
Avoid unnecessary global state for simple modal/toggle behavior
12. Responsive Behavior Expectations
Public and guest pages
Must adapt cleanly to mobile and tablet
Section stacking should remain readable
No clipped content or hidden primary actions
Admin pages
Desktop-first, but must remain operable on smaller widths
Sidebar behavior should degrade gracefully
Header actions must remain reachable
13. Quality Checklist for AI-Generated Output
Before accepting generated code, verify:

Correct route group placement
Correct layout shell usage for that route type
Correct server/client boundary
API logic separated from visual layer
Permission-aware rendering applied where needed
Stable loading/empty/error states
Consistent spacing and typography rhythm
Responsive behavior on major breakpoints
Naming and folder structure aligned with current repository conventions
14. Strict Do and Do Not
Do
Compose pages from focused components
Keep dashboard shell consistent
Reuse patterns already present in the project
Keep code easy to extend by module
Do Not
Mix public and admin shell logic
Build giant single-file pages
Introduce a second design system
Add style experiments that break visual consistency
Ignore role/status/package conditions in admin UI
15. Reusable Prompt for Other AI Tools
Use this prompt when asking another AI to implement frontend features in this repository:

You are implementing a Next.js TypeScript frontend in an existing production-style codebase.
Follow these hard constraints:

Respect App Router route groups and separate public, guest, and admin responsibilities.
Use the existing dashboard shell pattern for admin pages: sidebar, header, content, footer.
Use Ant Design for enterprise interaction components and Tailwind for spacing/layout utilities.
Keep pages compositional; avoid monolithic page files.
Keep API calls in request/helper files with typed handling.
Enforce role/status/package-aware rendering for admin navigation and actions.
Match the current clean, light, readable visual language.
Ensure responsive behavior for desktop and mobile.
Keep naming, folder placement, and implementation style aligned with the existing project.
Return:

file-by-file implementation plan
final code per file
concise rationale for architecture and UI decisions
Production-style frontend architecture rules for RoomHub.

This document defines the official frontend structure.

Purpose:

- prevent chaotic frontend growth
- keep AI-generated code consistent
- enforce scalable architecture
- separate UI concerns
- standardize component organization
- improve maintainability
- align frontend with backend API contracts

This file is frontend source of truth.

---

# Official Frontend Stack

Primary stack:

```text
Next.js 15+
React 19+
TypeScript
Tailwind CSS
Shadcn UI
React Hook Form
Zod
Axios
TanStack Query
Zustand
```

Optional:

```text
Framer Motion
next-themes
react-hot-toast
lucide-react
```

---

# Why Next.js

RoomHub is not a simple SPA.

Need:

- SEO for public listings
- server rendering
- hybrid rendering
- optimized routing
- better performance
- scalable architecture

Benefits:

```text
SSR
SSG
ISR
API routes (optional)
image optimization
layout system
metadata handling
```

Good for production-like graduation project.

---

# Architecture Philosophy

Frontend follows:

```text
Feature-driven modular architecture
```

NOT:

```text
flat component dumping
```

Reason:

large applications become impossible to maintain otherwise.

---

# Core Principles

Mandatory:

- separation of concerns
- reusable UI
- smart business hooks
- thin page components
- API abstraction
- schema validation
- centralized auth state
- predictable folder ownership
- DTO-aligned frontend models
- no business logic inside dumb UI components

---

# Official App Structure

App Router architecture:

```text
src
│
├── app
├── components
├── features
├── services
├── lib
├── hooks
├── store
├── types
├── constants
├── schemas
├── providers
├── utils
├── config
└── styles
```

Mandatory structure.

---

# Why This Structure

Bad:

```text
components/
everything dumped here
```

Example disaster:

```text
Login.tsx
RoomCard.tsx
PaymentLogic.tsx
ApiCall.tsx
AdminDashboard.tsx
```

100+ mixed files.

Maintenance nightmare.

---

Good:

clear separation.

Example:

```text
features/auth
features/bookings
features/rooms
```

Each feature owns its logic.

Scalable.

---

# App Folder

Folder:

```text
src/app
```

Purpose:

Next.js routing system.

Contains:

```text
layout.tsx
page.tsx
loading.tsx
error.tsx
not-found.tsx
```

Feature routes:

```text
(auth)
(admin)
dashboard
rooms
posts
bookings
```

---

Example:

```text
src/app
├── layout.tsx
├── page.tsx
├── (auth)
│   ├── login
│   └── register
│
├── rooms
├── posts
├── motels
├── bookings
├── profile
└── admin
```

---

# Route Group Strategy

Use route groups:

Example:

```text
(auth)
(public)
(dashboard)
(admin)
```

Benefits:

layout separation.

Example:

public users:

```text
marketing layout
```

auth pages:

```text
minimal layout
```

admin:

```text
sidebar layout
```

---

# Components Layer

Folder:

```text
components
```

Purpose:

shared reusable presentation components.

Structure:

```text
components
├── ui
├── layout
├── shared
└── feedback
```

---

# components/ui

Pure reusable primitives.

Examples:

```text
Button
Input
Textarea
Dialog
Dropdown
Badge
Card
Table
Pagination
Skeleton
```

Rules:

NO business logic.

Only UI.

---

# components/layout

Layout-level reusable components.

Examples:

```text
Navbar
Footer
Sidebar
Header
Breadcrumbs
MobileMenu
```

---

# components/shared

Cross-feature reusable components.

Examples:

```text
RoomCard
PostCard
EmptyState
SearchBar
AvatarUploader
ConfirmDialog
```

These may accept domain props.

Still reusable.

---

# components/feedback

UX messaging components.

Examples:

```text
LoadingSpinner
ErrorState
SuccessBanner
NotFoundState
UnauthorizedState
```

---

# Features Layer

Most important layer.

Folder:

```text
features
```

Purpose:

feature ownership.

Structure:

```text
features
├── auth
├── users
├── motels
├── rooms
├── posts
├── favorites
├── bookings
├── reviews
├── payments
├── admin
```

Each feature owns:

- business hooks
- feature components
- forms
- API adapters (optional)
- DTO mapping

---
# Feature Module Standard

Each business feature owns its logic.

Standard:

```text
features/<feature-name>
├── api
├── components
├── hooks
├── schemas
├── types
└── utils
```

Optional:

```text
constants
state
mappers
```

Rule:

feature owns its own domain logic.

---

# Why Feature Ownership

Bad:

```text
all API in one file
all hooks in one folder
all forms mixed together
```

Becomes impossible to scale.

Good:

```text
features/auth
features/bookings
features/payments
```

Each feature self-contained.

---

# Auth Feature Structure

Official structure:

```text
features/auth
├── api
│   └── auth.api.ts
│
├── components
│   ├── LoginForm.tsx
│   ├── RegisterForm.tsx
│   └── AuthGuard.tsx
│
├── hooks
│   ├── useLogin.ts
│   ├── useRegister.ts
│   ├── useRefreshToken.ts
│   └── useLogout.ts
│
├── schemas
│   ├── login.schema.ts
│   └── register.schema.ts
│
├── types
│   ├── auth.types.ts
│   └── auth.dto.ts
│
└── utils
```

Responsibilities:

- authentication workflows
- auth forms
- token lifecycle
- auth guards

---

# Auth Responsibilities

Handles:

```text
login
register
refresh token
logout
session restore
protected route checks
```

Must NOT handle:

```text
room business logic
booking workflows
payments
```

---

# Users Feature Structure

```text
features/users
├── api
├── components
├── hooks
├── schemas
├── types
└── utils
```

Examples:

```text
ProfileForm
AvatarUploader
useProfile
useUpdateProfile
```

Responsibilities:

- profile
- account settings
- personal info updates

---

# Motels Feature Structure

```text
features/motels
├── api
├── components
├── hooks
├── schemas
├── types
└── utils
```

Examples:

```text
MotelForm
MotelCard
MotelGallery
useMotels
useCreateMotel
```

Responsibilities:

landlord property management.

---

# Rooms Feature Structure

```text
features/rooms
├── api
├── components
├── hooks
├── schemas
├── types
└── utils
```

Examples:

```text
RoomForm
RoomCard
RoomStatusBadge
useRooms
useUpdateRoom
```

Responsibilities:

room inventory management.

---

# Posts Feature Structure

```text
features/posts
├── api
├── components
├── hooks
├── schemas
├── types
└── utils
```

Examples:

```text
PostCard
PostSearchFilters
BoostButton
PostForm
```

Responsibilities:

public listings.

---

# Favorites Feature Structure

```text
features/favorites
├── api
├── hooks
├── types
```

Responsibilities:

tenant saved listings.

---

# Bookings Feature Structure

Critical workflow feature.

Structure:

```text
features/bookings
├── api
├── components
├── hooks
├── schemas
├── types
└── utils
```

Examples:

```text
BookingRequestForm
BookingStatusBadge
BookingTimeline
useBookings
useApproveBooking
```

Responsibilities:

booking workflow lifecycle.

---

# Reviews Feature Structure

```text
features/reviews
├── api
├── components
├── hooks
├── schemas
├── types
```

Responsibilities:

verified reviews.

---

# Payments Feature Structure

Financial feature.

Structure:

```text
features/payments
├── api
├── components
├── hooks
├── schemas
├── types
└── utils
```

Examples:

```text
PaymentButton
CheckoutSummary
CouponInput
SubscriptionCard
```

Responsibilities:

payments + subscriptions.

---

# Admin Feature Structure

Admin can be large.

Structure:

```text
features/admin
├── api
├── components
├── hooks
├── schemas
├── types
└── utils
```

Examples:

```text
AdminSidebar
ModerationTable
AnalyticsCards
ReportQueue
```

Responsibilities:

platform management.

---

# API Layer

Folder:

```text
services
```

Purpose:

central HTTP abstraction.

Structure:

```text
services
├── api-client.ts
├── auth-client.ts
└── interceptors.ts
```

---

# api-client.ts

Purpose:

central axios instance.

Contains:

```text
baseURL
timeout
headers
credentials
```

Example:

```ts
axios.create()
```

Responsibilities:

single HTTP configuration source.

---

# Interceptors

Purpose:

cross-cutting request/response handling.

Examples:

```text
attach access token
handle 401
trigger refresh
normalize errors
```

Rule:

NO business UI logic.

---

# Feature API Files

Example:

```text
features/auth/api/auth.api.ts
```

Purpose:

feature-specific backend calls.

Example:

```ts
login()
register()
logout()
refresh()
```

Do NOT call axios directly inside UI components.

Bad:

```tsx
const onSubmit = async () => {
  await axios.post(...)
}
```

Wrong.

---

Good:

```tsx
await authApi.login(data)
```

---
# State Management Strategy

RoomHub uses layered frontend state management.

NOT everything in one store.

Official split:

```text
Server state → TanStack Query
Client UI state → Zustand
Form state → React Hook Form
Validation → Zod
```

Reason:

each tool solves different problems.

---

# Why Not Put Everything In Zustand

Bad pattern:

```text
fetch API data
cache data
store auth
store modal
store forms
store loading
```

inside one mega store.

Problems:

- stale cache
- duplicated fetch logic
- race conditions
- hard debugging
- poor scalability

Wrong architecture.

---

# TanStack Query Strategy

Use React Query for:

```text
backend API data
pagination
cache
refetch
mutation
invalidation
background refresh
optimistic updates
```

Examples:

```text
rooms
posts
bookings
profile
reviews
admin analytics
payments
```

---

Good:

```ts
useQuery({
  queryKey: ["posts", filters],
  queryFn: fetchPosts
})
```

---

# Query Key Convention

Mandatory naming:

```text
["auth", "me"]
["posts"]
["posts", filters]
["rooms", motelId]
["bookings", "tenant"]
["bookings", "landlord"]
["admin", "users"]
```

Stable naming only.

---

# Mutation Strategy

Examples:

```text
create motel
update profile
approve booking
boost post
payment checkout
```

Use:

```ts
useMutation()
```

After success:

invalidate relevant cache.

Example:

```ts
queryClient.invalidateQueries({
  queryKey: ["bookings"]
})
```

---

# Zustand Strategy

Use Zustand ONLY for client state.

Examples:

```text
auth session
theme
mobile sidebar
modal state
temporary UI selections
wizard state
```

NOT server API cache.

---

# Store Structure

Official:

```text
store
├── auth.store.ts
├── ui.store.ts
└── app.store.ts
```

Optional:

```text
booking-wizard.store.ts
```

---

# Auth Store

Purpose:

session state.

Example:

```text
access token
user
isAuthenticated
session hydration
logout state
```

Example:

```ts
auth.store.ts
```

Contains:

```ts
login()
logout()
setUser()
hydrateSession()
```

---

# UI Store

Purpose:

UI-only state.

Examples:

```text
sidebar open
dialog visibility
theme toggles
mobile nav
```

No business API logic.

---

# Form Strategy

Official stack:

```text
React Hook Form + Zod
```

Reason:

performance
type safety
clean validation
scalability

---

# Form Folder Strategy

Forms belong to features.

Example:

```text
features/auth/components/LoginForm.tsx
features/rooms/components/RoomForm.tsx
features/bookings/components/BookingRequestForm.tsx
```

Schemas:

```text
features/auth/schemas/login.schema.ts
```

---

# Validation Strategy

Validation layers:

Layer 1:

frontend UX validation.

Examples:

```text
required
email format
password min length
confirm password match
```

Layer 2:

backend source-of-truth validation.

Never trust frontend only.

---

Example schema:

```ts
const loginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(8)
});
```

---

# DTO Typing Rules

Frontend types MUST mirror backend contracts.

Source:

```text
API_CONTRACT.md
```

Example:

```ts
LoginRequest
LoginResponse
UserProfileResponse
BookingResponse
```

Never invent random shapes.

Bad:

```ts
type User = any
```

Forbidden.

---

Good:

```ts
interface LoginResponse {
  accessToken: string;
  refreshToken: string;
  user: UserProfile;
}
```

---

# Types Folder Strategy

Global shared types:

```text
types
```

Examples:

```text
api.types.ts
pagination.types.ts
common.types.ts
```

Feature-specific:

inside feature.

Example:

```text
features/bookings/types/booking.types.ts
```

---

# API Response Typing

Backend standard:

```json
{
  "success": true,
  "message": "Success",
  "data": {}
}
```

Frontend shared type:

```ts
ApiResponse<T>
```

Example:

```ts
interface ApiResponse<T> {
  success: boolean;
  message: string;
  data: T;
}
```

---

# Error Handling Strategy

Normalize backend errors.

Never scatter:

```ts
error.response?.data?.message
```

everywhere.

Create helper:

```text
lib/error.ts
```

Purpose:

centralized parsing.

---

Example:

```ts
extractApiErrorMessage()
```

---

# Loading State Strategy

Avoid manual booleans everywhere.

Bad:

```ts
const [loading, setLoading] = useState(false)
```

for every fetch.

Prefer:

React Query state:

```ts
isLoading
isPending
isFetching
```

---

# Notification Strategy

Recommended:

```text
react-hot-toast
```

Examples:

```text
login success
booking approved
payment failed
upload complete
```

Centralized UX messaging.

---

# Environment Configuration

Folder:

```text
config
```

Example:

```text
env.ts
api.ts
```

---

Variables:

```env
NEXT_PUBLIC_API_BASE_URL=
NEXT_PUBLIC_APP_NAME=
NEXT_PUBLIC_CLOUDINARY_CLOUD_NAME=
```

Rules:

Secrets NEVER exposed in NEXT_PUBLIC.

---

# Utility Layer

Folder:

```text
utils
```

Examples:

```text
formatCurrency.ts
formatDate.ts
slugify.ts
truncate.ts
```

Pure helpers only.

No API calls.

---
# Authentication Architecture

RoomHub authentication must be production-style.

Architecture:

```text
JWT Access Token + Refresh Token
```

Frontend responsibilities:

- login
- store session state
- attach access token
- refresh expired token
- logout
- route protection
- hydration

Backend remains source of truth.

---

# Auth Flow

Official flow:

```text
1. user submits login form
2. frontend validates input
3. frontend calls backend login API
4. backend verifies credentials
5. backend returns access token + refresh token + user profile
6. frontend stores session state
7. frontend attaches access token to protected requests
8. if access token expires:
   frontend requests refresh token
9. backend validates refresh token
10. backend returns new access token
```

---

# Login Flow

Example:

```text
LoginForm
   ↓
useLogin()
   ↓
authApi.login()
   ↓
backend /auth/login
   ↓
store token + user
   ↓
redirect
```

---

# Refresh Token Strategy

Access token:

```text
short-lived
```

Example:

```text
15 minutes
```

Refresh token:

```text
long-lived
```

Example:

```text
7 days
30 days
```

Reason:

security + usability balance.

---

# Token Storage Strategy

Recommended:

Access token:

```text
memory (Zustand)
```

Refresh token:

```text
httpOnly secure cookie
```

Reason:

best security.

Avoid:

```text
localStorage refresh token
```

because XSS risk.

---

# Axios Interceptor Flow

Request interceptor:

Responsibilities:

```text
attach access token
set headers
```

Example:

```ts
Authorization: Bearer xxx
```

---

Response interceptor:

Responsibilities:

```text
detect 401
attempt refresh
retry original request
force logout if refresh fails
```

Flow:

```text
request
 ↓
401
 ↓
refresh token call
 ↓
new access token
 ↓
retry request
```

---

# Auth Store Shape

Example:

```ts
interface AuthState {
  user: UserProfile | null;
  accessToken: string | null;
  isAuthenticated: boolean;

  login: (payload) => void;
  logout: () => void;
  setUser: () => void;
  hydrateSession: () => Promise<void>;
}
```

---

# Route Protection Strategy

Protected pages:

Examples:

```text
/profile
/dashboard
/bookings
/landlord/*
/admin/*
```

Public pages:

```text
/
/posts
/rooms
/login
/register
/blog
```

---

# Protection Layers

Layer 1:

frontend route protection.

Layer 2:

backend authorization.

Frontend protection is UX only.

Backend is security.

Never trust frontend alone.

---

# Middleware Strategy

Use:

```text
middleware.ts
```

Purpose:

route-level access control.

Examples:

```text
redirect guest from dashboard
redirect logged-in user from login page
role-aware route protection
```

---

Example:

Guest visits:

```text
/dashboard
```

Middleware:

```text
redirect -> /login
```

---

# Role-Based Frontend Access

Roles:

```text
TENANT
LANDLORD
ADMIN
```

Examples:

TENANT:

```text
booking pages
favorites
profile
```

LANDLORD:

```text
motels
rooms
posts
payments
analytics
```

ADMIN:

```text
moderation
dashboard
reports
users
```

---

# Role Guard Strategy

Reusable component:

```text
RoleGuard.tsx
```

Purpose:

conditional UI rendering.

Example:

```tsx
<RoleGuard allow={["ADMIN"]}>
   <AdminPanel />
</RoleGuard>
```

UX helper only.

Backend still enforces permissions.

---

# Layout Architecture

Use nested layouts.

Example:

```text
src/app
├── layout.tsx
├── (public)/layout.tsx
├── (auth)/layout.tsx
├── (dashboard)/layout.tsx
└── (admin)/layout.tsx
```

---

# Layout Responsibilities

Public layout:

```text
navbar
footer
marketing UI
```

Auth layout:

```text
minimal centered auth pages
```

Dashboard layout:

```text
landlord sidebar
header
workspace shell
```

Admin layout:

```text
admin navigation
management shell
```

---

# SSR vs CSR Strategy

Use intentionally.

SSR for:

```text
public listings
SEO pages
blogs
landing pages
post detail pages
```

CSR for:

```text
dashboard
forms
auth pages
interactive user pages
```

Hybrid architecture preferred.

---

# Server Components

Use by default when possible.

Good for:

```text
static rendering
initial data
SEO pages
```

Examples:

```text
homepage
public listing page
blog pages
```

---

# Client Components

Use only when needed.

Required for:

```text
state
hooks
event handlers
forms
browser APIs
```

Example:

```tsx
"use client";
```

Avoid overusing.

---

# Page Composition Rule

Pages should be thin.

Bad:

```tsx
huge page.tsx with 1000 lines
```

Wrong.

Good:

```tsx
page.tsx
   imports feature components
```

Example:

```tsx
export default function Page() {
   return <LoginForm />;
}
```

---

# Component Design Rules

Split components by responsibility.

Bad:

```text
RoomPageWithSearchFiltersAndBookingAndPaymentAndUpload.tsx
```

Disaster.

Good:

```text
RoomCard
RoomFilters
RoomGallery
BookingForm
PaymentSummary
```

---

# Smart vs Dumb Components

Dumb UI:

presentation only.

Examples:

```text
Button
Card
Badge
Input
```

Smart:

feature logic.

Examples:

```text
LoginForm
BookingRequestForm
PaymentCheckout
```

---

# Data Fetching Rule

Never fetch directly inside random components.

Bad:

```tsx
useEffect(() => {
  axios.get(...)
}, [])
```

Wrong.

Good:

```tsx
usePosts()
useBookings()
useProfile()
```

Hooks own fetch logic.

---

# Custom Hooks Strategy

Hooks folder:

```text
features/<feature>/hooks
```

Examples:

```text
useLogin
usePosts
useCreateBooking
useApproveBooking
```

Responsibilities:

```text
query
mutation
cache invalidation
error handling
```

---

# Loading UI Strategy

Every async page needs loading UX.

Use:

```text
loading.tsx
Skeleton
Spinner
```

Never blank screens.

---

# Error UI Strategy

Use:

```text
error.tsx
```

Feature-level:

```text
ErrorState component
```

Examples:

```text
network failure
unauthorized
empty state
not found
```

---

# AI Enforcement Rules

AI-generated frontend code MUST follow:

- feature modular architecture
- API_CONTRACT.md
- BACKEND_STRUCTURE.md integration assumptions
- typed DTO contracts
- React Query for server state
- Zustand for auth/UI only
- Zod validation
- reusable components
- no direct axios in components
- thin pages
- no mega components
- route guards
- middleware-based protection

Forbidden:

```text
single huge component architecture
random folder dumping
any typing
duplicated API logic
manual inconsistent fetch logic
```

---

# Frontend Source Of Truth

This document governs:

- frontend folder structure
- component boundaries
- auth implementation
- state management
- API integration
- validation strategy
- route protection
- AI-generated frontend code

All implementation must follow this standard.

---