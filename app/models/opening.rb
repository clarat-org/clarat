# frozen_string_literal: true

# Monkeypatch clarat_base Opening
require ClaratBase::Engine.root.join('app', 'models', 'opening')

class Opening < ApplicationRecord
  # Frontend Methods

  # The way an opening time frame is displayed to the user in the front end.
  def display_string
    if !close # there can also be no opening, because of validations
      I18n.t 'opening.display_string.appointment'
    else
      close_string = I18n.l(close, format:
        I18n.t('opening.display_string.time_format_close'))
      # midnight exception for de format. Can be expanded to other languages
      # by checking close.hour and close.minutes and adding content in locales
      if close_string == '00:00 Uhr'
        close_string = I18n.t('opening.display_string.midnight_exception')
      end
      I18n.t 'opening.display_string.time_frame', open:
        I18n.l(open, format: I18n.t('opening.display_string.time_format_open')),
                                                  close: close_string
    end
  end
end
