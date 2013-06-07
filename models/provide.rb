class Provide
  def initialize(provide_keys, user = nil)
    @provide_keys, @user = [provide_keys].flatten, user
  end

  def params
    provide_keys.inject({}) do |sum, i|
      provided_value = provide(i)
      sum[i] = provide(i) if provided_value
      sum
    end
  end

  private

  attr_reader :provide_keys, :user

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
    logger.info "Couldn't provide #{providable_item}"
    nil
  end

end
