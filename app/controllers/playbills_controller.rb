class PlaybillsController < ApplicationController

    get "/playbills" do
        if logged_in?
            if current_user.playbills.empty?
                redirect to "/playbills/new"
            else
                @playbills = current_user.send("#{current_user.order}")
                erb :"playbills/index"
            end
        else
            redirect to '/'
        end
    end

    post "/playbills" do
            # tempfile = Down.download("#{params[:image_url]}")
            # image_path = "/Users/nickspangler/Flatiron/code/my-playbill-vault/public/images/downloaded_playbills/#{to_param(params[:image_title])}.jpeg"
            # # image_path = "public/images/downloaded_playbills/#{to_param(params[:image_title])}.jpeg"
            # if !File.exist?("public/images/downloaded_playbills/#{to_param(params[:image_title])}.jpeg")
            #     FileUtils.mv(tempfile.path, "#{image_path}")
            # end

            # client = FilestackClient.new(ENV['API_KEY'])
            # filelink = client.upload(external_url: "#{params[:image_url]}", options: { filename: "#{to_param(params[:image_title])}.jpeg" })
            # binding.pry
            
            # params[:image_url] = "/images/downloaded_playbills/#{to_param(params[:image_title])}.jpeg"
            # params[:image_url] = "https://cdn.filestackcontent.com/#{filelink.handle}"
            params.tap { |param| param.delete(:image_title) }
            @playbill = current_user.playbills.create(params)
            redirect to "/playbills/#{@playbill.id}"
            # redirect to "/playbills"
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
        if logged_in? && @playbill = current_user.playbills.find_by(id: params[:id])
            erb :"playbills/show"
        else
            redirect to "/playbills"
        end
    end

    get '/playbills/:id/edit' do
        if logged_in? && @playbill = current_user.playbills.find_by(id: params[:id])
            erb :"playbills/edit"
        else
            redirect to "/playbills"
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