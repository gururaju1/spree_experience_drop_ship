require 'spec_helper'

describe 'Admin - Orders', js: true do

  it 'Experience should not be authorized' do
    create(:user) # create extra user so admin role isnt assigned to the user we login as
    login_user create(:experience_user)
    visit spree.admin_orders_path
    page.should have_content('Authorization Failure')
  end

end