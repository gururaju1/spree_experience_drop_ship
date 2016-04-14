if defined?(Ckeditor::PicturesController)
  Ckeditor::PicturesController.class_eval do
    load_and_authorize_resource :class => 'Ckeditor::Picture'
    after_filter :set_experience, only: [:create]

    def index
    end

    private
    def set_experience
      if spree_current_user.experience? and @picture
        @picture.experience = spree_current_user.experience
        @picture.save
      end
    end
  end
end