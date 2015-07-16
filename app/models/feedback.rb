# Holds a submitted feedback (/contact) form.
class Feedback < ActiveRecord::Base
  # Attributes

  # reporting: was focussed on a specific offer or orga; visitor found an issue
  #            with it
  attr_accessor :reporting
end
