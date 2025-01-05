class CreateMonthlyReport < ActiveRecord::Migration[8.0]
  def change
    create_table :monthly_reports do |t|
      t.references :group, null: false, foreign_key: true
      t.references :mentor, null: false, foreign_key: true
      t.date :report_date, null: false
      t.json :data, null: false, default: {}

      t.timestamps
    end
  end
end
