module Authsig
  class TestNotifier < Padrino::Application
    register Padrino::Rendering
    register Padrino::Mailer
    register Padrino::Helpers

    enable :sessions

    set :protect_from_csrf, false

    post :test_verification, map: "/test_verification" do
      logger.info "**Test Verification!"
      logger.info "** #{params.inspect}"
      logger.info "**/done"
      'Done!'
    end

  end
end
