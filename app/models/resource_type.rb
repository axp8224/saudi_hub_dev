class ResourceType < ApplicationRecord
  has_many :resources

  validates :title, presence: true, uniqueness: true
end
