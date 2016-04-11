module Spree
  class ExperienceDropShipOrderMailer < Spree::BaseMailer

    default from: Spree::Store.current.mail_from_address

    def experience_order(shipment_id)
      @shipment = Shipment.find shipment_id
      @experience = @shipment.experience
      mail to: @experience.email, subject: Spree.t('experience_drop_ship_order_mailer.experience_order.subject', name: Spree::Store.current.name, number: @shipment.number)
    end

  end
end