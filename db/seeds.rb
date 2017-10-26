# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Offer.clear_index!

user = User.create email: 'user@user.com', role: 'researcher'
User.create email: 'admin@admin.com', role: 'super'

family = Section.create name: 'Family', identifier: 'family'
refugees = Section.create name: 'Refugees', identifier: 'refugees'
LanguageFilter.create name: 'Deutsch', identifier: 'deu'
LanguageFilter.create name: 'Englisch', identifier: 'eng'
LanguageFilter.create name: 'Türkisch', identifier: 'tur'
LanguageFilter.create name: 'Französisch', identifier: 'fra'
LanguageFilter.create name: 'Italienisch', identifier: 'ita'
LanguageFilter.create name: 'Russisch', identifier: 'rus'
LanguageFilter.create name: 'Schwedisch', identifier: 'swe'
TargetAudienceFilter.create name: 'Kinder', identifier: 'family_children'
TargetAudienceFilter.create name: 'Eltern', identifier: 'family_parents'
TargetAudienceFilter.create name: 'Familie', identifier: 'family_nuclear_family'
TargetAudienceFilter.create name: 'Bekannte', identifier: 'family_relatives'

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

fam = FactoryGirl.create :category,
                         name_de: 'Familie', icon: 'b-family',
                         name_en: 'Family', name_ar: "الأسرة",
                         name_fr: "famille", name_pl: "Rodzina",
                         name_tr: "aile", name_ru: "семья"
fam.sections = [family, refugees]
legal = FactoryGirl.create :category,
                           name_de: 'Asyl und Recht', icon: 'a-legal',
                           name_en: "Asylum and law",
                           name_ar: "اللجوء والقانون",
                           name_fr: "asile et droit",
                           name_pl: "Azyl i prawo",
                           name_tr: "iltica ve hukuk",
                           name_ru: "убежище и право"
legal.sections = [refugees]
health = FactoryGirl.create :category,
                            name_de: 'Gesundheit', icon: 'c-health',
                            name_en: "Health", name_ar: "الصحة",
                            name_fr: "santé", name_pl: "Zdrowie",
                            name_tr: "sağlık", name_ru: "здоровье"
health.sections = [family, refugees]
learn = FactoryGirl.create :category,
                           name_de: 'Lernen und Arbeiten', icon: 'd-learn',
                           name_en: "Learning and working",
                           name_ar: "التعلم والعمل",
                           name_fr: "apprendre et travailler",
                           name_pl: "Nauka i praca",
                           name_tr: "öğrenmek ve çalışmak",
                           name_ru: "учеба и работа"
learn.sections = [family, refugees]
misc = FactoryGirl.create :category,
                          name_de: 'Sorgen im Alltag', icon: 'e-misc',
                          name_en: "Worries in everyday life",
                          name_ar: "هموم الحياة اليومية",
                          name_fr: "préoccupations au quotidien",
                          name_pl: "Zmartwienia w codziennym życiu",
                          name_tr: "güncel hayatta sorun",
                          name_ru: "проблемы в обычной жизни"
misc.sections = [family]
misc = FactoryGirl.create :category,
                          name_de: 'Leben in Deutschland', icon: 'e-misc',
                          name_en: "Living in Germany",
                          name_ar: "الحياة في ألمانيا",
                          name_fr: "vivre en Allemagne",
                          name_pl: "Życie w Niemczech",
                          name_tr: "Almanya'da yaşamak",
                          name_ru: "жить в Германии"
misc.sections = [refugees]
violence = FactoryGirl.create :category,
                              name_de: 'Gewalt und Kriminalität',
                              icon: 'f-violence',
                              name_en: "Violence and crime",
                              name_ar: "العنف والجريمة",
                              name_fr: "violence et criminalité",
                              name_pl: "Przemoc i przestpczość",
                              name_tr: "şiddet ve suç",
                              name_ru: "насилие и криминал"
violence.sections = [family, refugees]
crisis = FactoryGirl.create :category,
                            name_de: 'Notfall', icon: 'g-crisis',
                            name_en: "Emergency", name_ar: "طوارئ",
                            name_fr: "urgence", name_pl: "Nagły wypadek",
                            name_tr: "Acil durum", name_ru: "экстренный случай"
crisis.sections = [family, refugees]

refugee_mains = Category.mains.in_section(:refugees).all
subcategories = []

10.times do
  subcategories.push(
    FactoryGirl.create :category,
                       parent: refugee_mains.sample
  )
end

20.times do
  FactoryGirl.create :category,
                     parent: subcategories.sample
end

FactoryGirl.create :offer, :approved,
                   approved_by: user, name: 'Lokales Angebot',
                   encounter: 'personal'
FactoryGirl.create :offer, :approved,
                   approved_by: user, name: 'Lokale Hotline',
                   encounter: 'hotline', area: berlin
FactoryGirl.create :offer, :approved,
                   approved_by: user, name: 'Bundesweiter Chat',
                   encounter: 'chat', area: schland
FactoryGirl.create :offer, :approved,
                   approved_by: user, name: 'Bundesweite Hotline',
                   encounter: 'hotline', area: schland
