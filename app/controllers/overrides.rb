Authsig::App.controllers :overrides do

  post :create, map: "", csrf_protection: false do
    content_type :json
    override = Override.new_from_params(params)
    if override.save
      status 201
      "ok".to_json
    else
      status 400
      "Bad request! #{override.errors.inspect}".to_json
    end
  end

  # This could be used to guess secrets.
  # Should be throttled somehow.
  # put :compromised, map: ":slug", csrf_protection: false do
  #   content_type :json
  #   override = Override.get(params[:slug])
  #   unless override
  #     status 404
  #     "Override ##{params[:slug]} not found.".to_json
  #   else
  #     if override.match?(params)
  #       "Compromise noted!".to_json
  #     else
  #       status 400
  #       "Params provided did not match compromised".to_json
  #     end
  #   end
  # end

end
