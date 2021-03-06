class GameplansController < ApplicationController

  # CREATE

  # validate logged in
  get "/gameplans/new" do
    @flash_messages = session[:flash]
    session[:flash] = nil
    if UserHelper.logged_in?(session)
      @current_user = UserHelper.current_user(session)
      erb :'/gameplans/new'
    else  
      redirect "/login"
    end
  end

  post "/gameplans/new" do
    session[:flash] = []
    @gameplan = Gameplan.new
    @gameplan.user = UserHelper.current_user(session)
    @gameplan_title = params[:gameplan][:title]
    @gameplan.title = @gameplan_title.split(" ").map{|t| t.capitalize}.join(" ")
    @category_name = params[:category][:name]
    cat_or_error = GameplanHelper.set_category_or_error(params[:gameplan][:category_id], @category_name.split(" ").map{|t| t.capitalize}.join(" "))
    if cat_or_error.is_a?(Category)
      @gameplan.category = cat_or_error
    else
      session[:flash] += cat_or_error
    end
    if GameplanHelper.all_steps_valid?(params[:steps])
      GameplanHelper.add_steps(@gameplan, params[:steps])
    else
      session[:flash] += ["Please enter valid name and time length for each step"]
    end
    if @gameplan.steps.empty? && !session[:flash].include?("Please enter valid name and time length for each step")
      session[:flash] += ["Gameplan must have at least one step"]
    end
    if session[:flash].empty?
      if @gameplan.save
        session[:flash] = nil
        redirect "/gameplans/#{@gameplan.id}"
      end
    else
      session[:flash] += @gameplan.errors.full_messages
      @steps = params[:steps]
      Step.all.each{|s| s.delete if s.gameplan == @gameplan }
      @flash_messages = session[:flash]
      session[:flash] = nil
      erb :'/gameplans/new'
    end
  end

  post "/gameplans/stars" do
    Star.create(user_id: params[:user][:id], gameplan_id: params[:gameplan][:id])
    session[:flash] = "Gameplan starred"
    redirect "/gameplans/#{params[:gameplan][:id]}"
  end

  
  # READ

   # validate logged in
  get "/gameplans" do 
    if UserHelper.logged_in?(session)
      @gameplans = Gameplan.all
      erb :'/gameplans/index'
    else
      redirect "/login"
    end
  end

    # validate logged in
  get "/gameplans/search" do
    if UserHelper.logged_in?(session)
      if params[:s]
        @search_term = params[:s]
        @category_id = params[:c].to_i
        @gameplans_from_search = Gameplan.all.select do |gp|
          gp.title.downcase.include?(@search_term.downcase)
        end
        if @category_id > 0
          @gameplans_from_cat = Gameplan.all.select do |gp|
            gp.category_id == @category_id
          end
          @gameplans = @gameplans_from_search & @gameplans_from_cat
        else
          @gameplans = @gameplans_from_search
        end
        erb :'/gameplans/index'
      else
        redirect "/gameplans"
      end
    else
      redirect "/login"
    end
  end

  # validate logged in
  get "/gameplans/:id" do
    if UserHelper.logged_in?(session)
      if @gameplan = Gameplan.all.detect{|gp| gp.id == params[:id].to_i}
        @flash_message = session[:flash]
        session[:flash] = nil
        @current_user = UserHelper.current_user(session)
        @starred = !!Star.find_by(user_id: @current_user.id, gameplan_id: @gameplan.id)
        erb :'/gameplans/show'
      else
        redirect "/gameplans"
      end
    else
      redirect "/login"
    end
  end



  # UPDATE

  # validate correct user
  get "/gameplans/:id/edit" do
    if UserHelper.logged_in?(session)
      @current_user = UserHelper.current_user(session)
      if @gameplan = Gameplan.all.detect{|gp| gp.id == params[:id].to_i}
        if @gameplan.user == @current_user
          @steps = @gameplan.steps
          erb :'/gameplans/edit'
        else
          redirect "/gameplans"
        end
      else
        redirect "/gameplans"
      end
    else
      redirect "/login"
    end
  end

  patch "/gameplans/:id/edit" do
    session[:flash] = []
    @gameplan = Gameplan.find(params[:id])
    @gameplan.title = params[:gameplan][:title].split(" ").map{|t| t.capitalize}.join(" ")
    @new_category = params[:category][:name]
    @new_steps = params[:steps]
    cat_or_error = GameplanHelper.set_category_or_error(params[:gameplan][:category_id], @new_category.capitalize)
    if cat_or_error.is_a?(Category)
      @gameplan.category = cat_or_error
      if @gameplan.category.id
        @new_category = nil
      end
    else
      session[:flash] += cat_or_error
    end
    if @new_steps.empty?
      session[:flash] += ["Gameplan must have at least one step"]
    end
    if !GameplanHelper.all_steps_valid?(@new_steps)
      session[:flash] += ["Please enter valid name and time length for each step"]
    end
    if session[:flash].empty? && @gameplan.save
      GameplanHelper.delete_empty_categories
      @gameplan.steps.each{|step| step.delete}
      GameplanHelper.add_steps(@gameplan, @new_steps)
      session[:flash] = "Gameplan successfully updated"
      redirect "/gameplans/#{@gameplan.id}"
    else
      session[:flash] += @gameplan.errors.full_messages
      @steps = params[:steps]
      @flash_messages = session[:flash]
      session[:flash] = nil
      erb :'/gameplans/edit'
    end
  end
  
  # DELETE

  delete "/gameplans/stars/delete" do
    Star.find_by(user_id: params[:user][:id], gameplan_id: params[:gameplan][:id]).delete
    session[:flash] = "Star removed from gameplan"
    redirect "/gameplans/#{params[:gameplan][:id]}"
  end

  delete "/gameplans/:id/delete" do
    @current_user = UserHelper.current_user(session)
    @gameplan = Gameplan.find(params[:id])
    @gameplan.steps.each{|step| step.delete}
    if Gameplan.all.select{|gp| @gameplan.category == gp.category}.count == 1
      @gameplan.category.delete
    end
    @gameplan.delete
    session[:flash] = "Gameplan successfully deleted"
    redirect "/users/#{@current_user.username}"
  end

  

end