FactoryBot.define do
    factory :resource do
      title { "Sample Resource" }
      description { "A sample resource description." }
      status { "pending" }
      feedback { "Great job!" }
      association :author, factory: :user
      resource_type { ResourceType.create(name: "Default Type") }  
    end
  end
  