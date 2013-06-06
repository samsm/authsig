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
  validates_with_method :user, method: :user_match_validation, when: [:prep], if: lambda {|v| v.login }
  validates_with_method :time, method: :close_to_correct_time, when: [:prep], if: lambda {|v| v.time  }

  validates_with_method :provided, method: :can_populate_all_provided, when: [:prep]


  def close_to_correct_time
    ((Time.now + time_fudge) > time) &&
    (time > (Time.now - time_fudge))
  end

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

  def can_populate_all_provided
    blanks = provided_populated.reject {|k,v| !v.blank? }
    return true if blanks.empty?
    [false, "AuthSig couldn't populate a field requested to be provided."]
  end

  attr_reader :params, :user
  def initialize(params, user = nil)
    @params, @user = params.dup, user
    apply_provides
  end

  def apply_provides
    params.merge!(provided_populated)
  end

  def secret
    Authsig.house_secret
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

  def provides
    [params["provides"]].flatten.compact
  end

  def provided_populated
    provides.inject({}) do |sum, i|
      sum[i] = provide(i)
      sum
    end
    # provides.collect {|p| provide(p) }
  end

  def provide(providable_item)
    case providable_item
    when "time"
      Time.now.utc.iso8601
    when "login"
      user && user.login
    when "service"
      user && user.service
    end
  rescue
    # Should get more specific safeguards here.
    nil
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

  def time_fudge
    # fudge is a radius: 5 minute fudge provides a 10 minute window, 5 minutes before and after
    params["time_fudge"] || 300 # in seconds, default to 5 minutes
  end

  def service
    params["service"].blank? ? "password" : params["service"]
  end

  def sign
    Sign.new(params.merge(provided_populated), secret)
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
