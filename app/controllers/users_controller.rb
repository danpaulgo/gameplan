class UsersController < ApplicationController

  # CREATE

  get "/signup" do

  end

  post "/signup" do

  end

  
  # READ

   # validate logged in
  get "/users" do 

  end

  # validate logged in
  get "/users/:slug" do

  end

  # validate logged in
  get "/users/search" do
    @search_term = params[:s]
  end

  # UPDATE

  # validate correct user
  get "/users/:slug/edit" do

  end

  patch "/users/:slug" do

  end

  # DELETE

  delete "/users/:slug/delete" do

  end

end