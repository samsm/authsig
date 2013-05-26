require 'spec_helper'
require 'ostruct'

describe "Verify controller" do
  include Warden::Test::Helpers
  after { Warden.test_reset! }
  describe "index" do
    before do
      get "/verify"
    end

    it "returns explanatory message" do
      expect(last_response.body).to match "Provide an identity"
    end
  end

  describe "unsigned" do

    it "show signed url to correct logged in user" do
      user = OpenStruct.new login: "test", service: "password"
      login_as(user)

      get "/verify", login: 'test'
      expect(last_response.body).
        to match "The following link verifies that AuthSig has confirmed your identity"
    end

    it "returns explanatory message" do
      get "/verify", login: 'test'
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
