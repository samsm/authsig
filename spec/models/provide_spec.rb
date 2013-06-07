require 'spec_helper'

describe Provide do
  context "prep" do

    it "should override with 'provided' variables" do
      yesterday = Time.now - 60*60*24
      provide = Provide.new("time")
      expect(Time.iso8601(provide.params["time"])).to be > yesterday
    end

    it "should not populate random provides" do
      provide = Provide.new(["foobarbaz"])
      expect(provide.params["foobarbaz"]).to be_nil
      expect(provide.params.keys).to be_empty
    end

    it "should provide login" do
      user = OpenStruct.new(login: "test")
      provide = Provide.new("login", user)
      expect(provide.params["login"]).to eq("test")
    end

    it "should provide service" do
      user = OpenStruct.new(service: "test")
      provide = Provide.new("service", user)
      expect(provide.params["service"]).to eq("test")
    end

  end
end
