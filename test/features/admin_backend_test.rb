require_relative '../test_helper'
include Warden::Test::Helpers

feature "Admin Backend" do
  before { login_as FactoryGirl.create :admin }

  scenario 'Administrating Offers' do
    visit rails_admin_path
  end
end
