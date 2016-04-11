module Spree
  class ExperienceDropShipConfiguration < Preferences::Configuration

    # Automatically deliver drop ship orders by default.
    preference :automatically_deliver_orders_to_experience, :boolean, default: true

    # Default flat rate to charge experiences per order for commission.
    preference :default_commission_flat_rate, :float, default: 0.0

    # Default percentage to charge experiences per order for commission.
    preference :default_commission_percentage, :float, default: 0.0

    # Determines whether or not to email a new experience their welcome email.
    preference :send_experience_email, :boolean, default: true

  end
end