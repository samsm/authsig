class User
  include DataMapper::Resource

  property :id, Serial
  property :service, String
  property :login, String
  property :password, BCryptHash
  property :data, Json

  def self.authenticate_password(login, password)
    u = first(login: login, service: 'password')
    u if u && u.password == password
  end
end
