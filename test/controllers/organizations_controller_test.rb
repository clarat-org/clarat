require_relative '../test_helper'

describe OrganizationsController do
  describe "GET 'show'" do
    describe 'for an approved orga' do
      it 'should work (with friendly id)' do
        orga = FactoryGirl.create :organization, :approved, name: 'bazfuz'
        FactoryGirl.create :offer, :approved, section: 'family',
                                              organization: orga
        get :show, id: orga.slug, locale: 'de', section: 'family'
        assert_response :success
        assert_select 'title', 'bazfuz | clarat'
      end

      it 'should use the correct canonical URL' do
        orga = FactoryGirl.create :organization, :approved
        Organization.any_instance.expects(:section_filters).returns(
          SectionFilter.where(identifier: 'family')
        ).twice
        get :show, id: orga.slug, locale: 'de', section: 'family'
        assert_response :success
        assert_includes response.body, "http://test.host/family/organisationen/#{orga.slug}"
      end

      it 'should redirect if the wrong section was given' do
        orga = FactoryGirl.create :organization, :approved
        FactoryGirl.create :offer, :approved, section: 'family',
                                              organization: orga
        get :show, id: orga.slug, locale: 'de', section: 'refugees'
        assert_redirected_to section: 'family'
      end

      it 'shouldnt show on unapproved orga' do
        orga = FactoryGirl.create :organization, :with_offer
        get :show, id: orga.slug, locale: 'de', section: 'refugees'
        assert_redirected_to controller: 'pages', action: 'not_found'
      end

      it 'should redirect to 404 if orga not found' do
        get :show, id: 'doesntexist', locale: 'de', section: 'family'
        assert_redirected_to controller: 'pages', action: 'not_found'
      end
    end

    describe 'for an all_done orga' do
      it 'should work (with friendly id)' do
        orga = FactoryGirl.create :organization, :approved, name: 'bazfuz'
        FactoryGirl.create :offer, :approved, section: 'family',
                                              organization: orga
        orga.update_columns aasm_state: 'all_done'
        get :show, id: orga.slug, locale: 'de', section: 'family'
        assert_response :success
        assert_select 'title', 'bazfuz | clarat'
      end

      it 'should use the correct canonical URL' do
        orga = FactoryGirl.create :organization, :approved
        orga.update_columns aasm_state: 'all_done'
        Organization.any_instance.expects(:section_filters).returns(
          SectionFilter.where(identifier: 'family')
        ).twice
        get :show, id: orga.slug, locale: 'de', section: 'family'
        assert_response :success
        assert_includes response.body, "http://test.host/family/organisationen/#{orga.slug}"
      end

      it 'should redirect if the wrong section was given' do
        orga = FactoryGirl.create :organization, :approved
        orga.update_columns aasm_state: 'all_done'
        FactoryGirl.create :offer, :approved, section: 'family',
                                              organization: orga
        get :show, id: orga.slug, locale: 'de', section: 'refugees'
        assert_redirected_to section: 'family'
      end
    end
  end

  describe "GET 'section_forward'" do
    it 'should redirect to the default location if it has both sections' do
      orga = FactoryGirl.create :organization, :approved
      Organization.any_instance.expects(:section_filters).returns(
        SectionFilter.all
      )
      get :section_forward, id: orga.slug, locale: 'de'
      assert_redirected_to controller: 'organizations', action: 'show',
                           section: SectionFilter::DEFAULT
    end

    it 'should redirect to the family section if it has only that one' do
      orga = FactoryGirl.create :organization, :approved
      Organization.any_instance.expects(:section_filters).returns(
        SectionFilter.where(identifier: 'family')
      )
      get :section_forward, id: orga.slug, locale: 'de'
      assert_redirected_to controller: 'organizations', action: 'show',
                           section: 'family'
    end

    it 'should redirect to the refugees section if it has only that one' do
      orga = FactoryGirl.create :organization, :approved
      Organization.any_instance.expects(:section_filters).returns(
        SectionFilter.where(identifier: 'refugees')
      )
      get :section_forward, id: orga.slug, locale: 'de'
      assert_redirected_to controller: 'organizations', action: 'show',
                           section: 'refugees'
    end
  end
end
