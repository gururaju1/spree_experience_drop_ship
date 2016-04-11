require 'spec_helper'

describe Spree.user_class do

  it { should belong_to(:experience) }

  it { should have_many(:variants).through(:experience) }

  let(:user) { build :user }

  it '#experience?' do
    user.experience?.should be false
    user.experience = build :experience
    user.experience?.should be true
  end

end