class ApplicationController < Sinatra::Base

  configure do
    enable :sessions
    set :session_secret, "secret"
    # set :public_folder, 'public'
    set :views, 'app/views'
  end

  get "/" do
    @flash_message = session[:flash]
    session[:flash] = nil
    @current_user = UserHelper.current_user(session)
    erb :home
  end

  get "/login" do
    if UserHelper.logged_in?(session)
      @current_user = UserHelper.current_user(session)
      redirect "/users/#{@current_user.username}"
    else
      erb :'login'
    end
  end

  post "/login" do
    @username = params[:user][:username]
    @user = User.find_by(username: @username)
    if @user
      if @user.authenticate(params[:user][:password])
        session[:id] = @user.id
        session[:password] = params[:user][:password]
        redirect "/users/#{@user.username}"
      else
        @error = "Invalid password"
      end
    else
      @error = "User does not exist"
    end
    erb :'login'
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

end