class Spree::Admin::ExperienceDropShipSettingsController < Spree::Admin::BaseController

  def edit
    @config = Spree::ExperienceDropShipConfiguration.new
  end

  def update
    config = Spree::ExperienceDropShipConfiguration.new

    params.each do |name, value|
      next unless config.has_preference? name
      config[name] = value
    end

    flash[:success] = Spree.t('admin.experience_drop_ship_settings.update.success')
    redirect_to spree.edit_admin_experience_drop_ship_settings_path
  end

end