# Just some starting thoughts about how clients might work.

module Authsig
  class Client

    def self.receive_notification(notification)
      # this might get stored somewhere
      # Perhaps:
      # http://authsig.heroku.com/verify/verified?
      #   login=user_1&
      #   notify=http://example.com/notification_endpoints/12345
      # AuthsigNotification.create notification_id: 12345, url: "http://authsig.heroku..."
    end

    def self.retrieve_notification(lookup)
      # The lookup might be 12345 in the continuation of the above scenario.
      # note = AuthsigNotification.find_by_notification_id(12345)
      # new(note.url)
    end

    def self.base_url
      case ENV["PADRINO_ENV"]
      when "development"
        "http://localhost:5000/verify"
      when "production"
        "http://authsig.herokuapp.com/verify"
      end
    end

    attr_reader :data
    def initialize(data_to_verify)
      @data = if data_to_verify.respond_to?(:each_pair)
        data_to_verify
      else
        self.class.parse_from_url(data_to_verify)
      end
    end

    def self.parse_from_url(url)
      Rack::Utils.parse_query(URI.parse(url).query)
    end

    def request_verification_url
      put "You already have a signature ... do you really need to request verification?" if has_signature?
      "#{base_url}/request?#{query_string}"
    end

    def verified_url
      raise "No signature! (you probably want to request_verification_url)" unless has_signature?
      "#{base_url}/verified?#{query_string}"
    end

    private

    def has_signature?
      data["signature"]
    end

    def query_string
      data.collect { |k,v| "#{CGI.escape(k)}=#{CGI.escape(v)}"}.join("&")
    end

    def base_url
      self.class.base_url
    end
  end
end