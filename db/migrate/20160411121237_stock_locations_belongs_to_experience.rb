class StockLocationsBelongsToExperience < ActiveRecord::Migration
  def change
    add_column :spree_stock_locations, :experience_id, :integer
    add_index :spree_stock_locations, :experience_id
  end
end