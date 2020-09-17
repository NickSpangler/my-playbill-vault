class UsersController < ApplicationController

    get "/signup" do
        if logged_in?
            redirect to "/playbills"
        else
            erb :"users/signup"
        end
    end

    get '/signup_error' do
        if logged_in?
            redirect to "/playbills"
        else
            erb :"/users/signup_error"
        end
      end

    post "/signup" do
        if !params[:username].empty? && !params[:email].empty? && !params[:password].empty?
          @user = User.new(params)
          @user.save
          session[:user_id] = @user.id
          redirect to "/playbills"
        else
          redirect to "/signup_error"
        end
      end

      get '/login' do
        if !logged_in?
          erb :"users/login_test"
        else
            redirect to '/playbills'
        end
      end

      post '/login' do
        @user = User.find_by(username: params[:username])
        if @user && @user.authenticate(params[:password])
            session[:user_id] = @user.id
            redirect to '/playbills'
        else
            redirect to "/signup"
        end
      end

      get '/logout' do
        logout
        redirect to "/"
      end

      get '/friends' do
        if logged_in?
            erb :"users/friends"
        else
            redirect to "/login"
        end
      end

      post '/send_request' do
        if logged_in?
            requested_friend = User.find_by(username: params[:username])
            Request.create(user_id: requested_friend.id, requester_id: current_user.id)
            redirect to "/friends"
        else
            redirect to "/login"
        end
      end

      post '/answer_request' do
        if logged_in?
            if params[:response] == "accept"
                Friend.create(user_id: current_user.id, friend_id: params[:requester_id])
                Friend.create(user_id: params[:requester_id], friend_id: current_user.id)
                Request.find_by(user_id: current_user.id, requester_id: params[:requester_id]).delete
            else
                Request.find_by(user_id: current_user.id, requester_id: params[:requester_id]).delete
            end
            redirect to "/friends"
        else
            redirect to "/login"
        end
      end

      post '/friends_collection' do
        if logged_in?
          @friend = User.find_by(id: params[:id])
          erb :"users/friends_collection"
        else
          redirect to "/login"
        end
      end

      post '/friends_playbill' do
        if logged_in?
          @playbill = Playbill.find_by(id: params[:id])
          @friend = @playbill.user
          erb :"users/friends_playbill"
        else
          redirect to "/login"
        end
      end

end