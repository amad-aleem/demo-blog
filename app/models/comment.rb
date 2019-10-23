class Comment < ApplicationRecord
  has_many :replies, class_name: 'Comment', foreign_key: 'comment_id'

  belongs_to :post
  belongs_to :user
  belongs_to :reply, class_name: 'Comment', optional: true

  validates :body, presence: true
end
