# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create Alberta BMX test data for development
puts "Creating Alberta BMX test data..."

# Alberta BMX clubs (real club names)
alberta_clubs = [
  {
    name: "Calgary BMX Association", 
    slug: "calgary-bmx"
  },
  {
    name: "Edmonton BMX Club", 
    slug: "edmonton-bmx"
  },
  {
    name: "Red Deer BMX", 
    slug: "red-deer-bmx"
  },
  {
    name: "Lethbridge BMX Track", 
    slug: "lethbridge-bmx"
  },
  {
    name: "Medicine Hat BMX", 
    slug: "medicine-hat-bmx"
  }
]

alberta_clubs.each do |club_data|
  club = Club.find_or_create_by(slug: club_data[:slug]) do |c|
    c.name = club_data[:name]
  end
  
  puts "✅ Created/found club: #{club.name} (#{club.slug})"
  
  # Create active race with realistic moto counts
  race = club.races.active.first || club.races.create!(
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
    notification_message: ["Gates opening soon!", "Registration closing!", nil].sample,
    notification_expires_at: [30.minutes.from_now, nil].sample
  )
  
  notification_status = race_setting.notification_active? ? 'active' : 'inactive'
  puts "  ⚙️  Settings: race starts #{race_setting.race_start_time&.strftime('%H:%M')}, notifications #{notification_status}"
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
