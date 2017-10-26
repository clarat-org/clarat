# frozen_string_literal: true

# Monkeypatch clarat_base Opening
require ClaratBase::Engine.root.join('app', 'models', 'opening')

class Opening < ApplicationRecord
  # Frontend Methods

  # The way an opening time frame is displayed to the user in the front end.
  def display_string
    if close
      close_string = close
      # midnight exception for de format. Can be expanded to other languages
      # by checking close.hour and close.minutes and adding content in locales
      if close_string == '00:00'
        close_string = I18n.t('opening.display_string.midnight_exception')
      end
      time_frame(open, close_string)
    else # there can also be no opening, because of validations
      I18n.t 'opening.display_string.appointment'
    end
  end

  private

  def time_frame open, close_string
    I18n.t(
      'opening.display_string.time_frame',
      open: open,
      close: close_string
    )
  end
end
