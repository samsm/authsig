require 'spec_helper'

describe "OverridesController" do
  it "should create an override" do
    expect { post "overrides", {slug: "test-slug", hi: "there"} }.
      to change(Override, :count).by(1)
  end
end
