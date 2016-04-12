module Spree
  module Stock
    module Splitter
      class ExperienceDropShip < Spree::Stock::Splitter::Base

        def split(packages)
          split_packages = []
          packages.each do |package|
            # Package fulfilled items together.
            fulfilled = package.contents.select { |content| content.variant.experiences.count == 0 }
            split_packages << build_package(fulfilled)
            # Determine which experience to package drop shipped items.
            experience_drop_ship = package.contents.select { |content| content.variant.experiences.count > 0 }
            experience_drop_ship.each do |content|
              # Select the related variant
              variant = content.variant
              # Select experiences ordering ascending according to cost.
              experiences = variant.experience_variants.order("spree_experience_variants.cost ASC").map(&:experience)
              # Select first experience that has stock location with avialable stock item.
              available_experience = experiences.detect do |experience| 
                experience.stock_locations_with_available_stock_items(variant).any?
              end
              # Select the first available stock location with in the available_experience stock locations.
              stock_location = available_experience.stock_locations_with_available_stock_items(variant).first
              # Add to any existing packages or create a new one.
              if existing_package = split_packages.detect { |p| p.stock_location == stock_location }
                existing_package.contents << content
              else
                split_packages << Spree::Stock::Package.new(stock_location, [content])
              end
            end
          end
          return_next split_packages
        end

      end
    end
  end
end