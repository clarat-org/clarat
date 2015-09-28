require 'net/http'
require 'uri'

class AsanaCommunicator
  def initialize
    @token = Rails.application.secrets.asana_token
  end

  def create_expire_task offer
    organization_names = offer.organizations.pluck(:name).join(',')
    post_to_api(
      '/tasks',
      workspace: '41140436022602', projects: %w(44856824806357),
      name: "#{organization_names}-#{offer.expires_at}-#{offer.name}",
      notes: "Expired: http://www.clarat.org/admin/offer/#{offer.id}/edit"
    )
  end

  private

  def post_to_api endpoint, form_hash
    request = Net::HTTP::Post.new("/api/1.0#{endpoint}")
    request.set_form_data form_hash
    request['Authorization'] = "Bearer #{@token}"
    send_request_to_api request
  end

  def send_request_to_api request
    uri = URI.parse('https://app.asana.com')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.request(request)
  end
end
