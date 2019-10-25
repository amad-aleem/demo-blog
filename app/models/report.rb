class Report < ApplicationRecord
  belongs_to :reportable, polymorphic: true
  belongs_to :user

  validates :body, presence: true

  scope :recent, -> {order(created_at: :desc)}
end
