require 'spec_helper'
require 'ostruct'

describe Verification do

  let(:time) { Time.iso8601("2013-05-21T17:17:19Z") }
  # signature $2a$...9g6 for {"time" => time, "login" => "test"}
  let(:signature) { "$2a$10$8NlTzn4iM/ZEG3hZo7qqq.QRPf0/cYtGygnz0Y3i.xxOd0Mod.9g6" }

  let(:naked_verification) { Verification.new({}) }

  # context "overrides" do
  #   before do
  #     Override.destroy
  #   end
  #   let(:override) {Override.create(slug: "slug", params: {"notify"=> "abc"})}
  #   it "should override" do
  #     verification = Verification.new({"overrides" => [override.slug]})
  #     expect(verification.notify).to eq "abc"
  #   end
  #
  #   it "should take precedence when overriding" do
  #     verification = Verification.new({"notify" => "xyz", "overrides" => [override.slug]})
  #     expect(verification.notify).to eq "abc"
  #   end
  # end


end
