if defined?(Ckeditor::AttachmentFilesController)
  Ckeditor::AttachmentFilesController.class_eval do

    load_and_authorize_resource :class => 'Ckeditor::AttachmentFile'
    after_filter :set_experience, only: [:create]

    def index
    end

    private

    def set_experience
      if try_spree_current_user.experience? and @attachment
        @attachment.experience = try_spree_current_user.experience
        @attachment.save
      end
    end

  end
end