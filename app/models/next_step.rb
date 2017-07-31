# frozen_string_literal: true
# Monkeypatch clarat_base NextStep
require ClaratBase::Engine.root.join('app', 'models', 'next_step')

class NextStep < ApplicationRecord
  # Frontend-only Methods

  # Scopes
  scope :in_current_locale, lambda {
    where("next_steps.text_#{sanitize_sql(I18n.locale)} != ?", '')
      .where.not("text_#{sanitize_sql(I18n.locale)}" => nil)
  }
end
