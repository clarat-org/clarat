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
        fill_in 'offer_age_from', with: 0
        fill_in 'offer_age_to', with: 18
        select 'Personal', from: 'offer_encounter'
        select 'basicLocation', from: 'offer_location_id'
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
        check 'organization_renewed'
        check 'organization_accredited_institution'

        click_button 'Speichern'
        page.must_have_content 'testorganisation'
        page.must_have_content '✘'
        page.must_have_content researcher.email
      end
    end

    scenario 'Try to approve organization with/out hq-location' do
      orga = FactoryGirl.create :organization, completed: true
      # orga.update_column :approved, false
      location = FactoryGirl.create :location, organization: orga, hq: false
      visit rails_admin_path

      # 1: With a non-hq locaton
      click_link 'Organisationen', match: :first
      click_link 'Bearbeiten', match: :first
      check 'organization_approved'
      click_button 'Speichern'
      page.must_have_content 'Es muss genau eine HQ-Location zugeordnet werden'

      # 2: With a hq location
      location.update_column :hq, true
      login_as superuser
      click_button 'Speichern'
      page.must_have_content 'Organisation wurde erfolgreich aktualisiert'

      # 3: With two hq locations
      FactoryGirl.create :location, organization: orga, hq: true
      orga.update_column :approved, false
      click_link 'Bearbeiten', match: :first
      check 'organization_approved'
      click_button 'Speichern'
      page.must_have_content 'Es muss genau eine HQ-Location zugeordnet werden'
    end

    scenario 'Try to create offer with errors' do
      location = FactoryGirl.create(:location, name: 'testname')

      visit rails_admin_path

      click_link 'Angebote', match: :first
      click_link 'Neu hinzufügen'

      fill_in 'offer_name', with: 'testangebot'
      fill_in 'offer_description', with: 'testdescription'
      fill_in 'offer_next_steps', with: 'testnextsteps'
      select 'Personal', from: 'offer_encounter'
      select location.name, from: 'offer_location_id'
      select 'foobar', from: 'offer_organization_ids'

      click_button 'Speichern und bearbeiten'

      # Orga/Location mismatch wasn't tested yet
      page.wont_have_content(
        'Location muss zu der unten angegebenen Organisation gehören.'
      )
      page.wont_have_content(
        'Organizations muss die des angegebenen Standorts beinhalten.'
      )

      # Age From and Age To are missing
      page.must_have_content 'Age from muss ausgefüllt werden'
      page.must_have_content 'Age to muss ausgefüllt werden'

      # Age Filter given, but not in the correct range
      fill_in 'offer_age_from', with: -1
      fill_in 'offer_age_to', with: 19
      click_button 'Speichern und bearbeiten'
      page.wont_have_content 'Age from muss ausgefüllt werden'
      page.wont_have_content 'Age to muss ausgefüllt werden'
      page.must_have_content 'Age from muss größer oder gleich 0 sein'
      page.must_have_content 'Age to muss kleiner oder gleich 18 sein'

      # Age  Filter in correct range, but from is higher than to
      fill_in 'offer_age_from', with: 9
      fill_in 'offer_age_to', with: 8
      click_button 'Speichern und bearbeiten'
      page.wont_have_content 'Age from muss größer oder gleich 0 sein'
      page.wont_have_content 'Age to muss kleiner oder gleich 18 sein'
      page.must_have_content 'Age from darf nicht größer sein als Age to'

      # Age  Filter correct, it saves
      fill_in 'offer_age_from', with: 0
      fill_in 'offer_age_to', with: 18
      click_button 'Speichern und bearbeiten'
      page.must_have_content 'Angebot wurde erfolgreich hinzugefügt'

      # Update to trigger validation
      check 'offer_completed'
      click_button 'Speichern'

      page.must_have_content 'Angebot wurde nicht aktualisiert'
      page.must_have_content(
        'Location muss zu der unten angegebenen Organisation gehören.'
      )
      page.must_have_content(
        'Organizations muss die des angegebenen Standorts beinhalten.'
      )
    end

    scenario 'Approve offer' do
      orga = organizations(:basic)

      # 1: Create incomplete offer
      visit rails_admin_path

      click_link 'Angebote', match: :first
      click_link 'Neu hinzufügen'

      fill_in 'offer_name', with: 'testangebot'
      fill_in 'offer_description', with: 'testdescription'
      fill_in 'offer_next_steps', with: 'testnextsteps'
      fill_in 'offer_age_from', with: 0
      fill_in 'offer_age_to', with: 18
      select 'Personal', from: 'offer_encounter'
      select 'basicLocation', from: 'offer_location_id'
      fill_in 'offer_age_to', with: 6
      check 'offer_completed'
      click_button 'Speichern und bearbeiten'

      # 2: Fail to approve as same user
      check 'offer_approved'
      click_button 'Speichern'
      page.must_have_content 'Approved kann nicht von dem/der Ersteller/in'\
                             ' gesetzt werden'

      # 3: Login as user able to approve, fail to approve incomplete offer
      login_as superuser

      visit rails_admin_path
      click_link 'Angebote', match: :first
      click_link 'Bearbeiten', match: :first

      uncheck 'offer_completed'
      check 'offer_approved'
      click_button 'Speichern'
      page.wont_have_content 'Approved kann nicht von dem/der Ersteller/in'\
                             ' gesetzt werden'
      page.must_have_content 'Approved kann nicht angehakt werden, wenn nicht'\
                             ' auch "Completed" gesetzt ist'

      # 4: Set complete, fail to approve offer without organization
      check 'offer_completed'
      click_button 'Speichern'
      page.wont_have_content 'Approved kann nicht angehakt werden, wenn nicht'\
                             ' auch "Completed" gesetzt ist'
      page.must_have_content 'Organizations benötigt mindestens eine'\
                             ' Organisation'

      # 5: fix orga selection error, but orga is not approved
      orga.update_column :approved, false
      select 'foobar', from: 'offer_organization_ids'
      click_button 'Speichern'

      page.wont_have_content 'Organizations benötigt mindestens eine'\
                             ' Organisation'
      page.must_have_content 'Organizations darf nur bestätigte Organisationen'\
                             ' beinhalten.'

      # 6: fix all orga errors, needs an area and no location when not personal
      orga.update_column :approved, true
      select 'Hotline', from: 'offer_encounter'
      click_button 'Speichern'
      page.wont_have_content 'Organizations darf nur bestätigte Organisationen'\
                             ' beinhalten.'
      page.must_have_content 'Area muss ausgefüllt werden, wenn Encounter'\
                             ' nicht "personal" ist'
      page.must_have_content 'Location darf keinen Standort haben, wenn'\
                             ' Encounter nicht "personal" ist'

      # 7: area given and no location, needs language filter
      select 'Deutschland', from: 'offer_area_id'
      select '', from: 'offer_location_id'
      click_button 'Speichern'
      page.wont_have_content 'Area muss ausgefüllt werden, wenn Encounter'\
                             ' nicht "personal" ist'
      page.wont_have_content 'Location darf keinen Standort haben, wenn'\
                             ' Encounter nicht "personal" ist'
      page.must_have_content 'Language filters benötigt mindestens einen'\
                             ' Sprachfilter'

      # 8: language filter given, needs target audience
      select 'Deutsch', from: 'offer_language_filter_ids'
      click_button 'Speichern'
      page.wont_have_content 'Language filters benötigt mindestens einen'\
                             ' Sprachfilter'
      page.must_have_content 'Target audience wird benötigt'

      # 9: target audience is given, offer is approved
      select 'Child', from: 'offer_target_audience'
      click_button 'Speichern'
      page.wont_have_content 'Target audience wird benötigt'
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

    # TODO: being worked on (Basti)
    scenario 'Duplicate contact_person' do
      FactoryGirl.create :offer, :approved, name: 'testoffer'
      # contact_person = FactoryGirl.create :contact_person
      # contact_person.offers << (FactoryGirl.create :offer, :approved, name: 'testoffer')
      # debugger
      visit rails_admin_path
      click_link 'Kontaktpersonen', match: :first
      click_link 'Duplizieren', match: :first
      # debugger
      click_button 'Speichern'
      page.must_have_content 'testoffer'
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
