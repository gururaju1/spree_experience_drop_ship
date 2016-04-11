Spree::Admin::StockLocationsController.class_eval do

  create.after :set_experience

  private

  def set_experience
    if try_spree_current_user.experience?
      @object.experience = try_spree_current_user.experience
      @object.save
    end
  end

end