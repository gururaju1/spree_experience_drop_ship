class ProductBelongsToExperience < ActiveRecord::Migration
  def change
    add_column :spree_products, :experience_id, :integer
    add_index :spree_products, :experience_id
  end
end