# Helper methods defined here can be accessed in any controller or view in the application

Authsig::App.helpers do
  def verified_url(verification)
    verify_path = url(:verify, :verify, verification.sign.to_signed_hash)
    uri verify_path
  end

  def error_partials(model)
    model_instance_name = model.class.to_s.downcase
    model.errors.each do |error_array|
      error_array.each do |error|
        error_template_name = error.downcase.gsub(/\s+/,"_").gsub(/[^\w_]/,'')
        yield ["#{model_instance_name}/#{error_template_name}", {locals: {model_instance_name => model}}]
      end
    end
  end
end
