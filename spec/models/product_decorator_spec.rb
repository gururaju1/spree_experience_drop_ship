require 'spec_helper'

describe Spree::Product do

  let(:product) { create :product }

  it '#experience?' do
    product.experience?.should eq false
    product.add_experience! create(:experience)
    product.reload.experience?.should eq true
  end

end