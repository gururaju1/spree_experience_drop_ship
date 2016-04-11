require 'spec_helper'
require 'cancan/matchers'
require 'spree/testing_support/ability_helpers'

describe Spree::ExperienceAbility do

  let(:user) { create(:user, experience: create(:experience)) }
  let(:ability) { Spree::ExperienceAbility.new(user) }
  let(:token) { nil }

  context 'for Dash' do
    let(:resource) { Spree::Admin::RootController }

    context 'requested by experience' do
      it_should_behave_like 'access denied'
      it_should_behave_like 'no index allowed'
      it_should_behave_like 'admin denied'
    end
  end

  context 'for Product' do
    let(:resource) { create(:product) }

    it_should_behave_like 'index allowed'
    it_should_behave_like 'admin granted'

    context 'requested by another experiences user' do
      let(:resource) {
        product = create(:product)
        product.add_experience!(create(:experience))
        product
      }
      it_should_behave_like 'access denied'
    end

    context 'requested by experiences user' do
      let(:resource) {
        product = create(:product)
        product.add_experience!(user.experience)
        product.reload
      }
      # it_should_behave_like 'access granted'
      it { ability.should be_able_to :read, resource }
      it { ability.should be_able_to :stock, resource }
    end
  end

  context 'for Shipment' do
    context 'requested by another experiences user' do
      let(:resource) { Spree::Shipment.new({stock_location: create(:stock_location, experience: create(:experience))}, without_protection: true) }
      it_should_behave_like 'access denied'
      it_should_behave_like 'no index allowed'
      it_should_behave_like 'admin denied'
      it { ability.should_not be_able_to :ready, resource }
      it { ability.should_not be_able_to :ship, resource }
    end

    context 'requested by experiences user' do
      context 'when order is complete' do
        let(:resource) {
          order = create(:completed_order_for_drop_ship_with_totals)
          order.stock_locations.first.update_attribute :experience, user.experience
          Spree::Shipment.new({order: order, stock_location: order.stock_locations.first }, without_protection: true)
        }
        it_should_behave_like 'access granted'
        it_should_behave_like 'index allowed'
        it_should_behave_like 'admin granted'
        it { ability.should be_able_to :ready, resource }
        it { ability.should be_able_to :ship, resource }
      end

      context 'when order is incomplete' do
        let(:resource) { Spree::Shipment.new({stock_location: create(:stock_location, experience: user.experience)}, without_protection: true) }
        it_should_behave_like 'access denied'
        it { ability.should_not be_able_to :ready, resource }
        it { ability.should_not be_able_to :ship, resource }
      end
    end
  end

  context 'for StockItem' do
    let(:resource) { Spree::StockItem }

    it_should_behave_like 'index allowed'
    it_should_behave_like 'admin granted'

    context 'requested by another experiences user' do
      let(:resource) {
        experience = create(:experience)
        variant = create(:product).master
        variant.product.add_experience! experience
        experience.stock_locations.first.stock_items.first
      }
      it_should_behave_like 'access denied'
    end

    context 'requested by experiences user' do
      let(:resource) {
        variant = create(:product).master
        variant.product.add_experience! user.experience
        user.experience.stock_locations.first.stock_items.first
      }
      it_should_behave_like 'access granted'
    end
  end

  context 'for StockLocation' do
    context 'requsted by another experiences user' do
      let(:resource) {
        experience = create(:experience)
        variant = create(:product).master
        variant.product.add_experience! experience
        experience.stock_locations.first
      }
      it_should_behave_like 'create only'
    end

    context 'requested by experiences user' do
      let(:resource) {
        variant = create(:product).master
        variant.product.add_experience! user.experience
        user.experience.stock_locations.first
      }
      it_should_behave_like 'access granted'
      it_should_behave_like 'admin granted'
      it_should_behave_like 'index allowed'
    end
  end

  context 'for StockMovement' do
    let(:resource) { Spree::StockMovement }

    it_should_behave_like 'index allowed'
    it_should_behave_like 'admin granted'

    context 'requested by another experiences user' do
      let(:resource) {
        experience = create(:experience)
        variant = create(:product).master
        variant.product.add_experience! experience
        Spree::StockMovement.new({ stock_item: experience.stock_locations.first.stock_items.first }, without_protection: true)
      }
      it_should_behave_like 'create only'
    end

    context 'requested by experiences user' do
      let(:resource) {
        variant = create(:product).master
        variant.product.add_experience! user.experience
        Spree::StockMovement.new({ stock_item: user.experience.stock_locations.first.stock_items.first }, without_protection: true)
      }
      it_should_behave_like 'access granted'
    end
  end

  context 'for Experience' do
    context 'requested by any user' do
      let(:ability) { Spree::ExperienceAbility.new(create(:user)) }
      let(:resource) { Spree::Experience }

      it_should_behave_like 'admin denied'
      it_should_behave_like 'access denied'
    end

    context 'requested by experiences user' do
      let(:resource) { user.experience }
      it_should_behave_like 'admin granted'
      it_should_behave_like 'update only'
    end
  end

end