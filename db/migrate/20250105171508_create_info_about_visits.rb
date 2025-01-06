class CreateInfoAboutVisits < ActiveRecord::Migration[8.0]
  def change
    create_table :info_about_visits do |t|
      t.references :child, null: false, foreign_key: true
      t.date :date, null: false
      t.boolean :kindergarten_visited, null: false
      t.integer :reason

      t.timestamps
    end
  end
end
