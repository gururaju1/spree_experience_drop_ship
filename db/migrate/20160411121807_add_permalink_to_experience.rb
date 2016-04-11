class AddPermalinkToExperience < ActiveRecord::Migration
  def change
    add_column :spree_experiences, :slug, :string
    add_index :spree_experiences, :slug, unique: true
  end
end
