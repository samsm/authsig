require 'dm-validations'

class VerificationValidity
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


  attr_reader :user
  def initialize(merged_params, user = nil)
    @params, @user = merged_params, user
  end

  # Not sure why this can't be private, but Validations freak out.
  def time
    time_parse(params["time"])
  end

  def signature_match?
    sign.match?
  end

  def sign
    @sign ||= Sign.new(params)
  end

  private

  [:login, :secret, :signature, :time_fudge].each do |attr|
    define_method attr do
      params[attr.to_s]
    end
  end

  def service
    params["service"] || "password"
  end

  attr_reader :params

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

  def time_fudge
    # fudge is a radius: 5 minute fudge provides a 10 minute window, 5 minutes before and after
    params["time_fudge"] || 300 # in seconds, default to 5 minutes
  end

  def time_parse(maybe_time)
    return nil unless maybe_time
    return maybe_time if maybe_time.kind_of?(Time)
    [:at, :iso8601, :parse].each do |strategy|
      parsed = Time.send(strategy, maybe_time) rescue nil
      return parsed if parsed
    end
    # Maybe this should be a validation instead.
    raise "Invalid time"
  end

end
