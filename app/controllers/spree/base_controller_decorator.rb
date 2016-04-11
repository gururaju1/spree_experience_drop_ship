Spree::BaseController.class_eval do

  prepend_before_filter :redirect_experience

  private

  def redirect_experience
    if ['/admin', '/admin/authorization_failure'].include?(request.path) && try_spree_current_user.try(:experience)
      redirect_to '/admin/shipments' and return false
    end
  end

end