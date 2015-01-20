module Creator
  extend ActiveSupport::Concern

  included do
    def creator
      User.find(created_by).email
    rescue
      'anonymous'
    end
  end
end
