# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :title, null: false
      t.decimal :price, null: false
      t.boolean :published, default: false
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
