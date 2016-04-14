Spree::Api::V1::StockLocationsController.class_eval do

  before_filter :experience_locations, only: [:index]
  before_filter :experience_transfers, only: [:index]

  private

  def experience_locations
    params[:q] ||= {}
    params[:q][:experience_id_eq] = spree_current_user.experience_id
  end

  def experience_transfers
    params[:q] ||= {}
    params[:q][:experience_id_eq] = spree_current_user.experience_id
  end

end