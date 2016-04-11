class CreateSpreeExperienceVariants < ActiveRecord::Migration
  def change
    create_table :spree_experience_variants do |t|
      t.belongs_to :experience, index: true
      t.belongs_to :variant, index: true
      t.decimal :cost

      t.timestamps
    end
    Spree::Product.where.not(experience_id: nil).each do |product|
      product.add_experience! product.experience_id
    end
    remove_column :spree_products, :experience_id
  end
end
