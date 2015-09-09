# class Offer
#   module Statistics
#     extend ActiveSupport::Concern
#
#     included do
#       extend RailsAdminStatistics
#
#       def self.stats
#         _stats.push(
#           name: 'Weekly by user',
#           created: stats_by_user(:created, true),
#           approved: stats_by_user(:approved, true)
#         ).push(
#           name: 'Cumulative by user',
#           created: stats_by_user(:created, false),
#           approved: stats_by_user(:approved, false)
#         )
#       end
#
#       def self.stats_by_user field, use_start_time
#         user_stats = {}
#
#         User.researcher.select(:id, :name, :role).find_each do |u|
#           user_stats[u.name] = []
#
#           RailsAdminStatistics.per_cweek do |cweek, year|
#             stat = calculate_user_stat u.id, field, use_start_time, cweek, year
#             user_stats[u.name] << stat
#           end
#         end
#
#         user_stats
#       end
#
#       def self.calculate_user_stat user_id, field, use_start_time, cweek, year
#         start_time = Date.commercial(year, cweek).to_datetime
#         end_time = start_time.end_of_week
#
#         time_column = field.to_s + '_at'
#         user_column = field.to_s + '_by'
#         count = self.where("#{time_column} <= ?", end_time)
#         count = count.where(user_column => user_id)
#         count = count.where("#{time_column} >= ?", start_time) if use_start_time
#         count = count.count
#         [start_time.to_i * 1000, count]
#       end
#     end
#   end
# end
