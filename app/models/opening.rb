# Monkeypatch clarat_base Opening
require ClaratBase::Engine.root.join('app', 'models', 'opening')

class Opening < ActiveRecord::Base
  # Frontend Methods

  # The way an opening time frame is displayed to the user in the front end.
  def display_string
    if !close # there can also be no opening, because of validations
      I18n.t 'opening.display_string.appointment'

    else
      format_string = I18n.t 'opening.display_string.time_format'
      open_string = I18n.l(open, format: format_string)
      close_string = I18n.l(close, format: format_string)
      # midnight exception for de format. Can be expanded to other languages
      # by checking close.hour and close.minutes and adding content in locales
      if close_string == '00:00 Uhr'
        close_string = I18n.t('opening.display_string.midnight_exception')
      end
      I18n.t 'opening.display_string.time_frame',
             open: open_string,
             close: close_string
    end
  end
end
