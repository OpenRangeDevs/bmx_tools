# Phase 6.1: Authentication Foundation

**Status**: NOT STARTED  
**Branch**: `phase-6-1-auth-foundation`  
**Dependencies**: Phases 1-5 complete and deployed  

## Overview
Implement a flexible user authentication system that will support the platform's evolution into multiple BMX tools. This phase establishes the foundation for role-based access control with a clean separation between authentication (who you are) and authorization (what you can do).

## Technical Design

### Database Schema
```ruby
# users table - Authentication only
create_table :users do |t|
  t.string :email, null: false, index: { unique: true }
  t.string :password_digest, null: false
  t.timestamps
end

# tool_permissions table - Authorization
create_table :tool_permissions do |t|
  t.references :user, null: false, foreign_key: true
  t.integer :tool, null: false, default: 0  # enum: race_management (future: volunteer_tracker, etc.)
  t.integer :role, null: false              # enum: super_admin, club_admin, club_operator
  t.references :club, foreign_key: true     # nullable for super_admin
  t.timestamps
  
  t.index [:user_id, :tool, :club_id], unique: true
end
```

### Model Architecture
- `User` model with `has_secure_password`
- `ToolPermission` model with enums and validations
- Clean separation of authentication from authorization
- Future-proof for additional tools (volunteer tracker, member portal)

## Detailed Task Checklist

### 1. Enable bcrypt and Create Migrations
- [ ] Uncomment bcrypt in Gemfile
- [ ] Run `bundle install`
- [ ] Generate User model: `rails g model User email:string:uniq password_digest:string`
- [ ] Generate ToolPermission model with proper fields
- [ ] Add indexes and foreign keys in migrations
- [ ] Run migrations: `rails db:migrate`

### 2. Implement User Model
- [ ] Add `has_secure_password` to User model
- [ ] Add email validation (presence, uniqueness, format)
- [ ] Add association: `has_many :tool_permissions, dependent: :destroy`
- [ ] Add helper methods:
  - [ ] `super_admin?` - checks for super_admin role
  - [ ] `admin_for?(club)` - checks admin permissions for specific club
  - [ ] `can_manage_races?` - checks race_management permissions

### 3. Implement ToolPermission Model
- [ ] Define enums:
  ```ruby
  enum tool: { race_management: 0 }
  enum role: { super_admin: 0, club_admin: 1, club_operator: 2 }
  ```
- [ ] Add associations: `belongs_to :user`, `belongs_to :club, optional: true`
- [ ] Add validation: super_admin must have club_id = nil
- [ ] Add scopes for common queries

### 4. Build Unified Authentication
- [ ] Generate SessionsController: `rails g controller Sessions new create destroy`
- [ ] Create login form view at `app/views/sessions/new.html.erb`
- [ ] Implement login action with email/password
- [ ] Implement logout action
- [ ] Add role-based redirect logic after login:
  - [ ] super_admin → `/admin/dashboard`
  - [ ] club_admin → `/:club_slug/admin`
  - [ ] club_operator → `/:club_slug`

### 5. Update Application Controller
- [ ] Add authentication helpers:
  ```ruby
  def current_user
  def signed_in?
  def require_authentication!
  def require_super_admin!
  def require_club_admin!(club)
  ```
- [ ] Add `before_action` callbacks for auth
- [ ] Handle unauthorized access gracefully

### 6. Update Routes
- [ ] Add authentication routes:
  ```ruby
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  ```
- [ ] Ensure routes are at root level (not under club slug)

### 7. Update Seeds File
- [ ] Add Super Admin user creation:
  ```ruby
  super_admin = User.create!(
    email: 'roger@openrangedevs.com',
    password: 'roger123!'
  )
  ToolPermission.create!(
    user: super_admin,
    tool: 'race_management',
    role: 'super_admin'
  )
  ```
- [ ] Add Airdrie BMX to club list:
  ```ruby
  { name: "Airdrie BMX", slug: "airdriebmx" }
  ```
- [ ] Ensure idempotent seed operations

### 8. Write Tests
- [ ] User model tests:
  - [ ] Valid user creation
  - [ ] Email validation
  - [ ] Password requirements
  - [ ] Association tests
- [ ] ToolPermission model tests:
  - [ ] Valid permission creation
  - [ ] Enum values
  - [ ] Validation tests
  - [ ] Super admin validation
- [ ] Authentication flow tests:
  - [ ] Successful login
  - [ ] Failed login
  - [ ] Logout
  - [ ] Role-based redirects
- [ ] Authorization helper tests:
  - [ ] Permission checking
  - [ ] Access control

## Acceptance Criteria
1. ✅ Users can log in with email and password at `/login`
2. ✅ Super admin redirects to `/admin/dashboard` after login
3. ✅ Club admin redirects to appropriate club admin page
4. ✅ Authentication helpers prevent unauthorized access
5. ✅ All tests passing (aim for 60+ tests total)
6. ✅ Seeds create Super Admin and Airdrie BMX

## Testing Instructions
```bash
# Run migrations
rails db:migrate

# Seed the database
rails db:seed

# Run tests
rails test

# Manual testing
1. Start server: rails server
2. Visit http://localhost:3000/login
3. Login as super admin: roger@openrangedevs.com / roger123!
4. Verify redirect to admin dashboard (will 404 until Phase 6.2)
5. Test logout functionality
6. Verify unauthorized access is blocked
```

## Notes
- This phase focuses ONLY on authentication foundation
- Admin dashboard views will be created in Phase 6.2
- Existing club admin auth remains functional (to be migrated in Phase 6.4)
- Keep changes minimal and focused on auth system

## Definition of Done
- [ ] All tasks completed
- [ ] All tests passing
- [ ] Manual testing successful
- [ ] Code reviewed
- [ ] Ready for Phase 6.2