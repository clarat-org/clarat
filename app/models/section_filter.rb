require ClaratBase::Engine.root.join(
  'app', 'models', 'section_filter'
)

class SectionFilter < ActiveRecord::Base
  DEFAULT = 'refugees'

  # Order so that the default (refugees) is always first
  default_scope { order('identifier DESC') }
end
