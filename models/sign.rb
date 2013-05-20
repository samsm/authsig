require 'bcrypt'

class Sign
  attr_reader :data, :secret
  def initialize(data = {}, secret = nil)
    @signature = data.delete('signature')
    @data, @secret = data, secret
  end

  def create_signature
    BCrypt::Password.create(to_sign, cost: BCrypt::Engine::DEFAULT_COST)
  end

  def signature
    BCrypt::Password.new(@signature)
  rescue BCrypt::Errors::InvalidHash
    NeverMatches.new
  end

  def to_signed_hash
    data.merge({"signature" => create_signature})
  end

  def match?
    signature == to_sign
  end

  private
  def to_sign
    # I'm 55% convinced this does not need further escaping.
    # With the signature, the match must be identical,
    # injection isn't really possible.
    # Maybe pair.last.to_json?
    preped = data.dup.merge!("secret" => secret).sort
    Hash[preped].inject('') {|sum, pair| sum += "#{pair.first}:#{pair.last}" }
  end
end

class NeverMatches
  def ==(other)
    false
  end
end