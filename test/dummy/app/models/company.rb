class Company < ApplicationRecord
  validates :name, presence: true
  validates :published, presence: true, inclusion: { in: [true, false] }
end
