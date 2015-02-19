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

      if @markers[key.to_s]
        @markers[key.to_s][:ids] << object.id
      else
        @markers[key.to_s] = {
          position: key.to_h,
          ids: [object.id],
          url: offer_url(object) # assumes offer, not used on organization
        }.merge object.gmaps_info
      end
    end
  end

  private

  def initialize_markers
    @markers = {}
  end
end
