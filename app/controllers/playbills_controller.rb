class PlaybillsController < ApplicationController

    get "/playbills" do
        if logged_in?
            if current_user.playbills.empty?
                redirect to "/playbills/new"
            else
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
            end
        else
            redirect to '/'
        end
    end

    post "/playbills" do
            tempfile = Down.download("#{params[:image_url]}")
            image_path = "/Users/nickspangler/Flatiron/code/my-playbill-vault/public/images/downloaded_playbills/#{to_param(params[:image_title])}.jpeg"
            if !File.exist?("/images/downloaded_playbills/#{to_param(params[:image_title])}.jpeg")
                FileUtils.mv(tempfile.path, "#{image_path}")
            end
            params[:image_url] = "/images/downloaded_playbills/#{to_param(params[:image_title])}.jpeg"
            params.tap { |param| param.delete(:image_title) }
            @playbill = current_user.playbills.create(params)
            redirect to "/playbills/#{@playbill.id}"
    end

    get "/playbills/new" do
        if logged_in?
            erb :"playbills/new"
        else
            redirect to "/"
        end
    end

    post "/playbills/new" do
        if logged_in?
            @params = params
            erb :"playbills/create"
        else
            redirect to "/"
        end
    end

    post '/playbills/search' do
        @search_results = "https://playbill.com/searchpage/search?q=" + @params["search"].split.join("+") + "&sort=Relevance&shows=on&qasset="
        @params = params
        if logged_in?
            erb :"playbills/search_results"
        else
            redirect to "/"
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
            redirect to "/"
        end
    end

    get '/playbills/:id/edit' do
        if logged_in? 
            @playbill = current_user.playbills.find_by(id: params[:id])
            erb :"playbills/edit"
        else
            redirect to "/"
        end
    end

    patch '/playbills/:id' do
        if logged_in?
            @playbill = current_user.playbills.find_by(id: params[:id])
            @playbill.update(params[:update])
            redirect to "/playbills/#{@playbill.id}"
        else
            redirect to '/'
        end
    end

    delete "/playbills/:id" do
        if logged_in?
            @playbill = Playbill.find_by(id: params[:id])
            if @playbill.user.id == current_user.id
                @playbill.delete
                redirect to "/playbills"
            else
                redirect to "/playbills"
            end
        else
            redirect to '/'
        end
    end
    
end