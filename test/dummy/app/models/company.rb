class Company < ApplicationRecord
  has_many :users

  validates :name, presence: true
  validates :published, presence: true, inclusion: { in: [true, false] }
end
