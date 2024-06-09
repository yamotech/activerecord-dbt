class User < ApplicationRecord
  belongs_to :company, optional: true
  has_one :profile
  has_many :posts
  has_many :tags, through: :user_tags

  has_many :active_relationships,
           class_name: :Relationship,
           foreign_key: :follower_id,
           dependent: :destroy
  has_many :passive_relationships,
           class_name: :Relationship,
           foreign_key: :followed_id,
           dependent: :destroy
end
