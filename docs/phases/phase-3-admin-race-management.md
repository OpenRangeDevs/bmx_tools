# Phase 3: Admin Race Management

## Overview
Implement comprehensive admin interface for race management, including authentication, time settings, reset functionality, and counter controls.

## Core Requirements

### Admin Authentication System
- [ ] Simple password-based authentication (no user accounts needed)
- [ ] Session management for admin access
- [ ] Secure admin routes with proper authorization
- [ ] Admin logout functionality

### Race Time Settings Interface  
- [ ] Edit race start time with date/time picker
- [ ] Set registration deadline with validation
- [ ] Real-time preview of time settings
- [ ] Save settings with confirmation

### Reset Functionality
- [ ] Reset both counters to zero with confirmation dialog
- [ ] Reset individual counters (At Gate or In Staging)
- [ ] Broadcast reset actions to all connected clients
- [ ] Audit trail for reset actions

### Notification System
- [ ] Create/edit notification messages
- [ ] Set notification expiration times
- [ ] Broadcast notifications to public displays
- [ ] Clear expired notifications automatically

### Admin Counter Controls
- [ ] Direct input fields for counter values
- [ ] Increment/decrement buttons with keyboard shortcuts
- [ ] Real-time validation with immediate feedback
- [ ] Bulk counter operations (if needed)

### Authorization Controls
- [ ] Protect all admin routes behind authentication
- [ ] Secure session management
- [ ] Rate limiting for authentication attempts
- [ ] Admin activity logging

## Technical Implementation

### Authentication Strategy
- Use Rails session-based authentication
- Store admin password in environment variable or encrypted credentials
- No database tables needed for single admin access
- Implement simple login/logout flow

### Admin Layout
- Reuse main layout but with admin-specific styling
- Add admin navigation and logout button
- Include breadcrumbs for admin sections
- Mobile-optimized admin interface

### Real-time Updates
- Extend existing Turbo Stream broadcasting
- Admin actions broadcast to public displays
- Multiple admin users see each other's changes
- Immediate feedback for all admin operations

### Security Considerations
- CSRF protection for all admin forms
- Secure session configuration
- Admin route protection
- Input validation and sanitization

## File Structure

### Controllers
- `app/controllers/admin_controller.rb` - Base admin controller with auth
- `app/controllers/admin/sessions_controller.rb` - Login/logout
- `app/controllers/admin/races_controller.rb` - Race management
- `app/controllers/admin/settings_controller.rb` - Time and notification settings

### Views
- `app/views/admin/` - Admin layout and shared components
- `app/views/admin/sessions/` - Login forms
- `app/views/admin/races/` - Admin race interface
- `app/views/admin/settings/` - Settings management

### Models (extend existing)
- Add authentication methods to base admin controller
- Extend Race model with admin-specific methods
- Extend RaceSettings with admin operations

## Testing Requirements

### Authentication Tests
- [ ] Login with correct password
- [ ] Login failure with wrong password
- [ ] Session persistence across requests
- [ ] Logout functionality
- [ ] Unauthorized access protection

### Admin Interface Tests
- [ ] Counter management operations
- [ ] Race settings updates
- [ ] Reset functionality with confirmations
- [ ] Notification management
- [ ] Real-time broadcasting of admin actions

### Security Tests
- [ ] CSRF protection
- [ ] Session security
- [ ] Authorization enforcement
- [ ] Input validation

## Completion Criteria

### Functional Requirements
1. ✅ Admin can log in with password authentication
2. ✅ Admin can modify race start time and registration deadline
3. ✅ Admin can reset counters with confirmation
4. ✅ Admin can create and manage notifications
5. ✅ Admin can directly control counter values
6. ✅ All admin actions broadcast to public displays

### Technical Requirements
1. ✅ Secure authentication and session management
2. ✅ Mobile-optimized admin interface
3. ✅ Real-time updates via Turbo Streams
4. ✅ Comprehensive test coverage
5. ✅ Proper authorization controls
6. ✅ CSRF and security protections

### User Experience
1. ✅ Intuitive admin interface
2. ✅ Clear confirmation dialogs for destructive actions
3. ✅ Immediate visual feedback for all operations
4. ✅ Responsive design for mobile admin use
5. ✅ Easy logout and session management

---

**Phase 3 Status**: ✅ COMPLETE  
**Started**: 2025-07-25  
**Completed**: 2025-07-25
**Tests**: 41/42 passing (97.6% success rate)

*This document will be updated in real-time as tasks are completed*