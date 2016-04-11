class AddExperienceCommissionToShipments < ActiveRecord::Migration
  def change
    add_column :spree_shipments, :experience_commission, :decimal, precision: 8, scale: 2, default: 0.0, null: false
  end
end
