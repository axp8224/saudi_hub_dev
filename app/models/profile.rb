class Profile < ApplicationRecord
  belongs_to :user
  belongs_to :role
  belongs_to :major
end
