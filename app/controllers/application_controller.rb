class ApplicationController < Sinatra::Base

  configure do
    enable :sessions
    set :session_secret, "secret"
    # set :public_folder, 'public'
    set :views, 'app/views'
  end

  get "/" do
    @current_user = UserHelper.current_user(session)
    erb :home
  end

  get "/login" do

  end

  get "/logout" do

  end

end