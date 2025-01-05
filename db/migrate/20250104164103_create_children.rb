class CreateChildren < ActiveRecord::Migration[8.0]
  def change
    create_table :children do |t|
      t.references :group, null: false, foreign_key: true
      t.string :first_name, null: false
      t.string :middle_name, null: false
      t.string :last_name, null: false
      t.integer :account_number, null: false, unique: true
      t.boolean :active, null: false, default: false

      t.timestamps
    end
  end
end
