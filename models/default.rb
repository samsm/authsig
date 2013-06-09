class Default
  include DataMapper::Resource

  property :id, Serial
  property :slug, String
  property :params, Json
  property :compromised, Boolean

  validates_presence_of :slug
  validates_length_of   :slug, within: 1..255
  validates_presence_of :params
  validates_with_method :params, method: :params_are_a_hash

  def params_are_a_hash
    return true if params.respond_to?(:merge)
    [false, "Params are not a hash."]
  end

  def self.new_from_params(params)
    local_params = params.dup
    slug = local_params.delete("slug")
    new(slug: slug, params: local_params)
  end

end
