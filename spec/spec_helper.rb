PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)
require File.expand_path(File.dirname(__FILE__) + "/../config/boot")

RSpec.configure do |config|
  config.mock_with :rr
  config.include Rack::Test::Methods

  config.before(:all) do
    DataMapper.auto_upgrade!
  end

end

def app
  ##
  # You can handle all padrino applications using instead:
  #   Padrino.application
  Authsig::App.tap { |app| app.set :protect_from_csrf, false }
end

def expect_errors_on(v, validation_context = :default, *fields)
  expect(v).not_to be_valid(validation_context)
  fields.each do |f|
    expect(v.errors.on(f.to_sym)).not_to be_nil, "field :#{f} didn't have errors"
  end
end

ENV["AUTHSIG_HOUSE_SECRET"] = "Test house secret."

