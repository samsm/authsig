require 'spec_helper'

describe Sign do
  let(:example_data) { {"login" => "test", "service" => "password", "secret" => secret } }
  let(:data_with_signature) { example_data.merge("signature" => example_signature) }
  let(:example_signature) { "$2a$10$snSW6V1YSBmovmevGZmqKOHiNa58Jwl9TJufQWe.o1gGUEmaIYe5i" }
  let(:secret) { 'hi' }
  let(:sign) { Sign.new(example_data) }

  it "should be a class" do
    expect(Sign).to be_a_kind_of Class
  end

  it "should create a signature" do
    signature = sign.create_signature
    expect(signature).to match /.{60}/
  end

  it "should verify new signature" do
    new_signature = sign.create_signature
    new_sign = Sign.new(example_data.merge("signature"=> new_signature))
    expect(new_sign).to be_match
  end

  it "should verify test signature" do
    expect(Sign.new(data_with_signature)).to be_match
  end

  it "should not verify tampered data" do
    tampered = data_with_signature.merge("login" => 'super-admin')
    expect(Sign.new(tampered)).not_to be_match
  end

  it "should not verify with incorrect secret" do
    tampered = 'bye'
    data_with_signature.merge!("secret" => tampered)
    expect(Sign.new(data_with_signature)).not_to be_match
  end

end
