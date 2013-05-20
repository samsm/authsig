require 'spec_helper'
require 'ostruct'

describe Verification do

  let(:time) { Time.iso8601("2013-05-21T17:17:19Z") }
  # signature $2a$...9g6 for {"time" => time, "login" => "test"}
  let(:signature) { "$2a$10$8NlTzn4iM/ZEG3hZo7qqq.QRPf0/cYtGygnz0Y3i.xxOd0Mod.9g6" }

  let(:naked_verification) { Verification.new({}) }

  def expect_errors_on(v, validation_context, *fields)
    expect(v).not_to be_valid(validation_context)
    fields.each do |f|
      expect(v.errors.on(f.to_sym)).not_to be_nil, "field :#{f} didn't have errors"
    end
  end

  context "prep" do
    it "should validate presense of login" do
      expect_errors_on(naked_verification, :prep, :login)
    end

    it "should validate presense of user" do
      expect_errors_on(naked_verification, :prep, :user)
    end

    it "should not allow wrong user to verify" do
      user = OpenStruct.new(login: 'different')
      verification = Verification.new({"login" => "test"}, user)
      expect_errors_on(verification, :prep, :user)
      expect(verification.errors.on(:user)).to eq ["User doesn't match params user."]
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
