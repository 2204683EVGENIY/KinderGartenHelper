class CreateMentors < ActiveRecord::Migration[8.0]
  def change
    create_table :mentors do |t|
      t.string :first_name, null: false
      t.string :middle_name, null: false
      t.string :last_name, null: false
      t.references :group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
