class Post < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :tags

  enum status: %i[draft published deleted]
end
