# frozen_string_literal: true

# Monkeypatch clarat_base Website
require ClaratBase::Engine.root.join('app', 'models', 'website')

class Website < ApplicationRecord
  # Frontend-only Methods

  def pdf_appendix
    url.ends_with?('.pdf') ? ' (PDF)' : ''
  end

  # rubocop:disable Lint/UriEscapeUnescape
  def shorten_url
    URI.unescape(URI.parse(URI.escape(self.url)).host)
  end
  # rubocop:enable Lint/UriEscapeUnescape
end
