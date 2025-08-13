# Phase 6.3: Club Management CRUD

**Status**: ✅ COMPLETE
**Branch**: `phase-6-3-club-management` (ready for PR)
**Dependencies**: Phase 6.2 complete (Platform Admin Dashboard)

## Overview
Implement full CRUD (Create, Read, Update, Delete) operations for clubs through a web interface. This phase eliminates the need for console access to manage clubs, providing Super Admins with a complete club management system.

## Technical Design

### Controller Actions
```ruby
Admin::ClubsController < Admin::BaseController
  - index:   List all clubs with search/filter/sort
  - show:    Display club details
  - new:     Form for creating new club
  - create:  Process new club creation
  - edit:    Form for editing club
  - update:  Process club updates
  - destroy: Soft delete club
```

### Key Features
- Search clubs by name or location
- Filter by status (active/inactive)
- Sort by various columns
- Pagination for scalability
- Soft delete with recovery option
- Auto-create club admin user on club creation

## Detailed Task Checklist

### 1. Build ClubsController
- [ ] Generate Admin::ClubsController
- [ ] Implement CRUD actions:
  ```ruby
  def index
    @clubs = Club.includes(:race)
                 .search(params[:search])
                 .filter_by_status(params[:status])
                 .order(params[:sort])
                 .page(params[:page])
  end
  ```
- [ ] Add strong parameters for club attributes
- [ ] Implement soft delete logic

### 2. Create Club List View
- [ ] Create `app/views/admin/clubs/index.html.erb`
- [ ] Design data table with columns:
  - [ ] Club Name (linked to show)
  - [ ] Slug
  - [ ] Location
  - [ ] Status (Active/Inactive)
  - [ ] Last Race Date
  - [ ] Total Races
  - [ ] Actions (Edit, View, Delete)
- [ ] Add search bar
- [ ] Add status filter dropdown
- [ ] Implement column sorting
- [ ] Add pagination controls

### 3. Implement New Club Form
- [ ] Create `app/views/admin/clubs/new.html.erb`
- [ ] Build form with fields:
  - [ ] Club Name (required)
  - [ ] URL Slug (auto-generated, editable)
  - [ ] Location (required)
  - [ ] Contact Email (optional)
  - [ ] Admin Email (for club admin user)
  - [ ] Admin Password (auto-generate option)
  - [ ] Time Zone (default Mountain)
  - [ ] Status (default Active)
- [ ] Add slug validation and preview
- [ ] Implement JavaScript for slug generation
- [ ] Add form validation feedback

### 4. Build Edit Club Interface
- [ ] Create `app/views/admin/clubs/edit.html.erb`
- [ ] Reuse form partial from new
- [ ] Prevent slug changes if club has races
- [ ] Add "Reset Admin Password" option
- [ ] Include deactivation option
- [ ] Show club statistics

### 5. Create Club Details View
- [ ] Create `app/views/admin/clubs/show.html.erb`
- [ ] Display all club information
- [ ] Show club statistics:
  - [ ] Total races run
  - [ ] Average race duration
  - [ ] Last admin login
  - [ ] Current race status
- [ ] Add action buttons:
  - [ ] Edit Club
  - [ ] View Public Page
  - [ ] View Admin Page
  - [ ] Delete Club

### 6. Implement Club Creation Logic
- [ ] Create club record
- [ ] Auto-create club admin user:
  ```ruby
  user = User.create!(
    email: params[:admin_email],
    password: params[:admin_password]
  )
  ToolPermission.create!(
    user: user,
    tool: 'race_management',
    role: 'club_admin',
    club: @club
  )
  ```
- [ ] Create initial race for club
- [ ] Send welcome email (future)
- [ ] Display success with credentials

### 7. Add Soft Delete Functionality
- [ ] Add `deleted_at` column to clubs table
- [ ] Implement soft delete scopes
- [ ] Add confirmation dialog
- [ ] Prevent deletion if active races
- [ ] Allow restoration of deleted clubs
- [ ] Update dependent records handling

### 8. Implement Search and Filters
- [ ] Add search scope to Club model:
  ```ruby
  scope :search, ->(term) {
    where("name LIKE ? OR location LIKE ?", "%#{term}%", "%#{term}%")
  }
  ```
- [ ] Add status filter scope
- [ ] Implement sorting for all columns
- [ ] Add pagination with Turbo Frames

### 9. Add Audit Logging
- [ ] Create simple audit_logs table
- [ ] Log all CRUD operations:
  - [ ] User who performed action
  - [ ] Action type (create/update/delete)
  - [ ] Changed attributes
  - [ ] Timestamp
- [ ] Display in activity feed

### 10. Write Tests
- [ ] Controller tests:
  - [ ] All CRUD actions require super_admin
  - [ ] Create club with valid data
  - [ ] Update club attributes
  - [ ] Soft delete functionality
  - [ ] Search and filter work correctly
- [ ] Model tests:
  - [ ] Soft delete scopes
  - [ ] Search functionality
  - [ ] Validation tests
- [ ] Integration tests:
  - [ ] Full CRUD workflow
  - [ ] Club admin user creation

## Acceptance Criteria
1. ✅ Super Admin can view all clubs at `/admin/clubs`
2. ✅ Can create new club with auto-generated admin user
3. ✅ Can edit existing club details
4. ✅ Can soft delete clubs with confirmation
5. ✅ Search, filter, and sort work correctly
6. ✅ All forms have proper validation
7. ✅ Mobile responsive design
8. ✅ All tests passing

## Testing Instructions
```bash
# Run tests
rails test test/controllers/admin/clubs_controller_test.rb

# Manual testing
1. Login as super admin
2. Navigate to /admin/clubs
3. Test creating a new club:
   - Fill all required fields
   - Verify slug auto-generation
   - Check admin user creation
4. Test editing existing club
5. Test search functionality
6. Test filters and sorting
7. Test soft delete with confirmation
8. Verify all views are mobile responsive
```

## UI/UX Mockup - Club List
```
Clubs Management
+------------------------------------------+
| [Search: ________] [Status: All ▼]       |
| [+ Add New Club]                         |
+------------------------------------------+
| Name ▲ | Slug | Location | Status | Actions |
|--------|------|----------|--------|----------|
| Calgary BMX | calgary-bmx | Calgary, AB | Active | [Edit] [View] [Delete] |
| Edmonton BMX | edmonton-bmx | Edmonton, AB | Active | [Edit] [View] [Delete] |
| Airdrie BMX | airdriebmx | Airdrie, AB | Active | [Edit] [View] [Delete] |
+------------------------------------------+
| < Previous | Page 1 of 1 | Next >        |
+------------------------------------------+
```

## Notes
- Soft delete by default, hard delete only if no races
- Auto-generate secure passwords for club admins
- Consider email notifications for new clubs (Phase 7)
- Keep UI consistent with existing admin interface

## Definition of Done
- [x] All tasks completed
- [x] All tests passing (14/14 admin controller tests + comprehensive coverage)
- [x] Manual testing successful
- [x] CRUD operations work correctly
- [x] Mobile responsive verified
- [x] Code reviewed - no inline JavaScript, proper Stimulus usage
- [x] Ready for Phase 6.4