# Google Maps variable setter for Offer and Organization
module GmapsVariable
  extend ActiveSupport::Concern

  included do
    before_action :initialize_markers, only: [:show, :index]

    def prepare_gmaps_variables collection
      collection.each do |element|
        prepare_gmaps_variable element
      end
    end

    def prepare_gmaps_variable object
      return unless object.location
      key = Geolocation.new(object.location)

      # ToDo: Refactor logic!
      if object.class == Organization
        @markers[key.to_s] = {
          position: key.to_h,
          organization_id: [object.id],
        }.merge object.gmaps_info
      else
        if @markers[key.to_s]
          @markers[key.to_s][:offer_ids] << object.id
        else
          @markers[key.to_s] = {
            position: key.to_h,
            offer_ids: [object.id],
            url: offer_url(object)
          }.merge object.gmaps_info
        end
      end
    end
  end

  private

  def initialize_markers
    @markers = {}
  end
end
