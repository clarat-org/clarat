require_relative '../test_helper'
include Warden::Test::Helpers

feature 'Admin Backend' do
  let(:researcher) { FactoryGirl.create :researcher }
  let(:superuser) { FactoryGirl.create :super }

  describe 'as researcher' do
    before { login_as researcher }

    scenario 'Administrating Offers' do
      visit rails_admin_path

      click_link 'Angebote', match: :first
      click_link 'Neu hinzufügen'

      assert_difference 'Offer.count', 1 do
        fill_in 'offer_name', with: 'testangebot'
        fill_in 'offer_description', with: 'testdescription'
        fill_in 'offer_next_steps', with: 'testnextsteps'
        select 'Fixed', from: 'offer_encounter'
        select 'foobar', from: 'offer_organization_ids'
        check 'offer_renewed'

        click_button 'Speichern'
        page.must_have_content 'testangebot'
      end
    end

    scenario 'Administrating Organizations' do
      visit rails_admin_path

      click_link 'Organisationen', match: :first
      click_link 'Neu hinzufügen'

      assert_difference 'Organization.count', 1 do
        fill_in 'organization_name', with: 'testorganisation'
        fill_in 'organization_description', with: 'testdescription'
        select 'e.V.', from: 'organization_legal_form'

        click_button 'Speichern'
        page.must_have_content 'testorganisation'
        page.must_have_content '✘'
        page.must_have_content researcher.email
      end
    end

    scenario 'Try to create offer with a organization/location mismatch' do
      location = FactoryGirl.create(:location, name: 'testname')

      visit rails_admin_path

      click_link 'Angebote', match: :first
      click_link 'Neu hinzufügen'

      fill_in 'offer_name', with: 'testangebot'
      fill_in 'offer_description', with: 'testdescription'
      fill_in 'offer_next_steps', with: 'testnextsteps'
      select 'Fixed', from: 'offer_encounter'
      select location.name, from: 'offer_location_id'
      select 'foobar', from: 'offer_organization_ids'

      click_button 'Speichern und bearbeiten'

      check 'offer_completed'
      click_button 'Speichern' # update to trigger validation

      page.must_have_content 'Angebot wurde nicht aktualisiert'
      page.must_have_content 'Location muss zu der unten angegebenen Organisation gehören.'
      page.must_have_content 'Organizations muss die des angegebenen Standorts beinhalten.'
    end

    scenario 'Approve offer' do
      orga = organizations(:basic)
      FactoryGirl.create :location, name: 'foobar', organization: orga

      # 1: Create incomplete offer
      visit rails_admin_path

      click_link 'Angebote', match: :first
      click_link 'Neu hinzufügen'

      fill_in 'offer_name', with: 'testangebot'
      fill_in 'offer_description', with: 'testdescription'
      fill_in 'offer_next_steps', with: 'testnextsteps'
      select 'Fixed', from: 'offer_encounter'
      select 'foobar', from: 'offer_location_id'
      check 'offer_completed'
      click_button 'Speichern und bearbeiten'

      # 2: Fail to approve as same user
      check 'offer_approved'
      click_button 'Speichern'
      page.must_have_content 'Approved kann nicht von dem/der Ersteller/in gesetzt werden'

      # 3: Login as user able to approve, fail to approve incomplete offer
      login_as superuser

      visit rails_admin_path
      click_link 'Angebote', match: :first
      click_link 'Bearbeiten', match: :first

      uncheck 'offer_completed'
      check 'offer_approved'
      click_button 'Speichern'
      page.wont_have_content 'Approved kann nicht von dem/der Ersteller/in gesetzt werden'
      page.must_have_content 'Approved kann nicht angehakt werden, wenn nicht auch "Completed" gesetzt ist'

      # 4: Set complete, fail to approve offer without organization
      check 'offer_completed'
      click_button 'Speichern'
      page.wont_have_content 'Approved kann nicht angehakt werden, wenn nicht auch "Completed" gesetzt ist'
      page.must_have_content 'Organizations benötigt mindestens eine Organisation'

      # 5: fix orga selection error, but orga is not approved
      orga.update_column :approved, false
      select 'foobar', from: 'offer_organization_ids'
      click_button 'Speichern'

      page.wont_have_content 'Organizations benötigt mindestens eine Organisation'
      page.must_have_content 'Organizations darf nur bestätigte Organisationen beinhalten, bevor dieses Angebot bestätigt werden kann.'

      # 6: fix all orga errors, needs age_filter
      orga.update_column :approved, true
      click_button 'Speichern'
      page.wont_have_content 'Organizations darf nur bestätigte Organisationen beinhalten, bevor dieses Angebot bestätigt werden kann.'
      page.must_have_content 'Age filters benötigt mindestens einen Altersfilter'

      # 7: age_filter given, needs encounter_filter
      select 'Babies', from: 'offer_age_filter_ids'
      click_button 'Speichern'
      page.wont_have_content 'Organizations darf nur bestätigte Organisationen beinhalten, bevor dieses Angebot bestätigt werden kann.'
      page.must_have_content 'Encounter filters benötigt mindestens einen Kontaktfilter'

      # 8: encounter_filter given, offer is approved
      select 'Telefon', from: 'offer_encounter_filter_ids'
      click_button 'Speichern'
      page.wont_have_content 'Encounter filters benötigt mindestens einen Kontaktfilter'
      page.must_have_content 'Angebot wurde erfolgreich aktualisiert'
    end

    scenario 'Mark offer as completed' do
      visit rails_admin_path

      click_link 'Angebote', match: :first
      click_link 'Bearbeiten'

      check 'offer_completed'

      click_button 'Speichern'

      page.must_have_content '✓'
    end

    # calls partial dup that doesn't end up in an immediately valid offer
    scenario 'Duplicate offer' do
      visit rails_admin_path

      click_link 'Angebote', match: :first
      click_link 'Duplizieren'

      click_button 'Speichern'

      page.must_have_content 'Angebot wurde nicht hinzugefügt'
    end

    scenario 'Duplicate organization' do
      visit rails_admin_path

      click_link 'Organisationen', match: :first
      click_link 'Duplizieren'
      fill_in 'organization_name', with: 'kopietestname'

      click_button 'Speichern'

      page.must_have_content 'kopietestname'
    end

    # describe 'Dependent Tags' do
    #   before do
    #     @tag = FactoryGirl.create :tag, dependent_tag_count: 1
    #     @dependent = @tag.dependent_categories.first
    #     visit rails_admin_path
    #     click_link 'Angebote', match: :first
    #     click_link 'Bearbeiten'
    #   end
    #
    #   scenario 'Dependent categories get added automatically' do
    #     select @tag.name, from: 'offer_tag_ids'
    #     click_button 'Speichern und bearbeiten'
    #
    #     categories = offers(:basic).reload.categories
    #     categories.must_include @tag
    #     categories.must_include @dependent
    #   end
    #
    #   scenario 'Dependent categories get added only once (dupes get removed)' do
    #     select @tag.name, from: 'offer_tag_ids'
    #     select @dependent.name, from: 'offer_tag_ids'
    #     click_button 'Speichern und bearbeiten'
    #
    #     categories = offers(:basic).reload.categories.to_a
    #     categories.must_include @tag
    #     categories.count(@dependent).must_equal 1
    #   end
    # end

    scenario 'View statistics should not work' do
      visit rails_admin_path

      click_link 'Angebote', match: :first
      page.wont_have_link 'Statistiken'
    end
  end

  describe 'as super' do
    before { login_as superuser }

    scenario 'View statistics' do
      researcher # create one for stats
      visit rails_admin_path

      click_link 'Angebote', match: :first
      click_link 'Statistiken'
      click_link 'Weekly by user'
      click_link 'Cumulative by user'

      page.must_have_content 'Created'
      page.must_have_content 'Approved'
    end
  end
end
