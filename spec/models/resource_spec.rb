require 'rails_helper'

RSpec.describe Resource, type: :model do
  let(:restaurants_type) { ResourceType.new(title: "Restaurants") }
  let(:user) { User.all[0] }

  # valid with all required fields
  it "is valid with all required fields" do 
    # required fields: author, resource type, title, description
    canes = Resource.new( author: :user, 
                          resourceType: restaurants_type,
                          title: "Raising Canes",
                          description: "Chicken fingers")
    expect(canes).to be_valid
  end

  # invalid without any required field
  it "is invalid when missing any required field" do 
    # without author
    canes = Resource.new( resourceType: restaurants_type,
                          title: "Raising Canes",
                          description: "Chicken fingers")
    expect(canes).not_to be_valid
    # without type
    canes = Resource.new( author: :user, 
                          title: "Raising Canes",
                          description: "Chicken fingers")
    expect(canes).not_to be_valid
    # without title
    canes = Resource.new( author: :user, 
                          resourceType: restaurants_type,
                          description: "Chicken fingers")
    expect(canes).not_to be_valid
    # without description
    canes = Resource.new( author: :user, 
                          resourceType: restaurants_type,
                          title: "Raising Canes")
    expect(canes).not_to be_valid
  end

  # status defaults to "pending" for new resources
  it "defaults to 'pending' status upon creation" do 
    canes = Resource.new( author: :user, 
                          resourceType: restaurants_type,
                          title: "Raising Canes",
                          description: "Chicken fingers")
    expect(canes.status).to eq("pending")
  end

end