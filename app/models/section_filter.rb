require ClaratBase::Engine.root.join(
  'app', 'models', 'filters', 'section_filter'
)

class SectionFilter < Filter
  # Order so that the default (refugees) is always first
  default_scope { order('identifier DESC') }
end
