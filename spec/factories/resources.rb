FactoryBot.define do
    factory :resource do
      title { "Sample Resource" }
      description { "A sample resource description." }
      status { "pending" }
      feedback { "Great job!" }
      association :author, factory: :user 
    end
end
  