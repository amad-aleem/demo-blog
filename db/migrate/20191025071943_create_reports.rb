# frozen_string_literal: true

class CreateReports < ActiveRecord::Migration[5.1]
  def change
    create_table :reports do |t|
      t.references :reportable, polymorphic: true
      t.references :user, foreign_key: true
      t.text :body

      t.timestamps
    end
  end
end
