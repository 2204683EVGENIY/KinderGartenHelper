class CreateGroups < ActiveRecord::Migration[8.0]
  def change
    create_table :groups do |t|
      t.string :title, null: false

      t.timestamps
    end
  end
end
