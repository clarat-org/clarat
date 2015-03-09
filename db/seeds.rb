# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.create email: 'user@user.com', password: 'password', role: 'researcher'
user.confirm!
admin = User.create email: 'admin@admin.com', password: 'password', role: 'super'
admin.confirm!

LanguageFilter.create name: 'Deutsch', identifier: 'deu'
LanguageFilter.create name: 'Englisch', identifier: 'eng'
LanguageFilter.create name: 'Türkisch', identifier: 'tur'
AgeFilter.create name: 'Babies', identifier: 'babies'
AgeFilter.create name: 'Kleinkinder', identifier: 'toddler'
AgeFilter.create name: 'Schulkinder', identifier: 'schoolkid'
AgeFilter.create name: 'Jugendliche', identifier: 'adolescent'
AgeFilter.create name: 'junge Erwachsene', identifier: 'young_adults'
AgeFilter.create name: 'Eltern', identifier: 'parents'
AgeFilter.create name: 'Großeltern', identifier: 'grandparents'
AudienceFilter.create name: 'nur für Jungen und Männer', identifier: 'boys_only'
AudienceFilter.create name: 'nur für Mädchen und Frauen',
                      identifier: 'girls_only'
AudienceFilter.create name: 'Alleinerziehende', identifier: 'single_parents'
AudienceFilter.create name: 'Patchworkfamilien',
                      identifier: 'patchwork_families'
AudienceFilter.create name: 'Regenbogenfamilien', identifier: 'rainbow_families'
AudienceFilter.create name: 'LGBT', identifier: 'lgbt'
EncounterFilter.create name: 'persönliches Gespräch', identifier: 'personal'
EncounterFilter.create name: 'Telefon', identifier: 'hotline'
EncounterFilter.create name: 'E-Mail und Chat', identifier: 'online'

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

SearchLocation.create query: 'Berlin', latitude: 52.520007, longitude: 13.404954, geoloc: '52.520007,13.404954'

Category.create name: 'Akute Krisen', icon: 'a-crisis'
Category.create name: 'Lernen', icon: 'b-learn'
Category.create name: 'Familie', icon: 'c-family'
Category.create name: 'Gesundheit', icon: 'd-health'
Category.create name: 'Gewalt', icon: 'e-violence'
