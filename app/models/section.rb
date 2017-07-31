# frozen_string_literal: true
require ClaratBase::Engine.root.join(
  'app', 'models', 'section'
)

class Section < ApplicationRecord
  DEFAULT = 'refugees'

  # Order so that the default (refugees) is always first
  default_scope { order('identifier DESC') }
end
