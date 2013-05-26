require 'json'

class VerificationNotifier
  attr_reader :verification
  def initialize(verification)
    @verification = verification
  end

  def send?
    verification.notify? && verification.user_match?
  end

  def send
    RestClient.post url, json, content_type: :json, accept: :json
  end

  private
  def url
    verification.notify
  end

  def json
    {
      verified: true,
      data: verification.params
    }
  end
end
