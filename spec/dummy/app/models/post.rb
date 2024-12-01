class Post < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :tags

  enum :status, { draft: 0, published: 1, deleted: 2 }
end
