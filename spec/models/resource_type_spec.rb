require 'rails_helper'

RSpec.describe ResourceType, type: :model do
  
  it "is valid with a title" do 
    housing_type = ResourceType.new(title: "Housing")
    expect(housing_type).to be_valid
  end

  it "is invalid without a title" do 
    nameless_type = ResourceType.new()
    expect(nameless_type).not_to be_valid
  end

  it "has a unique title" do 
    ResourceType.create!(title: "Housing")
    duplicate = ResourceType.new(title: "Housing")

    expect(duplicate).not_to be_valid
  end

end
