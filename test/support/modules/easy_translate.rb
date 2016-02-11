module EasyTranslate
  def self.translate *attrs
    standard_translation = 'GET READY FOR CANADA'

    if attrs[0].is_a? Array
      attrs[0].map { |_e| standard_translation }
    else
      standard_translation
    end
  end
end
