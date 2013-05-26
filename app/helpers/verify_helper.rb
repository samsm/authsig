# Helper methods defined here can be accessed in any controller or view in the application

Authsig::App.helpers do

  def verification_request_url(params, use_current_user = false)
    request_params = params.dup
    request_params.merge!("login" => current_user.login, "service" => current_user.service) if use_current_user
    url_for(:verify, :request, request_params)
  end

  def test_notify_url
    uri(Authsig::TestNotifier.url(:test, :verification))
  end

  def url_for(*args)
    uri(url(*args))
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
