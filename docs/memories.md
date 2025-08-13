# Project Memories

## Development Procedures & Preferences

### Review Process
- Each phase must be completed and marked as "Ready for review"
- Wait for explicit confirmation before proceeding to next phase
- Verify by testing before allowing continuation

### Git Management Per Phase
- **MANDATORY Pre-commit Process**:
  1. ALWAYS run `bundle exec rubocop` first to check code style
  2. Fix any rubocop violations before committing
  3. Make atomic, logical commits (not bulk commits)
  4. Use conventional commit format: `type(scope): description`
- **Commit Framework**:
  - Types: feat, fix, docs, style, refactor, test, chore
  - Scope: area of change (models, controllers, views, etc.)
  - Examples:
    - `feat(admin): add club management dashboard`
    - `test(clubs): add comprehensive CRUD tests`
    - `docs: complete Phase 6.4 documentation`
    - `fix(auth): resolve Settings button navigation`
- **Smart commits**: Group related changes in logical commits
- **Communication**: Provide clear instructions on how to test phase completion

### File Organization
- Master task list at `docs/master_task_list.md`
- Phase details at `docs/phases/phase-[n]-[title].md`
- Update detailed task lists in real-time within each phase file
- Do not pre-populate future phase details

### Communication
- Update memories.md with any new procedures I specify
- Confirm milestones with me regularly
- Verify changes to requirements or approach
- **Context7 Usage**: Always use Context7 MCP server to retrieve up-to-date documentation when starting a session on this project

### Current Project Stats
- **Started:** 2025-07-23
- **Initiated:** 2025-07-24
- **Phase:** 6.4 - Migration & Polish 🚧 IN PROGRESS
- **Stack:** Rails 8.0.2, SQLite3, TailwindCSS, Minitest
- **URL Pattern:** `bmxtools.com/[club-name]`
- **Test Coverage:** 99/99 tests passing (100% success rate)

### Project Initiation Completed
- ✅ Created comprehensive master task list with 5 phases
- ✅ Updated Phase 1 documentation with detailed checklist (71 specific tasks)
- ✅ Established three core models: Club, Race, RaceSettings
- ✅ Defined validation rules for dual counter system
- ✅ Planned club-specific URL routing structure
- ✅ Removed jbuilder gem - no API needed for external partners
- ✅ Ready to begin Phase 1 implementation

### Testing Requirements
- **Realistic Test Data**: All tests must use meaningful names and data from Alberta BMX context
- **No Generic Names**: Never use opaque names like "one", "two", "MyString", etc.
- **Alberta BMX Clubs**: Use real Alberta BMX club names and BMX terminology
- **Authentic Data**: Gate numbers, moto counts, and race scenarios should reflect real BMX racing

### Phase 3 Completion Summary (2025-07-25)
- ✅ **Admin Authentication**: Session-based auth with 4-hour timeout
- ✅ **Race Time Settings**: Real-time updates via Turbo Streams
- ✅ **Reset Functionality**: Confirmation dialogs with broadcast updates
- ✅ **Live Notifications**: Real-time activity feed for admin users
- ✅ **Enhanced Security**: CSRF protection, session timeout, security headers
- ✅ **Authorization Controls**: Protected admin routes with proper session management
- ✅ **Testing**: 41/42 tests passing with comprehensive coverage
- ✅ **Ready for Phase 4**: Real-time Updates & Polish

### Phase 6.4 Migration & Polish Summary (2025-08-13)
- ✅ **Legacy Auth Cleanup**: Removed old AdminController and session-based auth methods
- ✅ **No Session Timeout**: Simplified auth system - no forced re-authentication needed
- ✅ **Clean Session Management**: Just user_id tracking, persistent sessions
- ✅ **Turbo Forms**: Club CRUD forms now use Turbo for seamless UX
- ✅ **Error Handling**: Forms have proper Turbo-compatible error display
- ✅ **System Tests**: Added comprehensive system tests for dashboard, clubs, and race tracking
- ✅ **Testing**: 99/99 tests passing (100% success rate)
- ✅ **Ready for Deployment**: Migration and polish complete

---
*Add new procedures and memories below as they arise*
