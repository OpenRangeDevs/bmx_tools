# Phase 6.2: Platform Admin Dashboard

**Status**: NOT STARTED  
**Branch**: `phase-6-2-admin-dashboard`  
**Dependencies**: Phase 6.1 complete (Authentication Foundation)  

## Overview
Create the platform administration dashboard that provides Super Admins with a comprehensive view of all clubs, platform metrics, and quick access to management functions. This phase focuses on the read-only dashboard views and navigation structure.

## Technical Design

### Controller Structure
```ruby
# Admin namespace for all platform admin controllers
Admin::BaseController < ApplicationController
  - Authentication and authorization checks
  - Shared admin layout

Admin::DashboardController < Admin::BaseController
  - Platform metrics and overview
  - Activity monitoring
  - Quick action buttons
```

### Key Metrics to Display
- Total number of clubs (active/inactive)
- Total races run across platform
- Currently active races
- Recent activity across all clubs
- Platform usage trends

## Detailed Task Checklist

### 1. Create Admin Namespace Structure
- [ ] Generate Admin::BaseController
- [ ] Add authentication checks: `before_action :require_super_admin!`
- [ ] Set admin layout if needed
- [ ] Add common helper methods for admin views

### 2. Build Dashboard Controller
- [ ] Generate Admin::DashboardController
- [ ] Create `index` action with platform metrics:
  ```ruby
  @total_clubs = Club.count
  @active_clubs = Club.joins(:race).where(...)
  @total_races = Race.count
  @active_races = Race.where(...)
  @recent_activity = ... # Last 10 actions
  ```
- [ ] Add caching for expensive queries
- [ ] Implement activity tracking queries

### 3. Create Dashboard Views
- [ ] Create `app/views/admin/dashboard/index.html.erb`
- [ ] Design metric cards layout:
  - [ ] Total Clubs card
  - [ ] Active Races card
  - [ ] Today's Activity card
  - [ ] Platform Health card
- [ ] Add quick action buttons:
  - [ ] "Add New Club" button
  - [ ] "View All Clubs" link
  - [ ] "Platform Settings" (future)
- [ ] Implement responsive grid layout

### 4. Implement Activity Feed
- [ ] Create activity tracking without full audit log (simplified for now)
- [ ] Display recent actions:
  - [ ] Club creations
  - [ ] Race resets
  - [ ] Admin logins
- [ ] Format activity items with timestamps
- [ ] Add real-time updates with Turbo Streams (optional)

### 5. Style with TailwindCSS
- [ ] Match existing application design language
- [ ] Create admin-specific color scheme if needed
- [ ] Ensure mobile responsiveness
- [ ] Add loading states for metrics
- [ ] Implement smooth transitions

### 6. Add Navigation
- [ ] Create admin navigation partial
- [ ] Include links to:
  - [ ] Dashboard (current page)
  - [ ] Clubs (Phase 6.3)
  - [ ] Settings (future)
  - [ ] Logout
- [ ] Add user info display (email, role)
- [ ] Implement active state styling

### 7. Update Routes
- [ ] Add admin namespace routes:
  ```ruby
  namespace :admin do
    get '/', to: 'dashboard#index'
    get '/dashboard', to: 'dashboard#index'
  end
  ```
- [ ] Ensure routes require authentication

### 8. Write Tests
- [ ] Dashboard controller tests:
  - [ ] Requires super_admin authentication
  - [ ] Displays correct metrics
  - [ ] Handles empty data gracefully
- [ ] View tests:
  - [ ] All metric cards render
  - [ ] Navigation displays correctly
  - [ ] Quick actions present
- [ ] Integration tests:
  - [ ] Full dashboard flow
  - [ ] Authorization enforcement

## Acceptance Criteria
1. ✅ Super Admin can access dashboard at `/admin/dashboard`
2. ✅ Dashboard displays accurate platform metrics
3. ✅ Quick action buttons are present and styled
4. ✅ Non-super admins cannot access dashboard
5. ✅ Dashboard is mobile responsive
6. ✅ All tests passing

## Testing Instructions
```bash
# Ensure Phase 6.1 is complete
rails db:migrate
rails db:seed

# Run tests
rails test test/controllers/admin/

# Manual testing
1. Start server: rails server
2. Login as super admin: roger@openrangedevs.com / roger123!
3. Should redirect to /admin/dashboard
4. Verify all metrics display correctly
5. Check responsive design on mobile
6. Test quick action buttons (will 404 until Phase 6.3)
7. Verify logout works
```

## UI/UX Mockup
```
+------------------------------------------+
| BMX Tools - Platform Admin               |
| roger@openrangedevs.com | Logout         |
+------------------------------------------+
| Dashboard | Clubs | Settings             |
+------------------------------------------+

Platform Overview
+-------------+  +-------------+  +-------------+
| Total Clubs |  | Active Now  |  | This Month  |
|     6       |  |     2       |  |    245      |
|             |  | races live  |  | races run   |
+-------------+  +-------------+  +-------------+

Quick Actions
[+ Add New Club]  [View All Clubs]  [Settings]

Recent Activity
-------------------------------------------
| 2 min ago  | Calgary BMX race started   |
| 15 min ago | New club: Airdrie BMX      |
| 1 hour ago | Edmonton BMX race reset    |
| 2 hours ago| Admin login: roger@...     |
-------------------------------------------
```

## Notes
- Focus on read-only dashboard for this phase
- Club CRUD operations come in Phase 6.3
- Keep activity tracking simple (no full audit log yet)
- Reuse existing TailwindCSS styles where possible

## Definition of Done
- [ ] All tasks completed
- [ ] All tests passing
- [ ] Manual testing successful
- [ ] Mobile responsive design verified
- [ ] Code reviewed
- [ ] Ready for Phase 6.3