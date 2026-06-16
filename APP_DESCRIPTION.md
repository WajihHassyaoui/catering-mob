# Platter Catering — App Description

Platter Catering is a premium corporate food ordering, meal prep, and event catering mobile/web application built with **Flutter**. It is designed to streamline meal services for businesses, offering features tailored for individual employees (Clients), company administrators/HR managers (Companies), and the catering operations team (Admins).

---

## 🏗️ Architecture & Technology Stack

The application follows a clean, feature-first folder structure and utilizes modern state-of-the-art Flutter libraries:

- **State Management**: [Riverpod (flutter_riverpod)](https://pub.dev/packages/flutter_riverpod) for reactive, testable, and robust state management.
- **Navigation & Routing**: [GoRouter](https://pub.dev/packages/go_router) for declarative routing with dynamic redirects (e.g., authentication status and role validation).
- **HTTP Client**: [Dio](https://pub.dev/packages/dio) for standard networking and API integration.
- **Storage & Caching**: [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage) for secure credentials/tokens caching, and [Shared Preferences](https://pub.dev/packages/shared_preferences) for lighter, non-sensitive configurations.
- **Aesthetics & Animations**: [Google Fonts (Outfit, Inter, etc.)](https://pub.dev/packages/google_fonts), [Flutter Animate](https://pub.dev/packages/flutter_animate) for micro-animations, and [Shimmer](https://pub.dev/packages/shimmer) for skeleton loaders.

---

## 📂 Project Directory Structure

```text
lib/
├── main.dart                   # Application entry point, initializes bindings and runs ProviderScope
├── app/                        # Global application-wide configuration
│   ├── app.dart                # Main material app configuration, links router and theme
│   ├── router.dart             # GoRouter configuration with role-based routing and authorization redirects
│   └── theme.dart              # Custom high-end visual theme (colors, fonts, component styles)
├── core/                       # Core system files shared across all domains
│   ├── constants/              # Styling, colors, typography, margins/spacing, and system enums
│   ├── network/                # ApiClient configuration and API endpoints
│   ├── storage/                # SecureStorage wrapper for cache control
│   └── utils/                  # Helper utilities such as form input validators
├── shared/                     # Global shared models, mock database, and reusable widgets
│   ├── mock_data/              # Mock database loaded with users, orders, events, and billing history
│   ├── models/                 # Domain objects mapping (User, Company, Order, Catering, Invoice, etc.)
│   └── widgets/                # Premium buttons, custom input fields, cards, badges, and empty states
└── features/                   # Core business flows divided by domain and target persona
    ├── auth/                   # Splash, onboarding, role selection, login, registration, and pending approval
    ├── client/                 # Individual user portal (home, meal selection, tracking individual orders, profile)
    ├── company/                # Company portal (members roster, group order coordinator, catering bookings, invoices)
    └── admin/                  # Back-office portal (company approvals, menu customization, catering requests, orders log)
```

---

## 👥 Roles & Workflows

Platter Catering is centered around three distinct roles, each equipped with its own bottom navigation bar, features, and dashboards:

### 1. Client / Employee (Individual Portal)
*Designed for individual employees to view, order, and track gourmet meals.*
- **Home Panel**: Custom welcome feed showing featured meal recommendations, notifications, active group orders, and running meal-prep plan deliveries.
- **Meals Listing**: Interactive catalog of healthy meals filters by category (e.g., Bows, Salads, Sides, Drinks) with detailed nutrition, calorie count, allergens list, ratings, and preparation time.
- **Group Ordering**: Joins team-wide lunch events by entering a unique code. Users pick their meal selection, staying within company-allocated spending limits.
- **My Orders**: Complete tracking history of past and current orders. Includes real-time delivery status updates (`pending` ➔ `confirmed` ➔ `preparing` ➔ `out_for_delivery` ➔ `delivered`).
- **Profile / Preferences**: Personal settings, dietary filters, spending caps, and linked company parameters.

### 2. Company Admin / HR Manager (Employer Portal)
*Designed for company administrators who manage food benefits, group lunches, and company events.*
- **Dashboard**: High-level reporting view on monthly team food expenditures, active employee counts, and active meal plans.
- **Members Directory**: Control board to invite new team members, edit roles, customize individual permissions (e.g., toggle individual ordering, catering bookings), adjust daily spending limits, and view invitation statuses (`active`, `invited`, `suspended`).
- **Group Orders Organizer**: Sets up team lunch days. Selects menu package (e.g., Mediterranean Selection), selects delivery coordinates, sets order deadline, and invites participants.
- **Event Catering Bookings**: Submits custom corporate catering requests specifying event type (Product Launch, Board Meeting, etc.), guest range, budget bounds, dietary exclusions, and event notes. 
- **Billing & Invoicing**: Oversees outstanding invoices, transaction histories, and pays monthly balances via credit card or ACH.

### 3. Platter Operations Admin (Catering Operations Dashboard)
*For Platter Catering's staff to coordinate culinary orders, logistics, and company relations.*
- **Console Dashboard**: Tracks gross platform sales, pending company onboarding approvals, active menu offerings, and open catering quotes.
- **Onboarding Management**: Approves or rejects new company registration requests based on credentials and verification.
- **Menu Curator**: Tool to edit active items in the database, modify pricing, ingredients, calories, categories, and feature special items.
- **Order Tracker & Logistics**: Central view of all active kitchen preparations and delivery statuses, allowing status state advancement.
- **Catering Quoting Desk**: Reviews corporate events and constructs formal price quotes for company approval.

---

## 🎨 Design System & Visual Aesthetics

The application employs a curated "Platter" theme featuring a premium organic color palette and strict layout systems:

### Core Color Palette
- **Backgrounds**: Cream Base (`#FFF8ED`) and Soft Beige (`#F4E6D0`).
- **Accent Greens**: Sage Green (`#8FAF8B`) and Olive Green (`#4F6F52`).
- **Warm Highlights**: Terracotta (`#C96B3C`) and Warm Gold (`#D9A441`).
- **Typography & Dark Elements**: Charcoal Dark (`#263128`) and Slate Muted Text (`#6F7A70`).
- **Validation**: Success Green (`#6FA878`) and Error Red (`#D86A5D`).

### Micro-Animations
Interactive UI items utilize scale transitions, fade animators, and bounce behaviors using **Flutter Animate** to feel responsive, sleek, and high-fidelity.

---

## 📊 Domain Data Models (`lib/shared/models/`)

The data layer is modeled using strong immutable types:

1. **`UserModel`** & **`CompanyMember`**: Contains user info, avatars, verified status, department tags, role titles, and specific authorization flags (e.g., `canRequestCatering`, `isCompanyAdmin`).
2. **`CompanyModel`**: Captures company profiles, website URLs, employee counts, current monthly spends, tax IDs, and approval status (`pending`, `approved`, `rejected`, `suspended`).
3. **`MealModel`**, **`CateringPackage`**, & **`MealPrepPackage`**: Models kitchen dishes, custom event food packages (with min/max guest bounds and price-per-person indexes), and subscription prep packages.
4. **`OrderModel`**: Detailed transactional invoice logs showing items ordered, subtotal, delivery location, selected delivery timeslots, payment modes, and chronological status history events.
5. **`GroupOrder`**: Coordinates collaborative orders, keeping track of participant rosters, item selections, deadlines, and join codes.
6. **`CateringRequest`**: Represents a custom event bid with status flags (`pending`, `quoted`, `accepted`, `completed`).
7. **`InvoiceModel`**: Aggregates costs for either a `group_order` or `catering` request, showing subtotal, tax calculations, and status (`pending`, `paid`, `overdue`).
