class Log < ApplicationRecord
  belongs_to :user, primary_key: 'email', foreign_key: 'user_email'
end
