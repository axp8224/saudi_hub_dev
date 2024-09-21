class Role < ApplicationRecord
    has_many :profiles, dependent: :nullify
end
