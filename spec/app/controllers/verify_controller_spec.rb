require 'spec_helper'
require 'ostruct'

describe "Verify controller" do
  include Warden::Test::Helpers
  after { Warden.test_reset! }

  describe "index" do
    it "returns explanatory message" do
      get "/"
      expect(last_response.body).to match "Request a person's identity by sending them"
    end
  end

  describe "unsigned" do

    context "with correct signed in user" do
      let(:user) { OpenStruct.new login: "test", service: "password" }
      before { login_as(user) }

      it "should show signed url to correct logged in user" do
        get "/verify/request", login: user.login
        expect(last_response.body).
          to match "The following link verifies that AuthSig has confirmed your identity"
      end

      it "should not show signed url when no login is specified" do
        get "/verify/request"
        expect(last_response.body).
          not_to match "The following link verifies that AuthSig has confirmed your identity"
      end

      it "sends login details to notify url" do
        # This song and dance is to get around mock requiring exact params
        canary = Object.new
        mock(canary).dies { "I'm dead." }
        url = "http://example.com/"
        stub(RestClient::Request).execute { |args| canary.dies if args[:url] == url }
        get "/verify/request", login: user.login, notify_url: url
      end

    end

    it "returns explanatory message" do
      get "/verify/request", login: 'test'
      expect(last_response.body).
        to match "You've arrived at this page to get AuthSig's verification of your identity."
    end
  end

  describe "verified" do

    it "should display error when verification fails" do
      get "/verify/verified", login: 'test', signature: "hi"
      expect(last_response.status).to eq(403)
      expect(last_response.body).to match "Signature did not match."
    end

    it "should verify with correct signature" do
      get "/verify/verified", login: 'test', signature: "$2a$10$DDpnP1sSQAqASAc7eu9o4OWsV27oxM7SKLm58EIfF5q3pgWr3vKJy"
      expect(last_response.status).to eq(200)
    end
  end

  describe "bounce" do
    # Don't show the end user the signature.
  end
end
