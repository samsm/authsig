require 'dm-validations'
class Verification
  include DataMapper::Validations

  verify_context = [:verify]
  prep_context   = [:prep] + verify_context

  validates_presence_of :login, when: prep_context
  validates_format_of   :login, with: /\w+/, when: prep_context
  validates_presence_of :secret, when: prep_context
  validates_presence_of :signature, when: verify_context
  validates_with_method :signature, method: :signature_match_validation, when: verify_context
  validates_with_method :user, method: :user_match_validation, when: [:prep], if: lambda { |v| v.login }

  def signature_match_validation
    (!signature || signature_match?) ? true : [false, "Signature didn't match"]
  end

  def user_match_validation
    return([false, "No user provided"]) unless user
    user_match? ? true : [false, "User doesn't match params user."]
  end

  def user_match?
    return false unless user
    user.login == login && user.service == service
  end

  attr_reader :params, :user
  def initialize(params, user = nil)
    @params, @user = params, user
  end

  def secret
    # Secret.valid_time(time).valid_login(secret_login, secret_service).first.random
    'not really a secret'
  end

  def hide?
    params["hide"]
  end

  def show?
    !hide?
  end

  def notify?
    notify
  end

  def notify
    params["notify"]
  end

  # simple accessors
  [:redirect_url, :secret_login, :secret_service, :login, :signature].each do |accessor|
    define_method accessor do
      params[accessor.to_s]
    end
  end

  # Should there be secrets without time?
  # Should time always be in the sig url?
  # Should there be another reader for Ruby (vs String) Time?
  # Should be Ruby time, because params will be interpretted literally for url.
  # These methods are just for additional actions (expiration, etc)
  def time
    time_parse(params["time"])
  end

  def service
    params["service"] || "password"
  end

  def sign
    Sign.new(params, secret)
  end

  def signature_match?
    sign.match?
  end

  private
  def time_parse(maybe_time)
    return nil unless maybe_time
    return maybe_time if maybe_time.kind_of?(Time)
    [:at, :iso8601, :parse].each do |strategy|
      parsed = Time.send(strategy, maybe_time) rescue nil
      return parsed if parsed
    end
    raise "Invalid time"
  end

end
