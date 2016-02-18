# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Offer.clear_index!

user = User.create email: 'user@user.com', role: 'researcher'
admin = User.create email: 'admin@admin.com', role: 'super'

family = SectionFilter.create name: 'Family', identifier: 'family'
refugees = SectionFilter.create name: 'Refugees', identifier: 'refugees'
LanguageFilter.create name: 'Deutsch', identifier: 'deu'
LanguageFilter.create name: 'Englisch', identifier: 'eng'
LanguageFilter.create name: 'Türkisch', identifier: 'tur'
TargetAudienceFilter.create name: 'Kinder', identifier: 'family_children'
TargetAudienceFilter.create name: 'Eltern', identifier: 'family_parents'
TargetAudienceFilter.create name: 'Familie', identifier: 'family_nuclear_family'
TargetAudienceFilter.create name: 'Bekannte', identifier: 'family_acquaintances'

LogicVersion.create(version: 1, name: 'Altlasten')
LogicVersion.create(version: 2, name: 'Split Revolution')
LogicVersion.create(version: 3, name: 'TKKG')

schland = Area.create name: 'Deutschland', minlat: 47.270111, maxlat: 55.058347,
                      minlong: 5.866342, maxlong: 15.041896
berlin = Area.create name: 'Berlin', minlat: 52.339630, maxlat: 52.675454,
                     minlong: 13.089155, maxlong: 13.761118
Area.create name: 'Brandenburg & Berlin', minlat: 51.359059, maxlat: 53.558980,
            minlong: 11.268746, maxlong: 14.765826

FederalState.create name: 'Berlin'
FederalState.create name: 'Brandenburg'
FederalState.create name: 'Baden-Württemberg'
FederalState.create name: 'Bayern'
FederalState.create name: 'Bremen'
FederalState.create name: 'Hamburg'
FederalState.create name: 'Hessen'
FederalState.create name: 'Mecklenburg-Vorpommern'
FederalState.create name: 'Niedersachsen'
FederalState.create name: 'Nordrhein-Westfalen'
FederalState.create name: 'Saarland'
FederalState.create name: 'Sachsen'
FederalState.create name: 'Sachsen-Anhalt'
FederalState.create name: 'Schleswig-Holstein'
FederalState.create name: 'Thüringen'
FederalState.create name: 'Rheinland-Pfalz'
FederalState.create name: 'Mallorca' # Don't do this in production :)

SearchLocation.create query: 'Berlin', latitude: 52.520007,
                                       longitude: 13.404954,
                                       geoloc: '52.520007,13.404954'

fam = FactoryGirl.create :category, :with_dummy_translations,
                         name: 'Familie', icon: 'b-family'
fam.section_filters = [family, refugees]
legal = FactoryGirl.create :category, :with_dummy_translations,
                           name: 'Asyl und Recht', icon: 'a-legal'
legal.section_filters = [refugees]
health = FactoryGirl.create :category, :with_dummy_translations,
                            name: 'Gesundheit', icon: 'c-health'
health.section_filters = [family, refugees]
learn = FactoryGirl.create :category, :with_dummy_translations,
                           name: 'Lernen und Arbeiten', icon: 'd-learn'
learn.section_filters = [family, refugees]
misc = FactoryGirl.create :category, :with_dummy_translations,
                          name: 'Sorgen im Alltag', icon: 'e-misc'
misc.section_filters = [family]
misc = FactoryGirl.create :category, :with_dummy_translations,
                          name: 'Leben in Deutschland', icon: 'e-misc'
misc.section_filters = [refugees]
violence = FactoryGirl.create :category, :with_dummy_translations,
                              name: 'Gewalt', icon: 'f-violence'
violence.section_filters = [family, refugees]
crisis = FactoryGirl.create :category, :with_dummy_translations,
                            name: 'Notfall', icon: 'g-crisis'
crisis.section_filters = [family, refugees]

refugee_mains = Category.mains.in_section(:refugees).all
subcategories = []

10.times do
  subcategories.push(
    FactoryGirl.create :category, :with_dummy_translations,
                       parent: refugee_mains.sample
  )
end

20.times do
  FactoryGirl.create :category, :with_dummy_translations,
                     parent: subcategories.sample
end

FactoryGirl.create :offer, :approved, :with_dummy_translations,
                   approved_by: user, name: 'Lokales Angebot',
                   encounter: 'personal'
FactoryGirl.create :offer, :approved, :with_dummy_translations,
                   approved_by: user, name: 'Lokale Hotline',
                   encounter: 'hotline', area: berlin
FactoryGirl.create :offer, :approved, :with_dummy_translations,
                   approved_by: user, name: 'Bundesweiter Chat',
                   encounter: 'chat', area: schland
FactoryGirl.create :offer, :approved, :with_dummy_translations,
                   approved_by: user, name: 'Bundesweite Hotline',
                   encounter: 'hotline', area: schland
