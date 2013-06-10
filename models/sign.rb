require 'bcrypt'

class Sign
  attr_reader :data

  def initialize(data = {})
    @signature = data.delete('signature')
    @data      = data
  end

  def create_signature
    BCrypt::Password.create(sha512d(to_sign), cost: BCrypt::Engine::DEFAULT_COST)
  end

  def match?
    signature == sha512d(to_sign)
  end

  private

  def signature
    BCrypt::Password.new(@signature)
  rescue BCrypt::Errors::InvalidHash
    NeverMatches.new
  end

  def to_sign
    # I'm 55% convinced this does not need further escaping.
    # With the signature, the match must be identical,
    # injection isn't really possible.
    # Maybe pair.last.to_json?
    # The fear would be something like:
    # ?login=user1:login=user2&service=password
    preped = data.sort
    Hash[preped].inject('') {|sum, pair| sum += "#{pair.first}:#{pair.last}" }
  end

  def sha512d(to_sha512)
    @@sha512 ||= Digest::SHA256.new
    @@sha512.digest(to_sha512)
  end
end

class NeverMatches
  def ==(other)
    false
  end
end