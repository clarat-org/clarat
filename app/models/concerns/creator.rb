module Creator
  extend ActiveSupport::Concern

  included do
    def creator
      User.find(created_by).name
    rescue
      'anonymous'
    end
  end
end
