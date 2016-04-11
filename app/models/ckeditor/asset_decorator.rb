if defined?(Ckeditor)
  Ckeditor::Asset.class_eval do
    belongs_to :experience, class_name: 'Spree::Experience'
  end
end