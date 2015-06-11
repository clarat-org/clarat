# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.create email: 'user@user.com', password: 'password',
                                           role: 'researcher'
user.confirm!
admin = User.create email: 'admin@admin.com', password: 'password',
                                              role: 'super'
admin.confirm!

LanguageFilter.create name: 'Deutsch', identifier: 'deu'
LanguageFilter.create name: 'Englisch', identifier: 'eng'
LanguageFilter.create name: 'Türkisch', identifier: 'tur'
AgeFilter.create name: 'Babies', identifier: 'babies'
AgeFilter.create name: 'Kleinkinder', identifier: 'toddler'
AgeFilter.create name: 'Schulkinder', identifier: 'schoolkid'
AgeFilter.create name: 'Jugendliche', identifier: 'adolescent'
AgeFilter.create name: 'junge Erwachsene', identifier: 'young_adults'
AudienceFilter.create name: 'nur für Jungen und Männer', identifier: 'boys_only'
AudienceFilter.create name: 'nur für Mädchen und Frauen',
                      identifier: 'girls_only'
AudienceFilter.create name: 'Alleinerziehende', identifier: 'single_parents'
AudienceFilter.create name: 'Patchworkfamilien',
                      identifier: 'patchwork_families'
AudienceFilter.create name: 'Regenbogenfamilien', identifier: 'rainbow_families'
AudienceFilter.create name: 'LGBT', identifier: 'lgbt'
AudienceFilter.create name: 'Eltern', identifier: 'parents'
AudienceFilter.create name: 'Großeltern', identifier: 'grandparents'

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

mains = []
mains << Category.create(name: 'Akute Krisen', icon: 'e-crisis')
mains << Category.create(name: 'Lernen', icon: 'c-learn')
mains << Category.create(name: 'Familie', icon: 'a-family')
mains << Category.create(name: 'Gesundheit', icon: 'b-health')
mains << Category.create(name: 'Gewalt', icon: 'd-violence')

10.times do
  FactoryGirl.create :category, parent: mains.sample
end

20.times do
  FactoryGirl.create :category, parent_id: Category.pluck(:id).sample
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
