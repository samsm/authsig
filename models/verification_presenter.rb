class VerificationPresenter
  attr_reader :verification, :context
  attr_accessor :view
  def initialize(verification, context)
    @verification, @context = verification, context
    @verification.valid?(context)
  end

  def errors?
    verification.errors.any?
  end

  def message_partials
    verification.errors.each do |error_array|
      error_array.each do |error|
        error_template_name = error.downcase.gsub(/\s+/,"_").gsub(/[^\w_]/,'')
        yield ["verification/#{error_template_name}", {locals: {verification: verification}}]
      end
    end
  end

  def show_signed_url_to_current_user?
    verification.user_match? && verification.show?
  end

  def verified_url
    verify_path = view.url(:verify, :verified, verification.sign.to_signed_hash)
    view.uri verify_path
  end

  private
  def verified_fields
    verification.class.validators.contexts.detect {|c| c == context }.last.
      collect(&:field_name).uniq
  end
end
