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

Language.create name: 'Deutsch', code: 'deu'
Language.create name: 'Englisch', code: 'eng'
Language.create name: 'Türkisch', code: 'tur'

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

mains = []
mains << Category.create(name: 'Akute Krisen', icon: 'a-crisis')
mains << Category.create(name: 'Lernen', icon: 'b-learn')
mains << Category.create(name: 'Familie', icon: 'c-family')
mains << Category.create(name: 'Gesundheit', icon: 'd-health')
mains << Category.create(name: 'Gewalt', icon: 'e-violence')

10.times do
  FactoryGirl.create :category, parent: mains.sample
end

20.times do
  FactoryGirl.create :category, parent_id: Category.pluck(:id).sample
end
