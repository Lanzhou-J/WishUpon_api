class Hobby < ApplicationRecord
    validates :name, presence: true, length: {in: 2..30}
    has_many :user_hobbies
    has_many :users, through: :user_hobbies
end