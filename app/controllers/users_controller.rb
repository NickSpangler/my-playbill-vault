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
          erb :"users/login"
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
            binding.pry
            requested_friend = User.find_by(username: params[:username])
            Request.create(user_id: requested_friend.id, requester_id: current_user.id)
            redirect to "/friends"
        else
            redirect to "/login"
        end
      end

end