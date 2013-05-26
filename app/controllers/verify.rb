Authsig::App.controllers :verify do

  get :verify, map: '' do
    pass unless params[:signature] && params[:login]
    @verification = Verification.new(params, current_user)
    @verification.valid?(:verify)
    render "verify/verify"
  end

  get :unsigned, map: '' do
    pass unless params[:login]
    load_verification(:prep, current_user)
    render "verify/unsigned"
  end

  get :index do
    render "verify/index"
  end

  define_method :load_verification do |context, user|
    verification = Verification.new(params, user)
    @verification = VerificationPresenter.new(verification, context)
  end

end