Spree::Order.class_eval do

  has_many :stock_locations, through: :shipments
  has_many :experiences, through: :stock_locations

  # Once order is finalized we want to notify the experiences of their drop ship orders.
  # Here we are handling notification by emailing the experiences.
  # If you want to customize this you could override it as a hook for notifying a experience with a API request instead.
  def finalize_with_experience_drop_ship!
    finalize_without_experience_drop_ship!
    shipments.each do |shipment|
      if SpreeExperienceDropShip::Config[:send_experience_email] && shipment.experience.present?
        begin
          Spree::ExperienceDropShipOrderMailer.experience_order(shipment.id).deliver!
        rescue => ex #Errno::ECONNREFUSED => ex
          puts ex.message
          puts ex.backtrace.join("\n")
          Rails.logger.error ex.message
          Rails.logger.error ex.backtrace.join("\n")
          return true # always return true so that failed email doesn't crash app.
        end
      end
    end
  end
  alias_method_chain :finalize!, :experience_drop_ship

end