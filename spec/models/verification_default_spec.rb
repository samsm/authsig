require 'spec_helper'

describe VerificationDefault do
  let(:override) {}

  before do
    Default.destroy
    Default.create(slug: "slug",  params: {"a"=>"1", "b"=>"2"})
    Default.create(slug: "slug2", params: {"b"=>"3", "c"=>"4"})
  end

  it "should load and merge default params" do
    vd = VerificationDefault.new(%w(slug slug2))
    expect(vd.params).to eq({"a"=> "1", "b"=>"3", "c"=> "4"})
    Default.destroy
  end
end
