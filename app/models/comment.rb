class Comment < ApplicationRecord
  has_many :replies, class_name: 'Comment', foreign_key: 'comment_id'
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :reports, as: :reportable, dependent: :destroy
  
  belongs_to :post
  belongs_to :user
  belongs_to :reply, class_name: 'Comment', optional: true

  validates :body, presence: true
end
