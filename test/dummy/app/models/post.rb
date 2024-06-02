class Post < ApplicationRecord
  belongs_to :user

  enum status: %i[draft published deleted]
end
