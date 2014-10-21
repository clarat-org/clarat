require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

# module RailsAdminStatistics
# end

module RailsAdmin
  module Config
    module Actions
      class Statistics < RailsAdmin::Config::Actions::Base

        register_instance_option :collection? do
          true
        end

        register_instance_option :link_icon do
          'fa fa-line-chart'
        end

        register_instance_option :controller do
          Proc.new do
            @stats = {created: []}
            model = @abstract_model.model

            # find out how many weeks there have been since the first creation
            oldest = model.select(:created_at).order(created_at: :asc).first
            this_year = Time.now.year
            (1..Time.now.to_date.cweek).each do |i|
              start_time = Date.commercial(this_year, i).to_datetime
              end_time = start_time.end_of_week

              count = model.where('created_at >= ?', start_time).
                      where('created_at <= ?', end_time).count
              @stats[:created] << [i, count]
            end

            # if @abstract_model.responds_to? :approved_at
            #   @stats[:approved] = []
            # end

            render action: :statistics
          end
        end

        RailsAdmin::Config::Actions.register(self)
      end
    end
  end
end
