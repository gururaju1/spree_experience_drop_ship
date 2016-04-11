Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  namespace :admin do
    resource :experience_drop_ship_settings
    resources :shipments
    resources :experiences
  end
end
