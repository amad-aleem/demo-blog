class Post < ApplicationRecord
  belongs_to :user

  scope :recent, ->{order(created_at: :desc)}
  scope :published, ->{where(published: true)}
end
