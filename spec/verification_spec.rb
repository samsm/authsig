require 'spec_helper'
require 'ostruct'

describe Verification do

  let(:time) { Time.iso8601("2013-05-21T17:17:19Z") }
  # signature $2a$...9g6 for {"time" => time, "login" => "test"}
  let(:signature) { "$2a$10$8NlTzn4iM/ZEG3hZo7qqq.QRPf0/cYtGygnz0Y3i.xxOd0Mod.9g6" }

  let(:naked_verification) { Verification.new({}) }

  context "overrides" do
    before do
      Override.destroy
    end
    let(:override) {Override.create(slug: "slug", params: {"notify"=> "abc"})}
    it "should override" do
      verification = Verification.new({"overrides" => [override.slug]})
      expect(verification.notify).to eq "abc"
    end

    it "should take precedence when overriding" do
      verification = Verification.new({"notify" => "xyz", "overrides" => [override.slug]})
      expect(verification.notify).to eq "abc"
    end
  end

  context "prep" do
    it "should validate presense of login" do
      expect_errors_on(naked_verification, :prep, :login)
    end

    it "should validate presense of user when login is present" do
      with_login = Verification.new("login" => "test")
      expect_errors_on(with_login, :prep, :user)
    end

    it "should not allow wrong user to verify" do
      user = OpenStruct.new(login: 'different', service: "password")
      verification = Verification.new({"login" => "test"}, user)
      expect_errors_on(verification, :prep, :user)
      expect(verification.errors.on(:user)).to eq ["User doesn't match params user."]
    end

    it "should ensure time is close to current time" do
      ten_minutes_ago = Time.now - (10 * 60)
      verification = Verification.new({"time" => ten_minutes_ago.iso8601})
      expect_errors_on(verification, :prep, :time)
    end

    it "should acept close times" do
      verification = Verification.new({"time" => Time.now.iso8601})
      expect(verification).not_to be_valid(:prep)
      expect(verification.errors.on(:time)).to be_blank
    end

    it "should override with 'provided' variables" do
      yesterday = Time.now - 60*60*24
      verification = Verification.new({"time" => yesterday.to_i, "provides" => "time"})
      expect(verification.time).to be > yesterday
    end

    it "should not populate random provides" do
      verification = Verification.new({"provides" => "foobarbaz"})
      expect_errors_on(verification, :prep, :provided)
      expect(verification.errors.on(:provided)).to eq ["AuthSig couldn't populate a field requested to be provided."]
    end

    it "should provide time" do
      verification = Verification.new({"provides" => "time"})
      populated_time = verification.provided_populated["time"]
      expect(Time.iso8601(populated_time)).to be <= Time.now
    end

    it "should provide login" do
      user = OpenStruct.new(login: "test")
      verification = Verification.new({"provides" => "login"}, user)
      populated_login = verification.provided_populated["login"]
      expect(populated_login).to eq "test"
    end

    it "should provide service" do
      user = OpenStruct.new(service: "test")
      verification = Verification.new({"provides" => "service"}, user)
      populated_service = verification.provided_populated["service"]
      expect(populated_service).to eq "test"
    end

  end

  context "verify" do
    it "should validate presense of signature" do
      expect_errors_on(naked_verification, :verify, :signature)
    end
  end

  it "should parse iso8601 time" do
    verification = Verification.new({"time" => time.iso8601})
    expect(verification.time).to eq time
  end

  it "should parse epoch time" do
    verification = Verification.new({"time" => time.to_i})
    expect(verification.time).to eq time
  end

  it "should parse iso8601 time" do
    unparsed = "Tue May 21 17:17:19 UTC 2013"
    verification = Verification.new({"time" => unparsed})
    expect(verification.time).to eq time
  end

  it "should raise error on unparsable time" do
    verification = Verification.new({"time" => 'nonsense'})
    expect { verification.time }.to raise_error
  end


  it "should verify valid params" do
    verification = Verification.new({"time" => time, "login" => "test", "signature" => signature})
    expect(verification).to be_signature_match
  end

end
