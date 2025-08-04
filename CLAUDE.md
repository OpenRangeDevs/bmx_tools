# Claude Context & Project Documentation

## Project Overview
BMX Race Tracker - A mobile-first web application for tracking BMX race moto progression with dual independent counters (At Gate/In Staging).

## Essential Documentation Files
**READ THESE FIRST** before making any changes or suggestions:

### 📋 Core Requirements
- `@docs/prd.md` - Complete Product Requirements Document with all specifications
- `@docs/master_task_list.md` - Master project roadmap with 5 phases and technical requirements

### 🚀 Current Phase Information  
- `@docs/phases/phase-3-admin-race-management.md` - Detailed current phase tasks and checklist
- `@docs/memories.md` - Project procedures, preferences, and development history

## Key Project Constraints
- **Technology Stack**: Ruby on Rails 8+, SQLite (NOT PostgreSQL), Hotwire (NOT React), Minitest (NOT RSpec)
- **Mobile-First**: Touch-optimized UI with 44px+ touch targets ✅ IMPLEMENTED
- **URL Structure**: `bmxtools.com/[club-name]` for club-specific access ✅ IMPLEMENTED  
- **Dual Counters**: At Gate (red) and In Staging (orange) with validation rules ✅ IMPLEMENTED
- **Real-time Updates**: Page must refresh as data changes (Stimulus controllers in progress)
- **Stimulus Controllers**: Use Stimulus for JavaScript behavior, NOT inline scripts

## Development Process Requirements

### Documentation Maintenance
⚠️ **CRITICAL**: Always keep documentation current with these rules:
1. **Update this CLAUDE.md file** whenever project structure or key procedures change
2. **Update @docs/memories.md** with any new procedures or preferences specified by the user
3. **Update phase documentation** in real-time as tasks are completed
4. **Update master task list** when phases or requirements change
5. **Context7 Integration**: Always use Context7 MCP server to retrieve current documentation when starting sessions

### Phase-by-Phase Development
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
- **Phase**: 5 - Testing & Deployment 🚧 IN PROGRESS
- **Branch**: `phase-5-testing-deployment`
- **Next Milestone**: Production Deployment

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
**Last Updated**: 2025-08-04  
**Current Phase**: Phase 5 - Testing & Deployment 🚧 IN PROGRESS
**Phase 1**: ✅ COMPLETE (29 tests passing, merged to main)
**Phase 2**: ✅ COMPLETE (Core race interface with dual counters)
**Phase 3**: ✅ COMPLETE (41/42 tests passing, admin authentication & management)
**Phase 4.1**: ✅ COMPLETE (Enhanced real-time broadcasting & countdown timers)
**Phase 4.2**: ✅ COMPLETE (Mobile performance optimization, loading states, animations, accessibility)
**Phase 5**: 🚧 IN PROGRESS (Testing, security, performance, deployment preparation)