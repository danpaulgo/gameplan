class UsersController < ApplicationController

  # CREATE

  get "/signup" do
    # @flash_messages = session[:flash]
    # session[:flash] = []
    if UserHelper.logged_in?(session)
      @current_user = UserHelper.current_user(session)
      redirect "/users/#{@current_user.username}"
    else
      erb :'signup'
    end
  end

  post "/signup" do
    @user = User.new
    @user.first_name = params[:user][:first_name]
    @user.last_name = params[:user][:last_name]
    @birthday = "#{params[:user][:birthday][:year]}-#{params[:user][:birthday][:month]}-#{params[:user][:birthday][:day]}"
    @user.birthday = @birthday
    @user.username = params[:user][:username]
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      session[:id] = @user.id
      session[:password] = params[:user][:password]
      redirect "/"
    else
      @flash_messages = @user.errors.full_messages
      erb :'signup'
    end
  end

  
  # READ

   # validate logged in
  get "/users" do 
    if UserHelper.logged_in?(session)
      @users = User.all
      erb :'/users/index'
    else
      redirect "/login"
    end
  end

  # validate logged in
  get "/users/search" do
    if UserHelper.logged_in?(session)
      @users = []
      @search_term = params[:s]
      @users += User.all.select{|u| u.username.downcase.include?(@search_term.downcase)}
      @users += User.all.select{|u| "#{u.first_name} #{u.last_name}".downcase.include?(@search_term.downcase)}
      @users = @users.uniq
      erb :'/users/index'
    else
      redirect "/login"
    end
  end

  # validate logged in
  get "/users/:username" do
    @flash_message = session[:flash]
    session[:flash] = nil
    if UserHelper.logged_in?(session)
      @user = User.find_by(username: params[:username])
      @current_user = UserHelper.current_user(session)
      erb :'/users/show'
    else
      redirect "/login"
    end
  end

  # UPDATE

  # validate correct user
  get "/users/edit/:foo" do
    if UserHelper.logged_in?(session)
      @current_user = UserHelper.current_user(session)
      case params[:foo]
      when "name"
        erb :'/users/edit/name'
      when "birthday"
        erb :'/users/edit/birthday'
      when "username"
        erb :'/users/edit/username'
      end
    else
      redirect "/login"
    end
  end

  patch "/users/edit" do
    @current_user = UserHelper.current_user(session)
    params[:user][:password] = session[:password]
    if params[:user][:birthday]
      @birthday = "#{params[:user][:birthday][:year]}-#{params[:user][:birthday][:month]}-#{params[:user][:birthday][:day]}"
      params[:user][:birthday] = @birthday
    end
    @current_user.update(params[:user])
    # binding.pry
    session[:flash] = "Profile successfully updated"
    redirect "/users/#{@current_user.username}"
  end

  # DELETE

  delete "/users/delete" do
    UserHelper.current_user(session).delete
    session[:flash] = "Profile successfully deleted"
    session[:id] = nil
    session[:password] = nil
    redirect "/"
  end

end