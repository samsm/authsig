require 'spec_helper'

describe "AppController" do

  it "sanity checks" do
    get "/"
    expect(last_response).to be_ok
  end

end
