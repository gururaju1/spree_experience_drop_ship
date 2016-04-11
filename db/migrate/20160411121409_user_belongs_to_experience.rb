class UserBelongsToExperience < ActiveRecord::Migration
  def change
    add_column Spree.user_class.table_name, :experience_id, :integer
    add_index Spree.user_class.table_name, :experience_id
  end
end