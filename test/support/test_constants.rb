# Test constants for consistent data across all test files
module TestConstants
  # Authentication
  TEST_PASSWORD = "roger123!"

  # User emails (matching fixtures)
  SUPER_ADMIN_EMAIL = "roger@openrangedevs.com"
  CLUB_ADMIN_EMAIL = "calgary.admin@bmxtools.com"

  # Club data
  TEST_CLUB_NAME = "Test BMX Club"
  TEST_CLUB_LOCATION = "Test City, AB"
  TEST_ADMIN_EMAIL = "test@testclub.com"

  # Common assertions
  SUCCESS_REDIRECT_MESSAGE = "Club was successfully created"
  LOGIN_SUCCESS_MESSAGE = "Successfully logged in"
  ACCESS_DENIED_MESSAGE = "Access denied"
  AUTHENTICATION_REQUIRED_MESSAGE = "Please sign in to continue"
end
