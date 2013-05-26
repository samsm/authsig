source 'https://rubygems.org'

# Distribute your app as a gem
# gemspec

# Server requirements
gem 'thin' # or mongrel
# gem 'trinidad', :platform => 'jruby'

# Optional JSON codec (faster performance)
# gem 'oj'

# Project requirements
gem 'rake'

# Component requirements
gem 'bcrypt-ruby', :require => 'bcrypt'
gem 'haml'
gem 'dm-sqlite-adapter', group: [:development, :test]
gem 'dm-validations'
gem 'dm-timestamps'
gem 'dm-migrations'
gem 'dm-constraints'
gem 'dm-aggregates'
gem 'dm-types'
gem 'dm-core'
gem 'dm-types'

# Due to some weird bundler or gem bug. I don't know.
gem 'tilt', '1.3.7'

# Test requirements

# Padrino Stable Gem
gem 'padrino', '0.11.1'

# Or Padrino Edge
# gem 'padrino', :github => 'padrino/padrino-framework'

# Or Individual Gems
# %w(core gen helpers cache mailer admin).each do |g|
#   gem 'padrino-' + g, '0.11.1'
# end

# Pardino warden auth
gem 'padrino-warden'

# Pry, fancy irb
gem 'pry-padrino'

# # a unified interface to key/value stores
# gem 'moneta'

# Test requirements
gem 'rr', :group => 'test'
gem 'rspec', :group => 'test'
gem 'rack-test', :require => 'rack/test', :group => 'test'

# Heroku
gem 'dm-postgres-adapter', :group => :production