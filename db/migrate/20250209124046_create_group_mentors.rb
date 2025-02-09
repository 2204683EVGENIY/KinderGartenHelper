class CreateGroupMentors < ActiveRecord::Migration[8.0]
  def change
    create_table :group_mentors do |t|
      t.references :mentor, null: false, foreign_key: true
      t.references :group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
