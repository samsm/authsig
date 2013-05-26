require 'spec_helper'

describe "UsersController" do
  include Warden::Test::Helpers
  it "displays registation form" do
    get "/users"
    body = last_response.body
    expect(body).to match "Register a login and password"
  end

  it "registers login/password user" do
    expect {
      post "/users", login: "a", password: 'a'
    }.to change { User.all(service: "password").count }.by(1)
    expect(last_response).to be_redirect
    User.destroy
  end
end
