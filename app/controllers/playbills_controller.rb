class PlaybillsController < ApplicationController

    get "/playbills" do
        @user = User.find_by(id: session[:user_id])
        if logged_in?
            case current_user.order
            when "date_new_to_old"
                @playbills = current_user.playbills_new_to_old
            when "date_old_to_new"
                @playbills = current_user.playbills_old_to_new
            when "rating_high_to_low"
                @playbills = current_user.playbills_rating_high_to_low
            when "rating_low_to_high"
                @playbills = current_user.playbills_rating_low_to_high
            when "alphabetically"
                @playbills = current_user.playbills_alphabetically
            end
            erb :"playbills/index"
        else
            redirect to '/login'
        end
    end

    post "/playbills" do
            @playbill = current_user.playbills.create(params)
            redirect to "/playbills/#{@playbill.id}"
    end

    get "/playbills/new" do
        if logged_in?
            erb :"playbills/new"
        else
            redirect to "/login"
        end
    end

    post "/playbills/new" do
        if logged_in?
            @params = params
            erb :"playbills/create"
        else
            redirect to "/login"
        end
    end

    post '/playbills/search' do
        @search_results = "https://playbill.com/searchpage/search?q=" + @params["search"].split.join("+") + "&sort=Relevance&shows=on&qasset="
        @params = params
        if logged_in?
            erb :"playbills/search_results"
        end
      end

    get '/favorites' do
       if logged_in?
        erb :"/playbills/favorites"
       end
    end

    get "/playbills/:id" do
        if logged_in?
            @playbill = current_user.playbills.find_by(id: params[:id])
            erb :"playbills/show"
        else
            redirect to "/login"
        end
    end

    get '/playbills/:id/edit' do
        if logged_in? 
            @playbill = current_user.playbills.find_by(id: params[:id])
            erb :"playbills/edit"
        else
            redirect to "/login"
        end
    end

    patch '/playbills/:id' do
        if logged_in?
            @playbill = current_user.playbills.find_by(id: params[:id])
            @playbill.update(params[:update])
            redirect to "/playbills/#{@playbill.id}"
        else
            redirect to '/login'
        end
    end

    delete "/playbills/:id" do
        @playbill = Playbill.find_by(id: params[:id])
        if @playbill.user.id == current_user.id
            @playbill.delete
            redirect to "/playbills"
        else
            redirect to "/playbills"
        end
    end
    
end