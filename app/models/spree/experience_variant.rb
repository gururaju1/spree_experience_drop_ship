module Spree
  class ExperienceVariant < Spree::Base
    belongs_to :experience
    belongs_to :variant
  end
end