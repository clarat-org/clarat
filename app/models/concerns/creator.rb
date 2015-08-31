module Creator
  extend ActiveSupport::Concern

  included do
    def creator
      User.find(created_by).name
    rescue
      'anonymous'
    end

    def current_actor
      ::PaperTrail.whodunnit
    end
  end
end
