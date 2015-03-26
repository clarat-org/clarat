class LanguageFilter < Filter
  # Validations
  validates :identifier, uniqueness: true, presence: true, length: { is: 3 }
  # identifier: ISO 639-2 code

  IDENTIFIER = %w(
    deu eng tur tha bul ron sqi ara fra kur rus srp amh bos ita hrv pol por vie
    wol fas ben spa tam urd mul aze ell hin mkd rom hun 568 326 639 150 lav lit
  )
end
