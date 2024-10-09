require 'rails_helper'

RSpec.describe Resource, type: :model do
  
  # validates :title, presence: true
  # validates :description, presence: true
  # validates :status, presence: true, inclusion: { in: ['active', 'pending', 'archived'] }

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:status) }

  end

  describe "associations" do 
    it { should belong_to(:author) }
    it { should belong_to(:resource_type) }

  end

end
