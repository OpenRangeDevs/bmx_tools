# BMX Race Tracker - Master Task List

## Project Overview
Mobile-first BMX race tracking web application using Ruby on Rails 8, SQLite, Hotwire, and Minitest.
- **URL Pattern**: `bmxtools.com/[club-name]`
- **Stack**: Rails 8.0.2, SQLite3, TailwindCSS, Minitest
- **Started**: 2025-07-23

## Phase Structure

### Phase 1: Database & Models Setup ⏳
**Status**: In Progress  
**Branch**: `phase-1-database-models`

#### Core Tasks:
- [ ] Create Club model with slug-based routing
- [ ] Create Race model with dual counter states  
- [ ] Create RaceSettings model for times and notifications
- [ ] Add proper validations and relationships
- [ ] Create database migrations
- [ ] Write comprehensive model tests
- [ ] Set up club-specific URL routing

**Completion Criteria**: Models created, tested, and routing functional

---

### Phase 2: Core Race Tracking Interface 📋
**Status**: Pending Phase 1 completion

#### Core Tasks:
- [ ] Design mobile-first layout with TailwindCSS
- [ ] Create dual independent counters (At Gate/In Staging)
- [ ] Implement counter controls (+/- buttons, direct input)
- [ ] Add real-time updates with Hotwire
- [ ] Implement validation rules and error handling
- [ ] Add visual feedback for touch interactions

**Completion Criteria**: Functional race tracking interface with proper validation

---

### Phase 3: Admin Race Management 🛠️
**Status**: Pending Phase 2 completion

#### Core Tasks:
- [ ] Create admin authentication system
- [ ] Build race time settings interface
- [ ] Implement reset functionality with confirmation
- [ ] Add notification broadcast system
- [ ] Create admin controls for counter management
- [ ] Add proper authorization controls

**Completion Criteria**: Complete admin interface with all management features

---

### Phase 4: Real-time Updates & Polish 🚀
**Status**: Pending Phase 3 completion

#### Core Tasks:
- [ ] Implement Hotwire real-time broadcasting
- [ ] Add notification system with timers
- [ ] Optimize mobile performance and touch targets
- [ ] Add loading states and error handling
- [ ] Implement proper responsive design
- [ ] Add accessibility features

**Completion Criteria**: Production-ready application with real-time features

---

### Phase 5: Testing & Deployment 🧪
**Status**: Pending Phase 4 completion

#### Core Tasks:
- [ ] Comprehensive integration testing
- [ ] Performance testing on mobile devices
- [ ] Security audit and hardening
- [ ] Production deployment setup
- [ ] Documentation and user guides
- [ ] Load testing with multiple clubs

**Completion Criteria**: Fully tested and deployed application

---

## Technical Requirements Checklist

### Core Features:
- [ ] Dual independent counters (At Gate/In Staging)
- [ ] Club-specific URLs: `bmxtools.com/[club-name]`
- [ ] Real-time page updates
- [ ] Mobile-first responsive design
- [ ] Touch-optimized UI (44px+ touch targets)
- [ ] Race time settings (registration/start times)
- [ ] Admin reset functionality
- [ ] Notification system with timers

### Validation Rules:
- [ ] At Gate: min 0, must be < Staging
- [ ] In Staging: min 0, must be ≥ At Gate
- [ ] Proper error handling and user feedback

### Technical Stack:
- [ ] Ruby on Rails 8+
- [ ] SQLite database
- [ ] Hotwire (no React)
- [ ] Minitest (no RSpec)
- [ ] TailwindCSS for styling
- [ ] Mobile-first responsive design

### Visual Design:
- [ ] Color scheme implementation (red/orange counters)
- [ ] Typography (Roboto font, 72px counter numbers)
- [ ] Proper spacing and border radius
- [ ] Touch-friendly button sizing

---

## Current Status
**Active Phase**: Phase 1 - Database & Models Setup  
**Next Milestone**: Complete database models and routing  
**Awaiting**: User verification before Phase 2

---

*Last Updated: 2025-07-24*