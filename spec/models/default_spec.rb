require 'spec_helper'

describe Default do

  it "should require slug" do
    expect_errors_on Default.new({}), :default, :slug
  end

  it "should require slug to be at least one character long" do
    expect_errors_on Default.new({"slug" => ""}), :default, :slug
  end

  it "should require params to be a hash" do
    expect_errors_on Default.new({"params" => []}), :default, :params
  end

  it "should extract slug from params to create new override" do
    d = Default.new_from_params({"slug" => "yo", "params" => {"hi" => "there"}})
    expect(d).to be_valid
  end
end
