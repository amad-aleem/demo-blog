# frozen_string_literal: true

class AddRoleToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :role, :string, default: 'member'
  end
end
