class Resource < ApplicationRecord
  belongs_to :resource_type
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  validates :title, presence: true
  validates :description, presence: true
  validates :status, presence: true, inclusion: { in: ['active', 'pending', 'archived'] }
end
