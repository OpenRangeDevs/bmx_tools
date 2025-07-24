# Phase 1: Database & Models Setup

## Objective
Set up the Rails 8 application with SQLite database and create the core models for club-specific race tracking with proper validations for the dual counters.

## Detailed Requirements
- Ruby on Rails 8+ with SQLite (not PostgreSQL)
- Club model for slug-based routing (`bmxtools.com/[club-name]`)
- Race model with at_gate and in_staging counter attributes
- RaceSettings model for admin features (times, notifications)
- Validation rules:
  1. At Gate counter: Minimum value 0, must be less than Staging counter
  2. In Staging counter: Minimum value 0, must be greater than or equal to At Gate counter

## Detailed Task List

### Database & Configuration
- [x] Verify Rails 8 installation and version
- [x] Confirm SQLite3 gem is properly configured
- [x] Review database.yml configuration for SQLite
- [x] Set up proper database defaults and constraints

### Club Model Development
- [x] Generate Club model with required attributes:
  - `name` (string, required)
  - `slug` (string, required, unique, url-friendly)
  - `created_at` and `updated_at` timestamps
- [x] Add Club model validations:
  - Presence of name and slug
  - Uniqueness of slug
  - Slug format validation (url-friendly)
- [x] Add slug generation methods (parameterize name)
- [x] Create Club migration
- [x] Add Club model unit tests

### Race Model Development  
- [x] Generate Race model with required attributes:
  - `at_gate` (integer, default: 0)
  - `in_staging` (integer, default: 0)  
  - `club_id` (foreign key to clubs table)
  - `active` (boolean, default: true)
  - `created_at` and `updated_at` timestamps
- [x] Add Race model validations:
  - Presence of club_id
  - Numericality: at_gate >= 0
  - Numericality: in_staging >= 0  
  - Custom validation: at_gate < in_staging (when both > 0)
- [x] Add Race model associations:
  - `belongs_to :club`
- [x] Create Race migration
- [x] Add Race model unit tests for all validation rules

### RaceSettings Model Development
- [x] Generate RaceSettings model with attributes:
  - `race_id` (foreign key to races table)
  - `registration_deadline` (time)
  - `race_start_time` (time)
  - `notification_message` (text, optional)
  - `notification_expires_at` (datetime, optional)
  - `created_at` and `updated_at` timestamps
- [x] Add RaceSettings model validations:
  - Presence of race_id
  - Time format validations
- [x] Add RaceSettings model associations:
  - `belongs_to :race`
- [x] Create RaceSettings migration
- [x] Add RaceSettings model unit tests

### Model Associations & Relationships
- [x] Update Club model with associations:
  - `has_many :races, dependent: :destroy`
- [x] Update Race model with associations:
  - `has_one :race_setting, dependent: :destroy`
- [x] Add proper foreign key constraints in migrations
- [x] Test cascading deletes work properly

### Database Operations
- [x] Run all migrations successfully
- [x] Verify database schema matches requirements
- [x] Create sample seed data for testing
- [x] Test database rollback functionality

### Routing Setup
- [x] Configure routes for club-specific URLs:
  - `GET /:club_slug` -> show race for club
  - `GET /:club_slug/admin` -> admin interface
- [x] Add route constraints for valid club slugs
- [x] Test routing configuration is properly set up

### Comprehensive Testing
- [x] Create comprehensive unit tests for Club model:
  - Slug validation and generation
  - Name requirements
  - Association tests
- [x] Create comprehensive unit tests for Race model:
  - Counter validation rules
  - At Gate < In Staging validation
  - Minimum value validations
  - Association tests
- [x] Create comprehensive unit tests for RaceSettings model:
  - Time validations
  - Notification functionality
  - Association tests
- [x] Add integration tests for model interactions
- [x] Test database constraints and foreign keys
- [x] Update all tests with Alberta BMX club names and authentic racing scenarios

### Console Verification
- [x] Verify models work in Rails console:
  - Create Club with valid/invalid data
  - Create Race with valid/invalid counter values
  - Test validation error messages
  - Verify associations work correctly

## Testing Instructions
1. Run `rails console` and test:
   ```ruby
   # Club creation
   club = Club.create(name: "Test BMX Club", slug: "test-bmx-club")
   
   # Race creation with valid counters
   race = club.races.create(at_gate: 0, in_staging: 1)
   
   # Test validation rules
   race.update(at_gate: 5, in_staging: 3) # Should fail
   race.update(at_gate: 2, in_staging: 4) # Should succeed
   ```

2. Run test suite: `rails test`
3. Verify URL routing works in browser

## Completion Criteria
- [x] All models created with proper attributes and relationships
- [x] All validation rules implemented and working correctly
- [x] Database migrations run successfully
- [x] Comprehensive unit tests passing (29 tests, 92 assertions, 0 failures)
- [x] Integration tests passing
- [x] Club-specific URL routing functional
- [x] Sample data can be created via console
- [x] All foreign key constraints working
- [x] **Ready for review**

## Branch Management
- [x] Create feature branch: `phase-1-database-models`
- [ ] Commit changes in logical groups:
  - "Add Club model with slug-based routing"
  - "Add Race model with dual counter validations"  
  - "Add RaceSettings model for admin features"
  - "Configure club-specific URL routing"
- [ ] Ready for merge after review approval

## Phase 1 Status: COMPLETE ✅
All database models, validations, associations, and tests implemented successfully with authentic Alberta BMX racing scenarios. Ready for user review and approval to proceed to Phase 2.