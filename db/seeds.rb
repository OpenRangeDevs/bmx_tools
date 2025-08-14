# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create Super Admin user for platform administration
puts "Creating Super Admin user..."
super_admin = User.find_or_create_by(email: 'roger@openrangedevs.com') do |user|
  user.password = 'roger123!'
end

# Create Super Admin permission for race_management tool
permission = ToolPermission.find_or_create_by(
  user: super_admin,
  tool: :race_management,
  role: :super_admin
) do |perm|
  perm.club = nil  # Super admin has no specific club
end

puts "✅ Created Super Admin: #{super_admin.email} (role: #{permission.role})"

# Create additional test users for Phase 6.5 testing
puts "Creating test users for Phase 6.5 Club Settings..."

# Club Admin User
club_admin = User.find_or_create_by(email: 'calgary.admin@bmxtools.com') do |user|
  user.password = 'roger123!'
end

# Club Operator User
club_operator = User.find_or_create_by(email: 'airdrie.operator@bmxtools.com') do |user|
  user.password = 'roger123!'
end

# Regular User (no admin permissions)
regular_user = User.find_or_create_by(email: 'member@bmxtools.com') do |user|
  user.password = 'roger123!'
end

puts "✅ Created test users: #{club_admin.email}, #{club_operator.email}, #{regular_user.email}"

# Now create the clubs first so we can assign permissions
puts "Creating Alberta BMX clubs first for permission assignments..."


# Alberta BMX clubs (real club names)
alberta_clubs = [
  {
    name: "Calgary BMX Association",
    slug: "calgary-bmx",
    location: "Calgary, AB"
  },
  {
    name: "Edmonton BMX Club",
    slug: "edmonton-bmx",
    location: "Edmonton, AB"
  },
  {
    name: "Red Deer BMX",
    slug: "red-deer-bmx",
    location: "Red Deer, AB"
  },
  {
    name: "Lethbridge BMX Track",
    slug: "lethbridge-bmx",
    location: "Lethbridge, AB"
  },
  {
    name: "Medicine Hat BMX",
    slug: "medicine-hat-bmx",
    location: "Medicine Hat, AB"
  },
  {
    name: "Airdrie BMX",
    slug: "airdrie-bmx",
    location: "Airdrie, AB"
  }
]

alberta_clubs.each do |club_data|
  club = Club.find_or_create_by(slug: club_data[:slug]) do |c|
    c.name = club_data[:name]
    c.location = club_data[:location]
    c.timezone = "Mountain Time (US & Canada)"
  end

  puts "✅ Created/found club: #{club.name} (#{club.slug})"

  # Create race with realistic moto counts
  race = club.race || club.create_race!(
    at_gate: rand(0..8),      # 0-8 motos at gate (realistic for BMX)
    in_staging: rand(8..15)   # 8-15 motos in staging (always >= at_gate)
  )

  # Ensure business rule compliance
  if race.at_gate > race.in_staging
    race.update!(in_staging: race.at_gate + rand(1..5))
  end

  puts "  🏁 Race status: #{race.at_gate} at gate, #{race.in_staging} in staging"

  # Create race settings
  race_setting = race.race_setting || race.create_race_setting!(
    race_start_time: 3.hours.from_now,  # Race starts in 3 hours
    registration_deadline: 1.hour.from_now,  # Registration closes in 1 hour
    notification_message: [ "Gates opening soon!", "Registration closing!", nil ].sample,
    notification_expires_at: [ 30.minutes.from_now, nil ].sample
  )

  notification_status = race_setting.notification_active? ? 'active' : 'inactive'
  puts "  ⚙️  Settings: race starts #{race_setting.race_start_time&.strftime('%H:%M')}, notifications #{notification_status}"
end

# Create tool permissions for test users now that clubs exist
puts "Creating tool permissions for test users..."

calgary_club = Club.find_by(slug: 'calgary-bmx')
airdrie_club = Club.find_by(slug: 'airdrie-bmx')

# Club Admin for Calgary BMX
if calgary_club
  calgary_admin_permission = ToolPermission.find_or_create_by(
    user: club_admin,
    tool: :race_management,
    club: calgary_club
  ) do |perm|
    perm.role = :club_admin
  end
  puts "✅ Created club admin permission: #{club_admin.email} → #{calgary_club.name} (role: #{calgary_admin_permission.role})"
end

# Club Operator for Airdrie BMX
if airdrie_club
  airdrie_operator_permission = ToolPermission.find_or_create_by(
    user: club_operator,
    tool: :race_management,
    club: airdrie_club
  ) do |perm|
    perm.role = :club_operator
  end
  puts "✅ Created club operator permission: #{club_operator.email} → #{airdrie_club.name} (role: #{airdrie_operator_permission.role})"
end

puts "\n🎯 Alberta BMX test data creation complete!"
puts "\nTest these URLs:"
alberta_clubs.each do |club_data|
  puts "  Public:  http://localhost:3000/#{club_data[:slug]}"
  puts "  Admin:   http://localhost:3000/#{club_data[:slug]}/admin"
end

puts "\n📝 Note: Use realistic moto progression when testing:"
puts "  - At Gate should always be ≤ In Staging"
puts "  - Typical BMX race has 15-25 motos total"
puts "  - Motos progress: 1 at gate → 2-3 in staging → race starts"
