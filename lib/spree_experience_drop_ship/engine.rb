module SpreeExperienceDropShip
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_experience_drop_ship'
    
    config.autoload_paths += %W(#{config.root}/lib)
    
    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end
    
    initializer 'spree_experience_drop_ship.custom_splitters', after: 'spree.register.stock_splitters' do |app|
      app.config.spree.stock_splitters << Spree::Stock::Splitter::ExperienceDropShip
    end

    initializer "spree_experience_drop_ship.preferences", before: :load_config_initializers  do |app|
      SpreeExperienceDropShip::Config = Spree::ExperienceDropShipConfiguration.new
    end
    
    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
      Spree::Ability.register_ability(Spree::ExperienceAbility)
    end

    config.to_prepare & method(:activate).to_proc
  end
end
