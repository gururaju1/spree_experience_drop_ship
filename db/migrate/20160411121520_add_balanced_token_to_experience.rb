class AddBalancedTokenToExperience < ActiveRecord::Migration
  def change
    add_column :spree_experiences, :tax_id, :string
    add_column :spree_experiences, :token, :string
    add_index :spree_experiences, :token
  end
end