class Tag < ApplicationRecord
  has_and_belongs_to_many :posts
  has_many :users, through: :user_tags

  validates :name, presence: true, uniqueness: true
end
