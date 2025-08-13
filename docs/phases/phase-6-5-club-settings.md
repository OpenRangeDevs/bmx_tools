# Phase 6.5: Club Settings Management

**Status**: NOT STARTED
**Branch**: `phase-6-5-club-settings`
**Dependencies**: Phase 6.4 complete (Migration & Polish)

## Overview
Create a comprehensive club settings interface that allows both super admins and club admins to manage club details, members, ownership, and configuration. This addresses the current disabled "Settings" button on the admin dashboard by providing real club management functionality.

## Key Objectives
- Enable club admins to fully manage their own clubs (except hard delete)
- Provide super admins with complete club management capabilities
- Implement secure ownership transfer system with email verification
- Add logo upload functionality with automatic resizing
- Create member management interface for adding/removing club users
- Build authorization system that respects club vs platform admin boundaries

## Detailed Task Checklist

### 1. Database Schema Extensions
- [ ] **Migration: Add club settings fields**
  ```ruby
  add_column :clubs, :owner_user_id, :bigint
  add_column :clubs, :website_url, :string
  add_column :clubs, :description, :text
  add_foreign_key :clubs, :users, column: :owner_user_id
  ```
- [ ] **Migration: Create ownership transfers table**
  ```ruby
  create_table :ownership_transfers do |t|
    t.references :club, null: false, foreign_key: true
    t.references :from_user, null: false, foreign_key: { to_table: :users }
    t.string :to_user_email, null: false
    t.string :token, null: false
    t.datetime :expires_at, null: false
    t.datetime :completed_at
    t.datetime :cancelled_at
    t.timestamps
  end
  add_index :ownership_transfers, :token, unique: true
  ```
- [ ] **Active Storage setup for club logos**
  ```ruby
  # In Club model
  has_one_attached :logo
  ```

### 2. Model Updates
- [ ] **Update Club model**
  - [ ] Add logo attachment
  - [ ] Add owner relationship
  - [ ] Add logo validation (formats, size)
  - [ ] Add website URL validation
  - [ ] Add helper methods for ownership
- [ ] **Create OwnershipTransfer model**
  - [ ] Add validations for token, expiry
  - [ ] Add methods for completion/cancellation
  - [ ] Add email verification logic
- [ ] **Update User model helpers**
  - [ ] Add `owner_of?(club)` method
  - [ ] Update authorization helpers

### 3. Create Club Settings Controller
- [ ] **Generate Admin::Clubs::SettingsController**
  ```ruby
  class Admin::Clubs::SettingsController < Admin::BaseController
    before_action :set_club
    before_action :authorize_club_access!
  ```
- [ ] **Implement actions**:
  - [ ] `index` - main settings page with tabs
  - [ ] `update_general` - club details, logo
  - [ ] `add_member` - add user to club
  - [ ] `update_member` - change user role
  - [ ] `remove_member` - remove user access
  - [ ] `initiate_transfer` - start ownership transfer
  - [ ] `cancel_transfer` - cancel pending transfer
  - [ ] `soft_delete` - mark club as deleted
  - [ ] `restore` - restore soft-deleted club (super admin only)
  - [ ] `hard_delete` - permanent delete (super admin only)

### 4. Build Settings Interface Views
- [ ] **Main settings page** (`app/views/admin/clubs/settings/index.html.erb`)
  - [ ] Tab navigation (General/Members/Ownership/Danger Zone)
  - [ ] Responsive design with TailwindCSS
  - [ ] Authorization-aware content (show/hide based on permissions)

- [ ] **General Tab**
  - [ ] Club name, slug, location editing
  - [ ] Logo upload with drag & drop
  - [ ] Logo preview and remove functionality
  - [ ] Website URL and description fields
  - [ ] Contact email management

- [ ] **Members Tab**
  - [ ] Current members table with roles
  - [ ] Add member form (email + role selection)
  - [ ] Role change dropdowns
  - [ ] Remove member confirmations
  - [ ] Send password reset functionality
  - [ ] Owner highlighted prominently

- [ ] **Ownership Tab**
  - [ ] Current owner display
  - [ ] Transfer ownership form
  - [ ] Pending transfer status display
  - [ ] Cancel transfer button
  - [ ] Transfer history (if implemented)

- [ ] **Danger Zone Tab**
  - [ ] Soft delete club (club admins)
  - [ ] Restore club (super admins, if soft deleted)
  - [ ] Hard delete club (super admins only)
  - [ ] Export club data (future consideration)
  - [ ] Clear confirmation modals for destructive actions

### 5. Logo Upload System
- [ ] **Configure Active Storage variants**
  ```ruby
  # In Club model
  has_one_attached :logo do |attachable|
    attachable.variant :thumb, resize_to_fill: [120, 120, { crop: :centre }]
  end
  ```
- [ ] **Logo validation**
  - [ ] File format validation (PNG, JPG, JPEG, WEBP)
  - [ ] File size validation (5MB max)
  - [ ] Image processing error handling
- [ ] **Upload interface**
  - [ ] Drag & drop zone
  - [ ] Click to upload
  - [ ] Progress indicators
  - [ ] Preview functionality
  - [ ] Remove logo option

### 6. Ownership Transfer System
- [ ] **Transfer initiation**
  - [ ] Generate secure token
  - [ ] Set 72-hour expiry
  - [ ] Send verification email
  - [ ] Store transfer record
- [ ] **Email verification**
  - [ ] Create transfer acceptance view
  - [ ] Require login as target user
  - [ ] Complete transfer on confirmation
  - [ ] Send confirmation emails to both parties
- [ ] **Transfer management**
  - [ ] Cancel pending transfers
  - [ ] Handle expired transfers
  - [ ] Update club owner_user_id on completion

### 7. Authorization System
- [ ] **Controller authorization**
  ```ruby
  def authorize_club_access!
    unless current_user.super_admin? || current_user.admin_for?(@club)
      redirect_to admin_dashboard_path, alert: "Not authorized"
    end
  end

  def authorize_hard_delete!
    unless current_user.super_admin?
      redirect_to admin_club_settings_path(@club), alert: "Only platform admins can permanently delete clubs"
    end
  end
  ```
- [ ] **View-level permissions**
  - [ ] Hide hard delete for club admins
  - [ ] Show restore only to super admins
  - [ ] Limit member management based on role

### 8. Update Navigation
- [ ] **Fix Settings button on admin dashboard**
  - [ ] For super admins: link to clubs index with settings actions
  - [ ] For club admins: direct link to their club's settings
  - [ ] Update button styling to show it's enabled
- [ ] **Add settings links in clubs interface**
  - [ ] Settings button on each club row (super admin view)
  - [ ] Settings link in club detail view
  - [ ] Breadcrumb navigation in settings

### 9. Routing Configuration
- [ ] **Add settings routes**
  ```ruby
  namespace :admin do
    resources :clubs, param: :slug do
      resource :settings, only: [:index] do
        patch :update_general
        post :add_member
        patch :update_member
        delete :remove_member
        post :initiate_transfer
        delete :cancel_transfer
        patch :soft_delete
        patch :restore
        delete :hard_delete
      end
    end
  end
  ```

### 10. Email System
- [ ] **Create mailers**
  - [ ] `OwnershipTransferMailer`
    - [ ] `initiate_transfer` - sent to new owner
    - [ ] `transfer_completed` - sent to both parties
    - [ ] `transfer_cancelled` - sent to both parties
  - [ ] `PasswordResetMailer`
    - [ ] `reset_instructions` - for club member resets
- [ ] **Email templates**
  - [ ] Professional, branded templates
  - [ ] Clear call-to-action buttons
  - [ ] Security information and expiry notices

### 11. Comprehensive Testing
- [ ] **Model tests**
  - [ ] Club logo validation
  - [ ] Owner relationship
  - [ ] OwnershipTransfer model methods
  - [ ] User authorization helpers
- [ ] **Controller tests**
  - [ ] Authorization for different user types
  - [ ] All settings actions
  - [ ] Error handling
  - [ ] File upload handling
- [ ] **System tests**
  - [ ] Complete settings workflow
  - [ ] Logo upload and preview
  - [ ] Member management flow
  - [ ] Ownership transfer process
  - [ ] Authorization boundaries
- [ ] **Integration tests**
  - [ ] Email delivery
  - [ ] Transfer completion flow
  - [ ] Soft delete and restore

### 12. Error Handling & UX
- [ ] **Comprehensive error handling**
  - [ ] File upload errors
  - [ ] Network timeout handling
  - [ ] Validation error display
  - [ ] Authorization error messages
- [ ] **Loading states**
  - [ ] Image upload progress
  - [ ] Form submission states
  - [ ] Async operation feedback
- [ ] **Success feedback**
  - [ ] Toast notifications for actions
  - [ ] Clear confirmation messages
  - [ ] Updated state indicators

## Acceptance Criteria
1. ✅ Club admins can manage all aspects of their club except hard delete
2. ✅ Super admins have full access to all club settings
3. ✅ Logo upload works with automatic 120x120 resizing
4. ✅ Member management allows adding/removing users with proper roles
5. ✅ Ownership transfer requires email verification and expires in 72 hours
6. ✅ All destructive actions have confirmation dialogs
7. ✅ Settings button on dashboard works for both user types
8. ✅ Comprehensive test coverage (80+ tests expected)
9. ✅ Responsive design works on mobile devices
10. ✅ All authorization boundaries properly enforced

## Testing Instructions
```bash
# Full test suite
rails test

# Specific areas
rails test test/models/club_test.rb
rails test test/models/ownership_transfer_test.rb
rails test test/controllers/admin/clubs/settings_controller_test.rb
rails test test/system/admin_club_settings_test.rb

# Manual testing checklist:
1. Super Admin Flow:
   - Login and navigate to Settings from dashboard
   - Access any club's settings
   - Test all tabs and functionality
   - Perform hard delete operation

2. Club Admin Flow:
   - Login as club admin
   - Access only their club's settings
   - Test member management
   - Initiate ownership transfer
   - Perform soft delete

3. Ownership Transfer Flow:
   - Initiate transfer as current owner
   - Receive and click verification email
   - Complete transfer as new owner
   - Verify both parties receive confirmations

4. Logo Upload Flow:
   - Test various file formats and sizes
   - Verify 120x120 resizing works
   - Test error handling for invalid files
   - Verify remove logo functionality
```

## Security Considerations
- File upload validation and size limits
- Secure token generation for transfers
- Authorization checks on all sensitive operations
- Email verification for ownership changes
- Protection against CSRF attacks
- Input sanitization for all form fields

## Performance Considerations
- Logo processing happens in background
- Efficient database queries for member listings
- Proper indexing on ownership_transfers table
- Image variant caching for performance

## Notes
- This phase significantly enhances the admin experience
- Club autonomy is increased while maintaining platform control
- Ownership transfer system ensures secure transitions
- Logo functionality adds professional branding capability

## Definition of Done
- [ ] All tasks completed and tested
- [ ] Settings button functional for both user types
- [ ] Logo upload working with proper processing
- [ ] Member management fully operational
- [ ] Ownership transfer system working end-to-end
- [ ] All authorization boundaries respected
- [ ] Comprehensive test coverage
- [ ] Documentation updated
- [ ] Ready for production deployment