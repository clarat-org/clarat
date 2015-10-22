require_relative '../test_helper'

describe OrganizationsController do
  describe "GET 'show'" do
    describe 'for an approved orga' do
      it 'should work (with friendly id)' do
        orga = FactoryGirl.create :organization, :approved, name: 'bazfuz'
        get :show, id: orga.slug, locale: 'de'
        assert_response :success
        assert_select 'title', 'bazfuz | clarat'
      end

      it 'shouldnt show on unapproved orga' do
        orga = FactoryGirl.create :organization
        get :show, id: orga.slug, locale: 'de'
        assert_redirected_to controller: 'pages', action: 'not_found'
      end

      it 'should redirect to 404 if orga not found' do
        get :show, id: 'doesntexist', locale: 'de'
        assert_redirected_to controller: 'pages', action: 'not_found'
      end
    end
  end
end
