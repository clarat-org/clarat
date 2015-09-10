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
        select 'English', from: 'offer_language_filter_ids'
        select 'Bekannte', from: 'offer_target_audience_filter_ids'
        check 'offer_renewed'

        click_button 'Speichern'
        page.must_have_content 'Angebot wurde erfolgreich hinzugefügt'
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
        select 'basicLocation', from: 'organization_location_ids'
        check 'organization_renewed'
        check 'organization_accredited_institution'

        click_button 'Speichern'
        page.must_have_content 'testorganisation'
        page.must_have_content 'Organisation wurde erfolgreich hinzugefügt'
        page.must_have_content '✘'
        page.must_have_content researcher.email
      end
    end

    scenario 'Try to create organization with/out hq-location' do
      orga = organizations(:basic)
      location = FactoryGirl.create :location, :hq, organization: orga
      orga.update_columns aasm_state: 'initialized', created_by: researcher.id

      visit rails_admin_path
      click_link 'Organisationen', match: :first
      click_link 'Bearbeiten', match: :first

      click_link 'Als komplett markieren'
      page.must_have_content 'Zustandsänderung konnte nicht erfolgen'
      page.must_have_content 'nicht valide'

      # 1: With two hq locations
      click_button 'Speichern'
      page.must_have_content 'Es muss genau eine HQ-Location zugeordnet werden'

      # 2: With non-hq locations
      locations(:basic).update_column :hq, false
      location.update_column :hq, false
      click_button 'Speichern'
      page.must_have_content 'Es muss genau eine HQ-Location zugeordnet werden'

      # 3: With one hq location
      location.update_column :hq, true
      click_button 'Speichern'
      page.must_have_content 'Organisation wurde erfolgreich aktualisiert'

      # complete works
      click_link 'Als komplett markieren'
      page.must_have_content 'Zustandsänderung war erfolgreich.'

      # There is no approve link as same user
      page.wont_have_link 'Freischalten'

      # Approval works as different user
      login_as superuser
      visit current_path
      page.must_have_link 'Freischalten'
      click_link 'Freischalten'
      page.must_have_content 'Zustandsänderung war erfolgreich'
    end

    scenario 'Try to create offer with errors' do
      location = FactoryGirl.create(:location, name: 'testname')
      contact_person = FactoryGirl.create :contact_person

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

      # Age Filter correct, but wrong contact_person chosen
      fill_in 'offer_age_from', with: 0
      fill_in 'offer_age_to', with: 18
      select contact_person.display_name, from: 'offer_contact_person_ids'
      click_button 'Speichern und bearbeiten'
      page.wont_have_content 'Age from darf nicht größer sein als Age to'
      page.must_have_content 'Contact people müssen alle zu einer der'\
                             ' ausgewählten Organisationen gehören oder als'\
                             ' SPoC markiert sein'

      # contact_person becomes SPoC, still needs target_audience
      contact_person.update_column :spoc, true
      click_button 'Speichern und bearbeiten'
      page.wont_have_content 'Contact people müssen alle zu einer der'\
                             ' ausgewählten Organisationen gehören oder als'\
                             ' SPoC markiert sein'
      page.must_have_content 'benötigt mindestens einen Target Audience Filter'

      # target audience selected, needs language filters
      select 'Bekannte', from: 'offer_target_audience_filter_ids'
      click_button 'Speichern und bearbeiten'
      page.wont_have_content 'benötigt mindestens einen Target Audience Filter'
      page.must_have_content 'Language filters benötigt mindestens einen'\
                             ' Sprachfilter'

      # language filter selected, it saves
      select 'English', from: 'offer_language_filter_ids'
      click_button 'Speichern und bearbeiten'
      page.wont_have_content 'Language filters benötigt mindestens einen'\
                             ' Sprachfilter'
      page.must_have_content 'Angebot wurde erfolgreich hinzugefügt'

      ## Test Update validations

      # Try to complete, doesnt work
      click_link 'Als komplett markieren'
      page.must_have_content 'Zustandsänderung konnte nicht erfolgen'
      page.must_have_content 'nicht valide'

      # See what the issue is (orga/location mismatch)
      click_button 'Speichern und bearbeiten'
      page.must_have_content 'Angebot wurde nicht aktualisiert'
      page.must_have_content(
        'Location muss zu der unten angegebenen Organisation gehören.'
      )
      page.must_have_content(
        'Organizations muss die des angegebenen Standorts beinhalten.'
      )

      # Fix Orga/Location mismatch, it saves again
      location.update_column :organization_id, 1
      click_button 'Speichern und bearbeiten'
      page.must_have_content 'Angebot wurde erfolgreich aktualisiert'
      page.wont_have_content(
        'Location muss zu der unten angegebenen Organisation gehören.'
      )
      page.wont_have_content(
        'Organizations muss die des angegebenen Standorts beinhalten.'
      )

      # Complete works
      click_link 'Als komplett markieren'
      page.wont_have_content 'Zustandsänderung konnte nicht erfolgen'
      page.must_have_content 'Zustandsänderung war erfolgreich'
    end

    scenario 'Approve offer' do
      orga = organizations(:basic)
      orga.update_column :aasm_state, 'completed'

      # Create incomplete offer
      visit rails_admin_path

      click_link 'Angebote', match: :first
      click_link 'Neu hinzufügen'

      fill_in 'offer_name', with: 'testangebot'
      fill_in 'offer_description', with: 'testdescription'
      fill_in 'offer_next_steps', with: 'testnextsteps'
      fill_in 'offer_age_from', with: 0
      fill_in 'offer_age_to', with: 18
      select 'Hotline', from: 'offer_encounter'
      select 'basicLocation', from: 'offer_location_id'
      fill_in 'offer_age_to', with: 6

      ## Test general validations

      # Doesnt save, needs organization
      click_button 'Speichern und bearbeiten'
      page.must_have_content 'Organizations benötigt mindestens eine'\
                             ' Organisation'

      # Organization given, needs an area and no location when remote
      select 'foobar', from: 'offer_organization_ids'
      click_button 'Speichern und bearbeiten'
      page.wont_have_content 'Organizations benötigt mindestens eine'\
                             ' Organisation'
      page.must_have_content 'Area muss ausgefüllt werden, wenn Encounter'\
                             ' nicht "personal" ist'
      page.must_have_content 'Location darf keinen Standort haben, wenn'\
                             ' Encounter nicht "personal" ist'

      # area given and no location, needs language filter
      select 'Deutschland', from: 'offer_area_id'
      select '', from: 'offer_location_id'
      click_button 'Speichern'
      page.wont_have_content 'Area muss ausgefüllt werden, wenn Encounter'\
                             ' nicht "personal" ist'
      page.wont_have_content 'Location darf keinen Standort haben, wenn'\
                             ' Encounter nicht "personal" ist'
      page.must_have_content 'Language filters benötigt mindestens einen'\
                             ' Sprachfilter'

      # language filter given, needs target audience
      select 'Deutsch', from: 'offer_language_filter_ids'
      click_button 'Speichern'
      page.wont_have_content 'Language filters benötigt mindestens einen'\
                             ' Sprachfilter'
      page.must_have_content 'benötigt mindestens einen Target Audience Filter'

      # target audience is given, it saves
      select 'Bekannte', from: 'offer_target_audience_filter_ids'
      click_button 'Speichern und bearbeiten'
      page.wont_have_content 'benötigt mindestens einen Target Audience Filter'
      page.must_have_content 'Angebot wurde erfolgreich hinzugefügt'
      offer = Offer.last

      click_link 'Als komplett markieren'
      page.must_have_content 'Zustandsänderung war erfolgreich'
      offer.reload.must_be :completed?

      # There is no approve link as same user
      page.wont_have_link 'Freischalten'

      # Approval as different user
      login_as superuser
      visit current_path
      page.must_have_link 'Freischalten'

      ## Test (after-)approval update validations

      # Try to approve, doesnt work
      click_link 'Freischalten'
      page.must_have_content 'Zustandsänderung konnte nicht erfolgen'
      page.must_have_content 'nicht valide'
      offer.reload.must_be :completed?

      # Organization needs to be approved
      page.must_have_content 'Organizations darf nur bestätigte Organisationen'\
                             ' beinhalten.'

      # Organization gets approved, saves
      orga.update_column :aasm_state, 'approved'
      click_button 'Speichern und bearbeiten'
      page.must_have_content 'Angebot wurde erfolgreich aktualisiert'

      # Approval works
      click_link 'Freischalten'
      page.wont_have_content 'Organizations darf nur bestätigte Organisationen'\
                             ' beinhalten.'
      page.must_have_content 'Zustandsänderung war erfolgreich'
      offer.reload.must_be :approved?
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

    # scenario 'Adding notes' ~> needs javascript for the "add note" button

    scenario 'Viewing notes in admin show and edit works' do
      note = FactoryGirl.create :note, topic: 'history', closed: true,
                                       notable: offers(:basic)
      note_text = note.text

      visit rails_admin_path

      click_link 'Angebote', match: :first

      click_link 'Anzeigen'
      page.must_have_content note_text

      click_link 'Bearbeiten'
      page.must_have_content note_text

      page.must_have_css '.Note.closed'
      page.must_have_css '.topic.history'
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
