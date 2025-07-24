# Phase 1: Database & Models Setup

## Objective
Set up the Rails 8 application with SQLite database and create the core Race model with proper validations for the dual counters.

## Detailed Requirements
- Ruby on Rails 8+ with SQLite (not PostgreSQL)
- Race model with at_gate and in_staging counter attributes
- Validation rules:
  1. At Gate counter: Minimum value 0, must be less than Staging counter
  2. In Staging counter: Minimum value 0, must be greater than or equal to At Gate counter

## Task List
- [ ] Verify Rails 8 installation
- [ ] Configure database.yml for SQLite
- [ ] Generate Race model with required attributes
- [ ] Implement validation rules in Race model
- [ ] Run migrations
- [ ] Add unit tests for validation rules
- [ ] Verify model functionality in Rails console

## Testing Instructions
1. Run `rails console` and create a new Race instance
2. Test validation rules by attempting to set invalid counter values
3. Verify that valid counter values are accepted

## Completion Criteria
- [ ] Race model created with proper attributes
- [ ] All validation rules implemented and working
- [ ] Migrations run successfully
- [ ] Unit tests passing
- [ ] Ready for review