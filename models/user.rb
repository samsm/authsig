class User
  include DataMapper::Resource

  property :id, Serial
  property :service, String
  property :login, String, required: true, unique: true, length: 1..1000
  property :password, BCryptHash, required: true, length: 1..1000
  property :data, Json



  def self.authenticate_password(login, password)
    u = first(login: login, service: 'password')
    u if u && u.password == password
  end

end
