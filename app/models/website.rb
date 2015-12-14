# Monkeypatch clarat_base Website
require ClaratBase::Engine.root.join('app', 'models', 'website')

class Website < ActiveRecord::Base
  # Frontend-only Methods

  def pdf_appendix
    url.ends_with?('.pdf') ? ' (PDF)' : ''
  end
end
