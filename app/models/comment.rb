# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  belongs_to :reply, class_name: 'Comment', optional: true

  has_many :replies, class_name: 'Comment', foreign_key: 'comment_id'
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :reports, as: :reportable, dependent: :destroy

  validates :body, presence: true

  scope :with_no_replies, -> { where(comment_id: nil) }
end
