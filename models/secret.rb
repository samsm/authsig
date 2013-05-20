require 'dm-timestamps'

class Secret
  include DataMapper::Resource

  property :id, Serial
  property :random, String
  property :valid_start, DateTime
  property :valid_end, DateTime
  property :created_at, DateTime
  property :login, String
  property :service, String

  def self.valid_time(time = nil)
    time = time.try(:to_time) # in case time is a date
    # Instead of "all", should possibly use just timeless secret
    return all(:order => [:created_at.desc]) unless time
    all(:valid_start.lte => time, :valid_end.gte => time, :order => [:created_at.desc])
  end

  def self.valid_login(login = nil, service = 'password')
    login, service = Authsig.admin_login, Authsig.admin_service unless login
    all(login: login, service: service)
  end

  before :save do
    self.random ||= SecureRandom.base64(32)
  end

end
