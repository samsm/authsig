require 'spec_helper'

describe Override do

  it "should require slug" do
    expect_errors_on Override.new({}), :default, :slug
  end

  it "should require slug to be at least one character long" do
    expect_errors_on Override.new({"slug" => ""}), :default, :slug
  end

  it "should require params to be a hash" do
    expect_errors_on Override.new({"params" => []}), :default, :params
  end

  it "should extract slug from params to create new override" do
    o = Override.new_from_params({"slug" => "yo", "params" => {"hi" => "there"}})
    expect(o).to be_valid
  end
end
