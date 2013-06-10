class VerificationPresenter
  attr_reader :verification, :context
  attr_accessor :view
  def initialize(verification, context)
    @verification, @context = verification, context
    @verification.valid?(context)
  end

  def status_code
    return 200 unless errors?
    403
  end

  def redirect?
    redirect_url
  end

  def redirect_url
    verification.defaulted_populated_params["redirect_url"]
  end

  def notify_url
    verification.defaulted_populated_params["notify_url"]
  end

  def signed_data
    verification.signed_populated_params
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
    !errors? && verification.show?
  end

  def user_match?
    !verification.errors.on(:user) && !verification.errors.on(:login)
  end

  def verified_url
    verification.url(view)
  end

  private
  def verified_fields
    verification.class.validators.contexts.detect {|c| c == context }.last.
      collect(&:field_name).uniq
  end
end
