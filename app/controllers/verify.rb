Authsig::App.controllers :verify do

  get :verified, map: '/verify/verified' do
    load_verification(:verify, current_user)
    render "verify/verify"
  end

  get :request, map: '/verify/request' do
    load_verification(:prep, current_user)
    vn = VerificationNotifier.new(@verification)
    vn.send if vn.send? rescue RestClient::Forbidden
    render "verify/unsigned"
  end

  get :index do
    # Create a request?
    render "verify/index"
  end

  define_method :load_verification do |context, user|
    @verification = Verification.new(params, user)
    @verification_presenter = VerificationPresenter.new(@verification, context)
  end

end
