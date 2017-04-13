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
    @birthday = "#{params[:user][:birthday][:day]}/#{params[:user][:birthday][:month]}/#{params[:user][:birthday][:year]}"
    @user.birthday = @birthday
    @user.username = params[:user][:username]
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      "User Saved"
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
    @users = User.all
  end

  # validate logged in
  get "/users/:username" do
    if UserHelper.logged_in?(session)
      @user = User.find_by(username: params[:username])
      erb :'/users/show'
    else
      redirect "/login"
    end
  end

  # validate logged in
  get "/users/search" do
    if UserHelper.logged_in?(session)
      @search_term = params[:s].downcase
      @users = User.all.detect{|u| u.username.downcase.include?(@search_term)}
      erb :'/users/index'
    else
      redirect "/login"
    end
  end

  # UPDATE

  # validate correct user
  get "/users/:username/edit" do
    if UserHelper.logged_in?(session)
      @user = User.find_by(username: params[:username])
      @current_user = UserHelper.current_user(session)
      if @user == @current_user
        erb :'/users/edit'
      else
        redirect "/users/#{current_user.username}/edit"
      end
    else
      redirect "/login"
    end
  end

  patch "/users/:username" do

  end

  # DELETE

  delete "/users/:username/delete" do
    User.find_by(username: params[:username]).delete
    erb :'/users/delete'
  end

end