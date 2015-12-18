# Monkeypatch clarat_base Opening
require ClaratBase::Engine.root.join('app', 'models', 'opening')

class Opening < ActiveRecord::Base
  # Frontend Methods

  # The way an opening time frame is displayed to the user in the front end.
  def display_string
    if !close # there can also be no opening, because of validations
      I18n.t 'opening.display_string.appointment'

    elsif close.strftime('%H:%M') == '00:00'
      I18n.t 'opening.display_string.time_frame', open: open.strftime('%H:%M'),
                                                  close: '24:00'
    else
      I18n.t 'opening.display_string.time_frame', open: open.strftime('%H:%M'),
                                                  close: close.strftime('%H:%M')
    end
  end
end
