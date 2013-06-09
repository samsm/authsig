require 'spec_helper'

describe "DefaultsController" do
  it "should create an default" do
    expect { post "defaults", {slug: "test-slug", hi: "there"} }.
      to change(Default, :count).by(1)
  end
end
