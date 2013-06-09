Authsig::App.controllers :defaults do

  post :create, map: "", csrf_protection: false do
    content_type :json
    default = Default.new_from_params(params)
    if default.save
      status 201
      "ok".to_json
    else
      status 400
      "Bad request! #{default.errors.inspect}".to_json
    end
  end

  # This could be used to guess secrets.
  # Should be throttled somehow.
  # put :compromised, map: ":slug", csrf_protection: false do
  #   content_type :json
  #   default = Default.get(params[:slug])
  #   unless default
  #     status 404
  #     "Default ##{params[:slug]} not found.".to_json
  #   else
  #     if default.match?(params)
  #       "Compromise noted!".to_json
  #     else
  #       status 400
  #       "Params provided did not match compromised".to_json
  #     end
  #   end
  # end

end
