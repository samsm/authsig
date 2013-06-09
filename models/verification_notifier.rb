require 'json'
require 'rest_client'

class VerificationNotifier
  attr_reader :url, :data
  def initialize(url, data = nil)
    @url, @data = url, data
  end

  def send?
    url
  end

  def send
    RestClient::Request.execute method: :post,
                                payload: json,
                                url:     url,
                                timeout: 5,
                                open_timeout:5,
                                headers: {content_type: :json, accept: :json}
  end

  private

  def json
    {
      verified: true,
      data: data
    }
  end
end
