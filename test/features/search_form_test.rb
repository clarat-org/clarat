require_relative '../test_helper'
include Warden::Test::Helpers

feature 'Search Form' do
  scenario 'Empty search works' do
    WebMock.enable!
    visit root_path
    find('.btn.btn-xlg.btn-aligned.icon-white').click
    page.must_have_content '0 Ergebnisse'
    WebMock.disable!
  end
end
