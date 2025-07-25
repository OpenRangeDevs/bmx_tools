# Project Memories

## Development Procedures & Preferences

### Review Process
- Each phase must be completed and marked as "Ready for review"
- Wait for explicit confirmation before proceeding to next phase
- Verify by testing before allowing continuation

### Git Management Per Phase
- **Create new branch** when phase is complete: `phase-[n]-[feature-description]`
- **Smart commits**: Group related changes in logical commits (not all at once)
  - Example: `config/database.yml: Add default scopes to race status model`
  - Example: `app/models: Add validations for staging counter rule`
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
- **Phase:** 2 - Core Race Tracking Interface
- **Stack:** Rails 8.0.2, SQLite3, TailwindCSS, Minitest
- **URL Pattern:** `bmxtools.com/[club-name]`

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

---
*Add new procedures and memories below as they arise*
