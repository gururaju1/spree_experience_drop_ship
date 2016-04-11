require 'spec_helper'

describe Spree::Shipment do

  describe 'Scopes' do

    it '#by_experience' do
      experience = create(:experience)
      stock_location_1 = experience.stock_locations.first
      stock_location_2 = create(:stock_location, experience: experience)
      shipment_1 = create(:shipment)
      shipment_2 = create(:shipment, stock_location: stock_location_1)
      shipment_3 = create(:shipment)
      shipment_4 = create(:shipment, stock_location: stock_location_2)
      shipment_5 = create(:shipment)
      shipment_6 = create(:shipment, stock_location: stock_location_1)

      expect(subject.class.by_experience(experience.id)).to match_array([shipment_2, shipment_4, shipment_6])
    end

  end

  describe '#after_ship' do

    it 'should capture payment if balance due' do
      skip 'TODO make it so!'
    end

    it 'should track commission for shipment' do
      experience = create(:experience_with_commission)
      shipment = create(:shipment, stock_location: experience.stock_locations.first)

      expect(shipment.experience_commission.to_f).to eql(0.0)
      shipment.stub final_price_with_items: 10.0
      shipment.send(:after_ship)
      expect(shipment.reload.experience_commission.to_f).to eql(1.5)
    end

  end

  it '#final_price_with_items' do
    shipment = build :shipment
    shipment.stub item_cost: 50.0, final_price: 5.5
    expect(shipment.final_price_with_items.to_f).to eql(55.5)
  end

end