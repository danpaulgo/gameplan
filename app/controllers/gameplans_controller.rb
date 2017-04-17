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

  post "/gameplans" do
    session[:flash] = []
    @gameplan = Gameplan.new
    @gameplan.user = UserHelper.current_user(session)
    @gameplan.title = params[:gameplan][:title]
    cat_or_error = GameplanHelper.set_category_or_error(params[:gameplan][:category_id], params[:category][:name].capitalize)
    if cat_or_error.is_a?(Category)
      @gameplan.category = cat_or_error
    else
      session[:flash] += cat_or_error
      redirect "/gameplans/new"
    end
    GameplanHelper.add_steps(@gameplan, params[:steps], session)
    if !session[:flash].empty?
      Step.all.each{|s| s.delete if s.gameplan == @gameplan }
      redirect "/gameplans/new"
    end
    if @gameplan.steps.empty?
      session[:flash] += ["Gameplan must have at least one step"]
      redirect "/gameplans/new"
    end
    if @gameplan.save
      session[:flash] = nil
      redirect "/gameplans/#{@gameplan.id}"
    else
      session[:flash] += @gameplan.errors.full_messages
      Step.all.each{|s| s.delete if s.gameplan == @gameplan }
      redirect "/gameplans/new"
    end
  end

  post "/gameplans/stars" do

    session[:flash] = "Gameplan starred"

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
        # binding.pry
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
      @flash_message = session[:flash]
      session[:flash] = nil
      @current_user = UserHelper.current_user(session)
      @gameplan = Gameplan.find(params[:id])
      # binding.pry
      erb :'/gameplans/show'
    else
      redirect "/login"
    end
  end



  # UPDATE

  # validate correct user
  get "/gameplans/:id/edit" do

  end

  patch "/gameplans/:id" do

  end

  # DELETE

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