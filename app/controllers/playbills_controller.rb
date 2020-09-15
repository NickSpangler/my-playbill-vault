class PlaybillsController < ApplicationController

    get "/playbills" do
        @user = User.find_by(id: session[:user_id])
        if logged_in?
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

    get "/playbills/:id" do
        if logged_in?
            @playbill = current_user.playbills.find_by(id: params[:id])
            erb :"playbills/show"
        else
            redirect to "/login"
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