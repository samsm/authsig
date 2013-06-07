class VerificationDefault
  attr_reader :default_slugs
  def initialize(default_slugs)
    @default_slugs = default_slugs || Array.new
  end

  def params
    defaults.inject({}) do |hsh, default|
      hsh.merge!(default.params)
      hsh
    end
  end

  private

  def defaults
    return [] unless default_slugs.any?
    @overrides ||= Override.all(slug: default_slugs)
  end

  def ordered_defaults
    default_slugs.collect {|slug| defaults.detect {|d| d.slug == slug } }
  end

  def missing_slugs?
    ordered_defaults.include?(nil)
  end

end
