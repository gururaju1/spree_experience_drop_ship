module Spree
  class ExperienceAbility
    include CanCan::Ability

    def initialize(user)
      user ||= Spree.user_class.new

      if user.experience
        # TODO: Want this to be inline like:
        # can [:admin, :read, :stock], Spree::Product, experiences: { id: user.experience_id }
        # can [:admin, :read, :stock], Spree::Product, experience_ids: user.experience_id
        can [:admin, :read, :stock], Spree::Product do |product|
          product.experience_ids.include?(user.experience_id)
        end
        can [:admin, :index], Spree::Product
        can [:admin, :manage, :read, :ready, :ship], Spree::Shipment, order: { state: 'complete' }, stock_location: { experience_id: user.experience_id }
        can [:admin, :create, :update], :stock_items
        can [:admin, :manage], Spree::StockItem, stock_location_id: user.experience.stock_locations.pluck(:id)
        can [:admin, :manage], Spree::StockLocation, experience_id: user.experience_id
        can :create, Spree::StockLocation
        can [:admin, :manage], Spree::StockMovement, stock_item: { stock_location_id: user.experience.stock_locations.pluck(:id) }
        can :create, Spree::StockMovement
        can [:admin, :update], Spree::Experience, id: user.experience_id
      end

    end
  end
end