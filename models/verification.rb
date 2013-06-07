class Verification

  attr_reader :original_params, :user, :defaults, :provides
  def initialize(params, user = nil)
    @original_params, @user = params.dup, user
    @provides = Provide.new(original_params["provides"], user)
    @defaults = VerificationDefault.new(original_params["default"])
  end

  def valid?(context)
    validity.valid?(context)
  end

  def errors
    validity.errors
  end

  def url(view)
    verify_path = view.url(:verify, :verified, signed_populated_params)
    view.uri verify_path
  end

  def show?
    !defaulted_populated_params["hide"]
  end

  def populated_params
    original_params.merge(provides.params)
  end

  # These values should influence the signature but not appear in the url
  def defaulted_populated_params
    default_params = { "secret" => Authsig.house_secret }.merge(defaults.params)
    default_params.merge(populated_params)
  end

  def signed_populated_params
    @signed_populated_params ||= populated_params.merge("signature" => validity.sign.create_signature)
  end

  private

  def validity
    @validity ||= VerificationValidity.new(defaulted_populated_params, user)
  end

end
