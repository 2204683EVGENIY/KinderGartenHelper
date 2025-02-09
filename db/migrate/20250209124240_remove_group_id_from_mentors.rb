class RemoveGroupIdFromMentors < ActiveRecord::Migration[8.0]
  def change
    remove_column :mentors, :group_id
  end
end
