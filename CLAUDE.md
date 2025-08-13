# Claude Context & Project Documentation

## Project Overview
BMX Race Tracker - A mobile-first web application for tracking BMX race moto progression with dual independent counters (At Gate/In Staging). Evolving into a comprehensive BMX tools platform.

## Essential Documentation Files
**READ THESE FIRST** before making any changes or suggestions:

### 📋 Core Requirements
- `@docs/prd.md` - Complete Product Requirements Document with all specifications
- `@docs/master_task_list.md` - Master project roadmap with all phases and technical requirements

### 🚀 Current Phase Information  
- `@docs/phases/phase-6-4-migration-polish.md` - Current phase: Migration & Polish
- `@docs/memories.md` - Project procedures, preferences, and development history

## Key Project Constraints
- **Technology Stack**: Ruby on Rails 8+, SQLite (NOT PostgreSQL), Hotwire (NOT React), Minitest (NOT RSpec)
- **Mobile-First**: Touch-optimized UI with 44px+ touch targets ✅ IMPLEMENTED
- **URL Structure**: `bmxtools.com/[club-name]` for club-specific access ✅ IMPLEMENTED  
- **Dual Counters**: At Gate (red) and In Staging (orange) with validation rules ✅ IMPLEMENTED
- **Real-time Updates**: Page must refresh as data changes (Stimulus controllers in progress)
- **Stimulus Controllers**: Use Stimulus for JavaScript behavior, NOT inline scripts

## Development Process Requirements

### ⚠️ CRITICAL Phase Development Process
**MANDATORY**: Each phase must follow this exact workflow:

1. **Phase Execution**:
   - Complete ALL tasks from current phase documentation
   - Mark tasks complete in real-time within phase documentation
   - NO jumping ahead to future phases

2. **Testing & Verification**:
   - Provide detailed test information to user
   - Run all tests ensuring they pass
   - Wait for USER APPROVAL before proceeding

3. **Git Workflow**:
   - Create phase branch: `phase-[n]-[feature-description]`
   - Make atomic, conventional commits (not bulk commits)
   - Examples: 
     - `feat(auth): add User model with secure password`
     - `test(auth): add user authentication tests`
     - `fix(auth): correct email validation pattern`

4. **Pull Request Process**:
   - Create PR with comprehensive description
   - Include testing instructions
   - Wait for USER to merge PR
   - ONLY proceed to next phase after merge

5. **Documentation**:
   - Update this CLAUDE.md file when procedures change
   - Update @docs/memories.md with new preferences
   - Keep phase documentation current with progress
   - Update master task list when phases change

### Phase-by-Phase Development Rules
1. Complete current phase tasks from `@docs/phases/phase-[n]-[title].md`
2. Mark tasks complete in real-time within phase documentation
3. Request user verification before proceeding to next phase
4. Create new branch per phase: `phase-[n]-[feature-description]`
5. Make logical commits, not bulk commits

### Testing & Validation
- Run `rails test` for all model changes
- Verify business rules in Rails console before marking tasks complete
- Test mobile UI on actual devices when UI is implemented
- **CRITICAL**: Use realistic Alberta BMX club names and terminology (never "one", "two", "MyString")
- Test data must reflect authentic BMX racing scenarios (gate numbers, moto progression, etc.)

## Current Status
- **Phase**: 6.4 - Migration & Polish 🚧 IN PROGRESS
- **Branch**: `phase-6-4-migration-polish`
- **Next Milestone**: Complete Phase 6 platform administration

## Key Business Rules
1. **At Gate Counter**: min 0, must be < In Staging
2. **In Staging Counter**: min 0, must be ≥ At Gate  
3. **Club URLs**: Each club gets unique slug-based URL
4. **Admin Features**: Time settings, reset functionality, notifications

## User Preferences
- Wait for explicit confirmation before proceeding to next phase
- Create detailed task breakdowns in phase documentation
- Test thoroughly before marking tasks complete
- Communicate clearly about testing procedures

---
**Last Updated**: 2025-08-13
**Current Phase**: Phase 6.4 - Migration & Polish 🚧
**Phase 1**: ✅ COMPLETE (Database & Models - merged to main)
**Phase 2**: ✅ COMPLETE (Core race interface with dual counters)
**Phase 3**: ✅ COMPLETE (Admin authentication & management)
**Phase 4**: ✅ COMPLETE (Real-time updates & mobile polish)
**Phase 5**: ✅ COMPLETE (Testing & deployment - IN PRODUCTION)
**Phase 6**: 🚧 IN PROGRESS (Platform Administration - Phase 6.4 final phase)