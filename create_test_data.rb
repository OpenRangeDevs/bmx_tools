# Create test clubs with Alberta BMX names
calgary = Club.create!(name: 'Calgary Olympic BMX Club', slug: 'calgary-olympic-bmx')
edmonton = Club.create!(name: 'Edmonton BMX Association', slug: 'edmonton-bmx')  
red_deer = Club.create!(name: 'Red Deer BMX Association', slug: 'red-deer-bmx')

puts 'Created test clubs:'
puts '- ' + calgary.name + ' (' + calgary.slug + ')'
puts '- ' + edmonton.name + ' (' + edmonton.slug + ')'  
puts '- ' + red_deer.name + ' (' + red_deer.slug + ')'
puts ''
puts 'Test URLs:'
puts 'http://localhost:3000/calgary-olympic-bmx'
puts 'http://localhost:3000/edmonton-bmx/admin'