require_relative '../test_helper'

describe OrganizationsController do
  describe "GET 'show'" do
    describe 'for an approved orga' do
      it 'should work (with friendly id)' do
        orga = FactoryGirl.create :organization, :approved, name: 'bazfuz'
        ApplicationController.expects(:http_basic_authenticate_with).never
        get :show, id: orga.slug, locale: 'de'
        assert_response :success
        assert_select 'title', 'bazfuz | clarat'
      end

      it 'should redirect to 404 if orga not found' do
        get :show, id: 'doesntexist', locale: 'de'
        assert_redirected_to controller: 'pages', action: 'not_found'
      end
    end

    # describe 'for an unapproved orga' do
    #  it 'should work but password_protect' do
    #    orga = FactoryGirl.create :organization, name: 'bazfuz'
    #    ApplicationController.expects(:http_basic_authenticate_with)
    #    get :show, id: orga.slug, locale: 'de'
    #    assert_response :success
    #  end
    # end
  end
end
