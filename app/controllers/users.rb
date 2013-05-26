Authsig::App.controllers :users do

  post :create, map: "" do
    user = User.new(login: params[:login], password: params[:password], service: "password")
    if user.save
      warden.set_user(user)
      redirect_to "/"
    else
      render "users/new"
    end
  end

  get :new, map: "" do
    render "users/new"
  end

end
