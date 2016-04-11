Spree::Admin::ProductsController.class_eval do

  before_filter :get_experiences, only: [:edit, :update]
  before_filter :experience_collection, only: [:index]

  private

  def get_experiences
    @experiences = Spree::Experience.order(:name)
  end

  # Scopes the collection to the Experience.
  def experience_collection
    if try_spree_current_user && !try_spree_current_user.admin? && try_spree_current_user.experience?
      @collection = @collection.joins(:experiences).where('spree_experiences.id = ?', try_spree_current_user.experience_id)
    end
  end

end