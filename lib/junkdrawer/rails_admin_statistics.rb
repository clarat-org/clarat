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
            # TODO: so much refactoring needed ...
            model = @abstract_model.model

            this_year = Time.now.year
            this_cweek = Time.now.to_date.cweek

            @weekly_stats = {created: []}

            (1..this_cweek).each do |i|
              start_time = Date.commercial(this_year, i).to_datetime
              end_time = start_time.end_of_week

              count = model.select(:id).where('created_at >= ?', start_time).
                      where('created_at <= ?', end_time).count
              @weekly_stats[:created] << [i, count]
            end

            if model.attribute_method? :approved_at
              @weekly_stats[:approved] = []

              (1..this_cweek).each do |i|
                start_time = Date.commercial(this_year, i).to_datetime
                end_time = start_time.end_of_week

                count = model.select(:id).where('approved_at >= ?', start_time).
                        where('approved_at <= ?', end_time).count
                @weekly_stats[:approved] << [i, count]
              end
            end


            @cumulative_stats = {created: []}

            (1..this_cweek).each do |i|
              start_time = Date.commercial(this_year, i).to_datetime
              end_time = start_time.end_of_week

              count = model.select(:id).where('created_at <= ?', end_time).
                      count
              @cumulative_stats[:created] << [i, count]
            end

            if model.attribute_method? :approved_at
              @cumulative_stats[:approved] = []

              (1..this_cweek).each do |i|
                start_time = Date.commercial(this_year, i).to_datetime
                end_time = start_time.end_of_week

                count = model.select(:id).
                        where('approved_at <= ?', end_time).count
                @cumulative_stats[:approved] << [i, count]
              end
            end

            render action: :statistics
          end
        end

        RailsAdmin::Config::Actions.register(self)
      end
    end
  end
end
