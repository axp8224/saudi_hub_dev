require 'rails_helper'

RSpec.describe Resource, type: :model do
  # Validations
  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:status) }
    it { should validate_inclusion_of(:status).in_array(['active', 'pending', 'archived']) }
  end

  # Associations
  describe "associations" do 
    it { should belong_to(:author) }
    it { should belong_to(:resource_type) }
  end
end