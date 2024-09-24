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

majors = ([
  { name: "" },
  { name: "Accounting" },
  { name: "Aerospace Engineering" },
  { name: "Agribusiness" },
  { name: "Agricultural Communications & Journalism" },
  { name: "Agricultural Economics" },
  { name: "Agricultural Leadership & Development" },
  { name: "Agricultural Science" },
  { name: "Agricultural Systems Management" },
  { name: "Animal Science" },
  { name: "Anthropology" },
  { name: "Applied Mathematics" },
  { name: "Architectural Engineering" },
  { name: "Architecture" },
  { name: "Biochemistry" },
  { name: "Bioenvironmental Sciences" },
  { name: "Biological & Agricultural Engineering" },
  { name: "Biology" },
  { name: "Biomedical Engineering" },
  { name: "Biomedical Sciences" },
  { name: "Business Administration" },
  { name: "Business Honors" },
  { name: "Chemical Engineering" },
  { name: "Chemistry" },
  { name: "Civil Engineering" },
  { name: "Classics" },
  { name: "Coastal Environmental Science & Society" },
  { name: "Communication" },
  { name: "Community Health" },
  { name: "Computer Engineering" },
  { name: "Computer Science" },
  { name: "Computing" },
  { name: "Construction Science" },
  { name: "Dance Science" },
  { name: "Data Engineering" },
  { name: "Ecology & Conservation Biology" },
  { name: "Economics" },
  { name: "Education - Bilingual Education" },
  { name: "Education - Language Arts/Social Studies Middle Grades Certification" },
  { name: "Education - Math/Science Middle Grades Certification" },
  { name: "Education - PreK-6 Generalist Certification" },
  { name: "Education - Special Education" },
  { name: "Electrical Engineering" },
  { name: "Electronic Systems Engineering Technology" },
  { name: "English" },
  { name: "Entomology" },
  { name: "Environmental Engineering" },
  { name: "Environmental Geosciences" },
  { name: "Environmental Studies" },
  { name: "Finance" },
  { name: "Financial Planning" },
  { name: "Food Science & Technology" },
  { name: "Forensic & Investigative Sciences" },
  { name: "General Studies" },
  { name: "Genetics" },
  { name: "Geographic Information Science & Technology" },
  { name: "Geography" },
  { name: "Geology" },
  { name: "Geophysics" },
  { name: "Health" },
  { name: "History" },
  { name: "Horticulture" },
  { name: "Hospitality, Hotel Management, & Tourism" },
  { name: "Human Resource Development" },
  { name: "Industrial & Systems Engineering" },
  { name: "Industrial Distribution" },
  { name: "Information Technology Service Management" },
  { name: "Interdisciplinary Engineering" },
  { name: "International Affairs" },
  { name: "International Studies" },
  { name: "International Studies (Politics & Diplomacy Track)" },
  { name: "Journalism" },
  { name: "Kinesiology - Dance Science" },
  { name: "Kinesiology - Exercise & Sport Science" },
  { name: "Kinesiology - Exercise Science" },
  { name: "Landscape Architecture" },
  { name: "Management" },
  { name: "Management Information Systems" },
  { name: "Manufacturing & Mechanical Engineering Technology" },
  { name: "Marine Biology" },
  { name: "Marine Engineering Technology" },
  { name: "Marine Fisheries" },
  { name: "Marine Sciences" },
  { name: "Marine Transportation" },
  { name: "Maritime Business Administration" },
  { name: "Maritime Studies" },
  { name: "Marketing" },
  { name: "Materials Science & Engineering" },
  { name: "Mathematics" },
  { name: "Mechanical Engineering" },
  { name: "Meteorology" },
  { name: "Microbiology" },
  { name: "Modern Languages (French, German, or Russian)" },
  { name: "Molecular and Cell Biology" },
  { name: "Multidisciplinary Engineering Technology" },
  { name: "Neuroscience - Behavioral and Cognitive Track" },
  { name: "Neuroscience - Molecular and Cellular Track" },
  { name: "Nuclear Engineering" },
  { name: "Nursing" },
  { name: "Nutrition" },
  { name: "Ocean Engineering" },
  { name: "Ocean Studies" },
  { name: "Oceanography" },
  { name: "Performance & Visual Studies" },
  { name: "Petroleum Engineering" },
  { name: "Philosophy" },
  { name: "Physics" },
  { name: "Plant & Environmental Soil Science" },
  { name: "Political Science" },
  { name: "Poultry Science" },
  { name: "Psychology" },
  { name: "Public Health" },
  { name: "Rangeland, Wildlife, & Fisheries Management" },
  { name: "Recreation Park & Tourism Sciences" },
  { name: "Sociology" },
  { name: "Spanish" },
  { name: "Sport Management" },
  { name: "Statistics" },
  { name: "Supply Chain Management" },
  { name: "Technology Management" },
  { name: "Telecommunication Media Studies" },
  { name: "Turfgrass Science" },
  { name: "University Studies - Arts and Sciences" },
  { name: "University Studies - Business" },
  { name: "University Studies - Global Arts, Planning, Design & Construction" },
  { name: "University Studies - Leadership Studies" },
  { name: "University Studies - Marine Environmental Law & Policy" },
  { name: "University Studies - Mathematics for Secondary Teaching" },
  { name: "University Studies - Oceans & One Health" },
  { name: "University Studies - Race, Gender, & Ethnicity" },
  { name: "University Studies - Society, Ethics, & Law" },
  { name: "University Studies - Tourism & Coastal Community Development" },
  { name: "Urban & Regional Planning" },
  { name: "Visualization" },
  { name: "Wildlife & Fisheries Sciences" },
  { name: "Women's & Gender Studies" },
  { name: "Zoology" }
])

puts "Seeding majors..."

majors.each do |major|
  Major.find_or_create_by(name: major[:name])
end

puts "Seeded A&M majors."

# --------- SEEDING CLASS YEARS TABLE ----------

class_years = [
  { name: 'Freshman' },
  { name: 'Sophomore' },
  { name: 'Junior' },
  { name: 'Senior' },
  { name: 'Masters Student' },
  { name: 'PhD Student' },
  { name: 'Other (staff, professor, etc.)' }
]

class_years.each do |year|
  ClassYear.find_or_create_by(name: year[:name])
end

puts "Seeded class years."

# --------- SEEDING USER ROLES TABLE ------------

Role.find_or_create_by(name: 'user', can_moderate: false, can_promote: false)
Role.find_or_create_by(name: 'admin', can_moderate: true, can_promote: true)

puts "Seeded user roles."