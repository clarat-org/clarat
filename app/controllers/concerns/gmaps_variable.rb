# Google Maps variable setter for Offer and Organization
module GmapsVariable
  extend ActiveSupport::Concern

  included do
    before_action :initialize_markers, only: [:show]

    # TODO: simplify (only used in #show for single marker)
    def prepare_gmaps_variable object
      return unless object.location
      key = Geolocation.new(object.location)
      key_s = key.to_s

      @markers[key_s] = {
        position: key.to_h,
        ids: [object.id],
        # offer only key:
        url: offer_url(section: @current_section, id: object.slug)
      }.merge object.gmaps_info
    end
  end

  private

  def initialize_markers
    @markers = {}
  end
end
