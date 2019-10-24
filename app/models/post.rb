class Post < ApplicationRecord
  belongs_to :user
  
  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  validates :title, presence: true, length: {minimum: 5}
  validates :body, presence: true

  scope :recent, ->{order(created_at: :desc)}
  scope :published, ->{where(published: true)}
end
