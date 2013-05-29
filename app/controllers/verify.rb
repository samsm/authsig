Authsig::App.controllers :verify do

  get :verified, map: '/verify/verified' do
    load_verification(params, current_user)
    load_verification_presenter(@verification, :verify)
    status @verification_presenter.status_code
    render "verify/verify"
  end

  get :request, map: '/verify/request' do
    load_verification(params, current_user)
    load_verification_presenter(@verification, :prep)
    verification_notifications
    if @verification_presenter.redirect?
      redirect @verification_presenter.redirect_url
    else
      render "verify/unsigned"
    end
  end

  get :index do
    redirect "/"
  end

  define_method :load_verification do |params, user|
    @verification = Verification.new(params, user)
  end

  define_method :load_verification_presenter do |verification, context|
    @verification_presenter = VerificationPresenter.new(verification, context)
  end

  define_method :verification_notifications do
    vn = VerificationNotifier.new(@verification)
    vn.send if vn.send? rescue RestClient::Forbidden
  end

end
