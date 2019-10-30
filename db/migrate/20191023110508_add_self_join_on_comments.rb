# frozen_string_literal: true

class AddSelfJoinOnComments < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :comment_id, :integer, foreign_key: true
  end
end
