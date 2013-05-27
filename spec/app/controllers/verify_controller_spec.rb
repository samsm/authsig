require 'spec_helper'
require 'ostruct'

describe "Verify controller" do
  include Warden::Test::Helpers
  after { Warden.test_reset! }

  describe "index" do
    it "returns explanatory message" do
      get "/verify"
      expect(last_response.body).to match "Provide an identity"
    end
  end

  describe "unsigned" do

    context "with correct signed in user" do
      let(:user) { OpenStruct.new login: "test", service: "password" }
      before { login_as(user) }

      it "show signed url to correct logged in user" do
        get "/verify/request", login: user.login
        expect(last_response.body).
          to match "The following link verifies that AuthSig has confirmed your identity"
      end

      it "sends login details to notify url" do
        get "/verify/request", login: user.login, notify: "http://example.com/"
        expect(true).to be_true
      end

    end

    it "returns explanatory message" do
      get "/verify/request", login: 'test'
      expect(last_response.body).
        to match "You've arrived at this page to get AuthSig's verification of your identity."
    end
  end

  describe "verified" do
    before do
      get "/verify", login: 'test', signature: "hi"
    end

    it "should confirm verfication" do
      expect(last_response.status).to eq(200)
    end
  end

  describe "bounce" do
    # Don't show the end user the signature.
  end
end
