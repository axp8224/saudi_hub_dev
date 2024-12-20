# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# db/seeds.rb
# puts "Starting the seeding process..."

# --------- SEEDING MAJORS TABLE ------------

majors = [
  { name: 'Accounting' },
  { name: 'Aerospace Engineering' },
  { name: 'Agribusiness' },
  { name: 'Agricultural Communications & Journalism' },
  { name: 'Agricultural Economics' },
  { name: 'Agricultural Leadership & Development' },
  { name: 'Agricultural Science' },
  { name: 'Agricultural Systems Management' },
  { name: 'Animal Science' },
  { name: 'Anthropology' },
  { name: 'Applied Mathematics' },
  { name: 'Architectural Engineering' },
  { name: 'Architecture' },
  { name: 'Biochemistry' },
  { name: 'Bioenvironmental Sciences' },
  { name: 'Biological & Agricultural Engineering' },
  { name: 'Biology' },
  { name: 'Biomedical Engineering' },
  { name: 'Biomedical Sciences' },
  { name: 'Business Administration' },
  { name: 'Business Honors' },
  { name: 'Chemical Engineering' },
  { name: 'Chemistry' },
  { name: 'Civil Engineering' },
  { name: 'Classics' },
  { name: 'Coastal Environmental Science & Society' },
  { name: 'Communication' },
  { name: 'Community Health' },
  { name: 'Computer Engineering' },
  { name: 'Computer Science' },
  { name: 'Computing' },
  { name: 'Construction Science' },
  { name: 'Dance Science' },
  { name: 'Data Engineering' },
  { name: 'Ecology & Conservation Biology' },
  { name: 'Economics' },
  { name: 'Education - Bilingual Education' },
  { name: 'Education - Language Arts/Social Studies Middle Grades Certification' },
  { name: 'Education - Math/Science Middle Grades Certification' },
  { name: 'Education - PreK-6 Generalist Certification' },
  { name: 'Education - Special Education' },
  { name: 'Electrical Engineering' },
  { name: 'Electronic Systems Engineering Technology' },
  { name: 'English' },
  { name: 'Entomology' },
  { name: 'Environmental Engineering' },
  { name: 'Environmental Geosciences' },
  { name: 'Environmental Studies' },
  { name: 'Finance' },
  { name: 'Financial Planning' },
  { name: 'Food Science & Technology' },
  { name: 'Forensic & Investigative Sciences' },
  { name: 'General Studies' },
  { name: 'Genetics' },
  { name: 'Geographic Information Science & Technology' },
  { name: 'Geography' },
  { name: 'Geology' },
  { name: 'Geophysics' },
  { name: 'Health' },
  { name: 'History' },
  { name: 'Horticulture' },
  { name: 'Hospitality, Hotel Management, & Tourism' },
  { name: 'Human Resource Development' },
  { name: 'Industrial & Systems Engineering' },
  { name: 'Industrial Distribution' },
  { name: 'Information Technology Service Management' },
  { name: 'Interdisciplinary Engineering' },
  { name: 'International Affairs' },
  { name: 'International Studies' },
  { name: 'International Studies (Politics & Diplomacy Track)' },
  { name: 'Journalism' },
  { name: 'Kinesiology - Dance Science' },
  { name: 'Kinesiology - Exercise & Sport Science' },
  { name: 'Kinesiology - Exercise Science' },
  { name: 'Landscape Architecture' },
  { name: 'Management' },
  { name: 'Management Information Systems' },
  { name: 'Manufacturing & Mechanical Engineering Technology' },
  { name: 'Marine Biology' },
  { name: 'Marine Engineering Technology' },
  { name: 'Marine Fisheries' },
  { name: 'Marine Sciences' },
  { name: 'Marine Transportation' },
  { name: 'Maritime Business Administration' },
  { name: 'Maritime Studies' },
  { name: 'Marketing' },
  { name: 'Materials Science & Engineering' },
  { name: 'Mathematics' },
  { name: 'Mechanical Engineering' },
  { name: 'Meteorology' },
  { name: 'Microbiology' },
  { name: 'Modern Languages (French, German, or Russian)' },
  { name: 'Molecular and Cell Biology' },
  { name: 'Multidisciplinary Engineering Technology' },
  { name: 'Neuroscience - Behavioral and Cognitive Track' },
  { name: 'Neuroscience - Molecular and Cellular Track' },
  { name: 'Nuclear Engineering' },
  { name: 'Nursing' },
  { name: 'Nutrition' },
  { name: 'Ocean Engineering' },
  { name: 'Ocean Studies' },
  { name: 'Oceanography' },
  { name: 'Performance & Visual Studies' },
  { name: 'Petroleum Engineering' },
  { name: 'Philosophy' },
  { name: 'Physics' },
  { name: 'Plant & Environmental Soil Science' },
  { name: 'Political Science' },
  { name: 'Poultry Science' },
  { name: 'Psychology' },
  { name: 'Public Health' },
  { name: 'Rangeland, Wildlife, & Fisheries Management' },
  { name: 'Recreation Park & Tourism Sciences' },
  { name: 'Sociology' },
  { name: 'Spanish' },
  { name: 'Sport Management' },
  { name: 'Statistics' },
  { name: 'Supply Chain Management' },
  { name: 'Technology Management' },
  { name: 'Telecommunication Media Studies' },
  { name: 'Turfgrass Science' },
  { name: 'University Studies - Arts and Sciences' },
  { name: 'University Studies - Business' },
  { name: 'University Studies - Global Arts, Planning, Design & Construction' },
  { name: 'University Studies - Leadership Studies' },
  { name: 'University Studies - Marine Environmental Law & Policy' },
  { name: 'University Studies - Mathematics for Secondary Teaching' },
  { name: 'University Studies - Oceans & One Health' },
  { name: 'University Studies - Race, Gender, & Ethnicity' },
  { name: 'University Studies - Society, Ethics, & Law' },
  { name: 'University Studies - Tourism & Coastal Community Development' },
  { name: 'Urban & Regional Planning' },
  { name: 'Visualization' },
  { name: 'Wildlife & Fisheries Sciences' },
  { name: "Women's & Gender Studies" },
  { name: 'Zoology' }
]

puts 'Seeding majors...'

majors.each do |major|
  Major.find_or_create_by(name: major[:name])
end

puts 'Seeded A&M majors.'

# --------- SEEDING CLASS YEARS (CLASSIFICATION) TABLE ----------

class_years = [
  { name: 'Freshman' },
  { name: 'Sophomore' },
  { name: 'Junior' },
  { name: 'Senior' },
  { name: 'Masters Student' },
  { name: 'PhD Student' },
  { name: 'Former Student' },
  { name: 'Other (staff, professor, etc.)' }
]

class_years.each do |year|
  ClassYear.find_or_create_by(name: year[:name])
end

puts 'Seeded class years.'

# --------- SEEDING USER ROLES TABLE ------------

Role.find_or_create_by(name: 'user', can_moderate: false, can_promote: false)
Role.find_or_create_by(name: 'admin', can_moderate: true, can_promote: true)

puts 'Seeded user roles.'

# --------- SEEDING SAMPLE USERS ------------

if Rails.env.development? || Rails.env.test?

  puts 'Seeding sample user...'

  # Find or create the default role (assuming 'user' is the default role)
  default_role = Role.find_by(name: 'user')

  # Find or create the default major
  default_major = nil

  # Find or create a default class year (assuming 'Freshman' as default)
  default_class_year = ClassYear.find_by(name: 'Freshman')

  User.find_or_create_by!(email: 'sample@example.com') do |user|
    user.uid = 'sample123'
    user.full_name = 'Sample User0'
    user.avatar_url = 'https://example.com/sample_avatar.jpg'
    user.role = default_role
    user.major = default_major
    user.class_year = default_class_year
    # NOTE: We're not setting a password as the model uses omniauthable
  end

  puts 'Sample user seeded successfully.'

  # --------- SEEDING SAMPLE ADMIN ------------
  puts 'Seeding sample admin...'

  admin_role = Role.find_by(name: 'admin')

  default_major = nil

  default_class_year = ClassYear.find_by(name: 'Senior')

  User.find_or_create_by!(email: 'admin@example.com') do |user|
    user.uid = 'sampleADMIN123'
    user.full_name = 'Sample Admin'
    user.avatar_url = 'https://example.com/sample_avatar.jpg'
    user.role = admin_role
    user.major = default_major
    user.class_year = default_class_year
  end

  puts 'Sample admin seeded successfully.'

  puts 'Seeding sample users...'

  user_role = Role.find_by(name: 'user')
  majors = Major.pluck(:id)
  class_years = ClassYear.pluck(:id)

  20.times do |i|
    User.find_or_create_by!(email: "sample#{i + 1}@example.com") do |user|
      user.uid = "sampleuser#{i + 1}"
      user.full_name = "Sample-User#{i + 1}"
      user.avatar_url = 'https://example.com/sample_avatar.jpg'
      user.role = user_role
      user.major_id = majors.sample
      user.class_year_id = class_years.sample
    end
  end

  puts 'Sample users seeded successfully.'
end

# --------- SEEDING RESOURCE TYPES ------------

puts 'Seeding resource types...'

resource_types = [
  { title: 'Restaurants' },
  { title: 'Apartments' },
  { title: 'Parks' }
]

resource_types.each do |type|
  ResourceType.find_or_create_by!(title: type[:title])
end

puts 'Resource types seeded successfully.'

# --------- SEEDING SAMPLE RESOURCES ------------

puts 'Seeding sample resources...'

# Find the existing sample user
sample_user = User.find_by(email: 'sample@example.com')

if sample_user.nil?
  puts 'Error: Sample user not found. Please ensure the sample user is seeded first.'
else
  # Create sample resources for each resource type
  restaurants = [
    { name: "Layne's Chicken Fingers", description: 'Famous for their crispy chicken fingers and secret sauce.',
      address: '106 Walton Dr, College Station, TX 77840' },
    { name: 'Fuego Tortilla Grill', description: '24-hour Tex-Mex spot known for their breakfast tacos.',
      address: '108 Poplar St, College Station, TX 77840' },
    { name: 'Dixie Chicken', description: 'Iconic college bar with a rustic atmosphere and great burgers.',
      address: '307 University Dr, College Station, TX 77840' },
    { name: 'Grub Burger Bar', description: 'Gourmet burgers and spiked milkshakes in a modern setting.',
      address: '980 University Dr E #400, College Station, TX 77840' },
    { name: 'Mess Waffles', description: 'Serving both sweet and savory waffles, perfect for late-night cravings.',
      address: '1716 Southwest Pkwy #100, College Station, TX 77840' }
  ]

  apartments = [
    { name: 'The Rise at Northgate', description: 'Luxury student apartments steps away from campus.' },
    { name: 'The Stack', description: 'Modern high-rise with great amenities and city views.' },
    { name: 'Park West', description: 'Spacious apartments with a resort-style pool and fitness center.' }
  ]

  parks = [
    { name: 'Research Park', description: 'Large green space perfect for outdoor studying and relaxation.' },
    { name: 'Lick Creek Park', description: 'Natural area with hiking and biking trails.' },
    { name: 'Wolf Pen Creek Park', description: 'Features an amphitheater and hosts community events.' },
    { name: 'Bee Creek Park', description: 'Family-friendly park with playgrounds and picnic areas.' }
  ]

  restaurant_type = ResourceType.find_by(title: 'Restaurants')
  apartment_type = ResourceType.find_by(title: 'Apartments')
  park_type = ResourceType.find_by(title: 'Parks')

  restaurants.each do |restaurant|
    Resource.find_or_create_by!(
      user_id: sample_user.id,
      resource_type: restaurant_type,
      title: restaurant[:name],
      description: restaurant[:description],
      address: restaurant[:address],
      status: 'active'
    )
  end

  apartments.each do |apartment|
    Resource.find_or_create_by!(
      user_id: sample_user.id,
      resource_type: apartment_type,
      title: apartment[:name],
      description: apartment[:description],
      status: 'active'
    )
  end

  parks.each do |park|
    Resource.find_or_create_by!(
      user_id: sample_user.id,
      resource_type: park_type,
      title: park[:name],
      description: park[:description],
      status: 'active'
    )
  end

  puts 'Sample resources seeded successfully.'

  # --------- SEEDING SAMPLE 0THER USER ------------
  puts 'Seeding sample other user...'
  # purpose: viewing My Posts (or other things specific to yourself), you should not be able to see posts by other users.

  # Find or create the default role (assuming 'user' is the default role)
  default_role = Role.find_by(name: 'user')

  # Find or create the default major (assuming '' is the default major)
  default_major = Major.find_by(name: '')

  # Find or create a default class year (assuming 'Freshman' as default)
  default_class_year = ClassYear.find_by(name: 'Freshman')

  User.find_or_create_by!(email: 'sample2@example.com') do |user|
    user.uid = 'sample321'
    user.full_name = 'Other User'
    user.avatar_url = 'https://example.com/sample_avatar.jpg'
    user.role = default_role
    user.major = default_major
    user.class_year = default_class_year
    # NOTE: We're not setting a password as the model uses omniauthable
  end

  # make a resource by "someone else"

  sample_other_user = User.find_by(email: 'sample2@example.com')

  restaurant_type = ResourceType.find_by(title: 'Restaurants')

  Resource.find_or_create_by!(
    user_id: sample_other_user.id,
    resource_type: restaurant_type,
    title: "Torchy's Tacos",
    description: 'A taco shop where they serve tacos in the shop.',
    status: 'active'
  )

  puts 'Sample other user seeded successfully.'

  # --------- SEEDING SAMPLE PENDING RESOURCES ------------

  pending_resources = [
    { name: 'Piada Italian Street Food',
      description: 'Specializing in handmade piadas and authentic Italian dishes, perfect for a quick and delicious meal.', type: restaurant_type },
    { name: 'The Woodlands of College Station',
      description: 'Some units are actually quite nice. Management is incompetent. Floods like nobody\'s business. You will regret living here.', type: apartment_type, feedback: 'Test feedback' }
  ]

  pending_resources.each do |resource|
    Resource.find_or_create_by!(
      user_id: sample_user.id,
      resource_type: resource[:type],
      title: resource[:name],
      description: resource[:description],
      status: 'pending',
      feedback: resource[:feedback]
    )
  end

  puts 'Sample pending resources seeded successfully.'

end
