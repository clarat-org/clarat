class Offer
  module Statistics
    extend ActiveSupport::Concern

    included do
      extend RailsAdminStatistics

      def self.stats
        _stats.push(
          name: 'Weekly by user',
          created: stats_by_user(:created, true),
          approved: stats_by_user(:approved, true)
        ).push(
          name: 'Cumulative by user',
          created: stats_by_user(:created, false),
          approved: stats_by_user(:approved, false)
        )
      end

      def self.stats_by_user field, use_start_time
        user_stats = {}

        User.researcher.select(:id, :email, :role).find_each do |u|
          user_stats[u.email] = []

          RailsAdminStatistics.per_cweek do |cweek, year|
            stat = calculate_user_stat field, use_start_time, cweek, year
            user_stats[u.email] << stat
          end
        end

        user_stats
      end

      def self.calculate_user_stat field, use_start_time, cweek, year
        start_time = Date.commercial(year, cweek).to_datetime
        end_time = start_time.end_of_week

        column_name = field.to_s + '_at'
        count = self.select(:id).where('? <= ?', column_name, end_time)
        count = count.where('? >= ?', column_name, start_time) if use_start_time
        count = count.count
        [start_time.to_i * 1000, count]
      end
    end
  end
end
