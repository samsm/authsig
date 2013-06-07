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
    RestClient.post url, json, content_type: :json, accept: :json
  end

  private

  def json
    {
      verified: true,
      data: data
    }
  end
end
