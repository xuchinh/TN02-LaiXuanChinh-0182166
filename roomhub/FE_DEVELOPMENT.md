# Frontend Coding Prompt for This Project

You are working on a Next.js frontend for a property management system.  
Your job is to generate UI and code that match the architecture, layout logic, and implementation style of this project.

## 1. Project Mindset

Build the frontend as a modular, route-based, production-ready application.

Think in terms of:
- clear page shells
- route groups
- reusable components
- admin vs public vs guest separation
- server/client component boundaries
- consistent data fetching patterns
- Ant Design for complex UI shells and forms
- Tailwind CSS for spacing, layout, and visual refinement

Do not generate generic demo UI.  
Do not make the pages look like a random SaaS template.  
Keep the structure practical, enterprise-oriented, and easy to maintain.

## 2. Architecture Style

The app uses the Next.js App Router with route groups such as:
- public/root pages
- guest pages for auth
- admin dashboard pages

Follow this separation strictly:
- Public pages should use a shared main layout with header and footer.
- Guest pages should focus on auth flows with minimal distractions.
- Admin pages should use a dashboard shell with sidebar, header, content, and footer.

Each route should be implemented as a small page that composes module-specific components.  
Avoid putting too much logic directly inside page files.

## 3. Layout Rules

### Public Layout
Use a top-level layout that wraps the full page with:
- header
- main content area
- optional footer

The public landing pages should feel structured and layered, using sections stacked vertically.

### Admin Layout
Use a dashboard layout with:
- collapsible sidebar
- top header with user actions
- padded content container
- footer at the bottom

The admin shell should feel dense, functional, and information-rich, but still clean.

### Section Composition
Landing pages should be built from separate sections such as:
- intro
- solutions
- features
- benefits
- workflow
- reviews

Keep each section isolated in its own component and assemble them at the page level.

## 4. Visual Direction

The visual language should be:
- clean
- organized
- light-background oriented
- enterprise-friendly
- readable
- practical

Use:
- whitespace for hierarchy
- card-based blocks for modular content
- rounded buttons and soft shadows where appropriate
- Ant Design components for interaction-heavy parts
- Tailwind utilities for spacing, sizing, and alignment

Avoid:
- overly flashy gradients
- generic purple SaaS styling
- cluttered hero sections
- decorative elements that do not support the layout
- inconsistent typography scale

## 5. Typography and Branding

Use typography intentionally:
- headings should be strong and clear
- body text should be readable and simple
- labels and metadata should be compact and functional

The brand voice should feel like a real management platform, not a marketing landing page only.

## 6. Component Design Rules

Prefer reusable, focused components:
- one component = one responsibility
- keep props explicit and simple
- separate shared UI from feature-specific UI
- use module folders for each domain area
- isolate small action components such as buttons, selectors, and modals

When a feature needs multiple pieces of UI, split them into:
- page
- section components
- shared components
- request/data helpers
- types or schema definitions if needed

## 7. Data and State Patterns

Use patterns that fit the existing project:
- fetch data through dedicated request helpers
- keep UI state local when possible
- use modals for detail, edit, and confirmation actions
- use dropdowns and menus for account actions
- use session-aware logic for auth-protected areas

If a screen depends on user roles or permissions:
- compute access early
- hide unsupported items
- only render allowed menus and actions

## 8. Dashboard Behavior

Admin dashboard screens should support:
- role-based menu visibility
- collapsible navigation
- profile dropdown actions
- modal-based user and package operations
- table and list workflows for CRUD-like management

The dashboard should feel operational, not decorative.

## 9. Public Landing Page Behavior

Public pages should:
- introduce the product clearly
- show value in structured sections
- use a light and welcoming background
- guide the user toward login, signup, or exploration
- remain readable on desktop and mobile

The page should feel like a polished product homepage with real content blocks.

## 10. Auth Pages

Auth pages should:
- be focused
- minimize layout noise
- prioritize form clarity
- provide a direct path to login or register
- support session-aware redirect logic when needed

Keep auth UI simple and efficient.

## 11. Coding Style

Write code in a style that matches the project:
- use functional React components
- keep files focused and readable
- use clear folder names by feature
- avoid over-engineering
- use existing UI primitives when suitable
- keep class names consistent and purposeful

Prefer composition over monolithic components.

## 12. Output Expectations

When generating code:
- respect the current folder structure
- match the current layout system
- preserve the admin/public/guest separation
- keep the UI maintainable
- produce code that can be dropped into the project with minimal changes

If something is ambiguous:
- make the simplest reasonable assumption
- keep the UI consistent with the existing product
- do not introduce unnecessary abstractions

## 13. Good Default UI Pattern

A typical screen should follow this pattern:
- page shell
- title and supporting text
- primary action area
- content cards or table
- secondary actions in dropdowns or modals
- consistent footer or spacing at the bottom

## 14. What Not To Do

Do not:
- collapse everything into one page component
- mix public and admin shells
- ignore route groups
- invent a brand-new design system
- use random colors or inconsistent spacing
- create UI that looks disconnected from the rest of the project

## 15. Final Goal

Generate frontend code that feels like it belongs to this codebase:
- structured
- modular
- role-aware
- clean
- practical
- easy to extend