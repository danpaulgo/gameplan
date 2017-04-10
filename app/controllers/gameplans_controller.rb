class UsersController < ApplicationController

  # CREATE

  # validate logged in
  get "/gameplans/new" do

  end

  post "/gameplans" do

  end

  
  # READ

   # validate logged in
  get "/gameplans" do 

  end

  # validate logged in
  get "/gameplans/:id" do

  end

  # validate logged in
  get "/gameplans/search" do
    @search_term = params[:search]
    @category_id = params[:cat]
  end

  # UPDATE

  # validate correct user
  get "/gameplans/:id/edit" do

  end

  patch "/gameplans/:id" do

  end

  # DELETE

  delete "/gameplans/:id/delete" do

  end

end