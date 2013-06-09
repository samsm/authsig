require 'ostruct'

Authsig::App.controllers :verify do

  get :verified, map: '/verify/verified' do
    # Is current_user unnecessary here?
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
      render "verify/request"
    end
  end

  get :index, map: '/' do
    user = OpenStruct.new(login: "id-to-verify", service: "password")
    load_verification({"login" => "id-to-verify"}, user)
    load_verification_presenter(@verification, :verify)
    render :root
  end

  post :test_verification, map: "/test-notifer", csrf_protection: false do
    logger.info "**Test Verification!"
    logger.info "** #{params.inspect}"
    logger.info "**/done"
    'Done!'
  end

  define_method :load_verification do |params, user|
    @verification = Verification.new(params, user)
  end

  define_method :load_verification_presenter do |verification, context|
    @verification_presenter = VerificationPresenter.new(verification, context)
  end

  define_method :verification_notifications do
    vn = VerificationNotifier.new(@verification_presenter.notify_url, @verification_presenter.signed_data)
    vn.send if vn.send? rescue RestClient::Forbidden
  end

end
