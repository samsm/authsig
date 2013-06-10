require 'spec_helper'
require 'ostruct'

describe VerificationValidity do
  let(:time) { Time.iso8601("2013-05-21T17:17:19Z") }
  # signature $2a$...9g6 for {"time" => time, "login" => "test"}
  let(:signature) { "$2a$10$XJDfnrt/dMlEEa7MyApCjeyg6kQxOVLAuBzkhm8hV1ONdgcu/nvIm" }

  let(:naked_verification) { VerificationValidity.new({}) }

  context "prep" do
    it "should validate presense of login" do
      expect_errors_on(naked_verification, :prep, :login)
    end

    it "should validate presense of user when login is present" do
      with_login = VerificationValidity.new("login" => "test")
      expect_errors_on(with_login, :prep, :user)
    end

    it "should not allow wrong user to verify" do
      user = OpenStruct.new(login: 'different', service: "password")
      verification = VerificationValidity.new({"login" => "test"}, user)
      expect_errors_on(verification, :prep, :user)
      expect(verification.errors.on(:user)).to eq ["User doesn't match params user."]
    end

    it "should allow correct user" do
      user = OpenStruct.new(login: 'test', service: "password")
      verification = VerificationValidity.new({"login" => "test"}, user)
      verification.valid?(:prep)
      expect(verification.errors.on(:user)).to be_nil
    end

    it "should ensure time is close to current time" do
      ten_minutes_ago = Time.now - (10 * 60)
      verification = VerificationValidity.new({"time" => ten_minutes_ago.iso8601})
      expect_errors_on(verification, :prep, :time)
    end

    it "should acept close times" do
      verification = VerificationValidity.new({"time" => Time.now.iso8601})
      expect(verification).not_to be_valid(:prep)
      expect(verification.errors.on(:time)).to be_blank
    end

  end

  context "verify" do
    it "should validate presense of signature" do
      expect_errors_on(naked_verification, :verify, :signature)
    end
  end

  context "time" do
    it "should parse iso8601 time" do
      verification = VerificationValidity.new({"time" => time.iso8601})
      expect(verification.time).to eq time
    end

    it "should parse epoch time" do
      verification = VerificationValidity.new({"time" => time.to_i})
      expect(verification.time).to eq time
    end

    it "should parse iso8601 time" do
      unparsed = "Tue May 21 17:17:19 UTC 2013"
      verification = VerificationValidity.new({"time" => unparsed})
      expect(verification.time).to eq time
    end

    it "should raise error on unparsable time" do
      verification = VerificationValidity.new({"time" => 'nonsense'})
      expect { verification.time }.to raise_error
    end
  end

  it "should verify valid signed params" do
    verification = VerificationValidity.new({"time" => time, "secret" => 'not really a secret',
                                             "login" => "test", "signature" => signature})
    expect(verification).to be_signature_match
  end

end
