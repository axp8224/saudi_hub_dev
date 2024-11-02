FactoryBot.define do
    factory :resource do
      title { "Sample Resource" }
      description { "A sample resource description." }
      status { "pending" }
      feedback { "Great job!" }
      association :author, factory: :user
      association :resource_type, factory: :resource_type  
    end
  
    factory :resource_type do
      title { "Default Type" } 
    end
  end
  