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
TargetAudienceFilter.create name: 'Kinder', identifier: 'children'
TargetAudienceFilter.create name: 'Eltern', identifier: 'parents'
TargetAudienceFilter.create name: 'Familie', identifier: 'nuclear_family'
TargetAudienceFilter.create name: 'Bekannte', identifier: 'acquaintances'

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

fam = FactoryGirl.create :category, name: 'Familie', icon: 'a-family'
fam.section_filters = [family]
legal = FactoryGirl.create :category, name: 'Asyl und Recht', icon: 'a-legal'
legal.section_filters = [refugees]
health = FactoryGirl.create :category, name: 'Gesundheit', icon: 'b-health'
health.section_filters = [family, refugees]
learn = FactoryGirl.create :category, name: 'Lernen', icon: 'c-learn'
learn.section_filters = [family, refugees]
misc = FactoryGirl.create :category, name: 'Sorgen im Alltag', icon: 'd-misc'
misc.section_filters = [family, refugees]
violence = FactoryGirl.create :category, name: 'Gewalt', icon: 'e-violence'
violence.section_filters = [family, refugees]
crisis = FactoryGirl.create :category, name: 'Notfall', icon: 'f-crisis'
crisis.section_filters = [family, refugees]

refugee_mains = Category.mains.in_section(:refugees).all
subcategories = []

10.times do
  subcategories.push(
    FactoryGirl.create :category, parent: refugee_mains.sample
  )
end

20.times do
  FactoryGirl.create :category, parent: subcategories.sample
end

FactoryGirl.create :offer, :approved, approved_by: user,
                                      name: 'Lokales Angebot',
                                      encounter: 'personal'
FactoryGirl.create :offer, :approved, approved_by: user,
                                      name: 'Lokale Hotline',
                                      encounter: 'hotline',
                                      area: berlin
FactoryGirl.create :offer, :approved, approved_by: user,
                                      name: 'Bundesweiter Chat',
                                      encounter: 'chat',
                                      area: schland
FactoryGirl.create :offer, :approved, approved_by: user,
                                      name: 'Bundesweite Hotline',
                                      encounter: 'hotline',
                                      area: schland
