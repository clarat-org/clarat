class Feedback < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include CRUD
    include Pundit
    model Feedback, :create

    # policy do |params|
    #   binding.pry
    #   # authorize model
    # end

    contract do
      property :name
      property :email
      property :message
      property :url
      property :reporting

      validates :name, presence: true, allow_blank: false
      validates :message, presence: true, allow_blank: false

      validates :email,
                format: /\A.+@.+\..+\z/, allow_blank: false,
                if: ->(contact) { contact.reporting.blank? }
      validates :email,
                format: /\A.+@.+\..+\z/, allow_blank: true,
                unless: ->(contact) { contact.reporting.blank? }
    end

    def process params
      # Pundit.policy!(params[:current_user], model).create?

      validate(params[:feedback]) do |f|
        f.save
      end
    end
  end
end
