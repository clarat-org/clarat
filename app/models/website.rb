# frozen_string_literal: true

# Monkeypatch clarat_base Website
require ClaratBase::Engine.root.join('app', 'models', 'website')

class Website < ApplicationRecord
  # Frontend-only Methods

  def pdf_appendix
    url.ends_with?('.pdf') ? ' (PDF)' : ''
  end

  def shorten_url
    CGI.unescape(URI.parse(self.url).host)
  end
end
