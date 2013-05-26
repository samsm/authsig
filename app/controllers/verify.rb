Authsig::App.controllers :verify do

  get :verified, map: '/verify/verified' do
    load_verification(:verify, current_user)
    # @verification = Verification.new(params, current_user)
    # @verification.valid?(:verify)
    render "verify/verify"
  end

  get :request, map: '/verify/request' do
    load_verification(:prep, current_user)
    render "verify/unsigned"
  end

  get :index do
    # Create a request?
    render "verify/index"
  end

  define_method :load_verification do |context, user|
    verification = Verification.new(params, user)
    @verification = VerificationPresenter.new(verification, context)
  end

end
