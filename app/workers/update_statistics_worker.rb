class UpdateStatisticsWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily.hour_of_day(23) }

  def perform
    current_date = Date.current

    Offer.transaction do
      create_statistics_for 'created', 'offer', current_date
      create_statistics_for 'approved', 'offer', current_date
    end

    Organization.transaction do
      create_statistics_for 'created', 'organization', current_date
      create_statistics_for 'approved', 'organization', current_date
    end
  end

  def create_statistics_for action, object, date
    klass = object.titleize.constantize
    topic = "#{object}_#{action}"

    # See if there were any objects that got acted on today
    collection = klass.send("#{action}_at_day", date)
    return unless collection.any?

    # For each user that did the action, create a statistic with how often
    # he or she did the action
    collection.select("DISTINCT(#{action}_by)").each do |unique_actor|
      actor_id = unique_actor.send("#{action}_by")
      y_count = collection.where("#{action}_by = ?", actor_id).count
      Statistic.create! topic: topic, user_id: actor_id, x: date, y: y_count
    end
  end
end
