# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :validatable, :lockable, :confirmable
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :reports, as: :reportable, dependent: :destroy

  enum role: { Member: 'Member', Moderator: 'Moderator', Admin: 'Admin' }
end
