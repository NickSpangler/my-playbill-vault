class UsersController < ApplicationController

    post "/signup" do
          @user = User.new(params)
          if @user.save
            session[:user_id] = @user.id
            redirect to "/playbills"
          else
            @errors = @user.errors.full_messages.to_s
            erb :index
          end
      end

      post '/login' do
        @user = User.find_by(username: params[:username])
        if @user && @user.authenticate(params[:password])
            session[:user_id] = @user.id
            redirect to '/playbills'
        else
            redirect to "/"
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
            redirect to "/"
        end
      end

      post '/send_request' do
        if logged_in?
            requested_friend = User.find_by(username: params[:username])
            requested_friend.requests.create(requester_id: current_user.id)
            redirect to "/friends"
        else
            redirect to "/"
        end
      end

      post '/answer_request' do
        if logged_in?
            if params[:response] == "accept"
                current_user.friends.create(friend_id: params[:requester_id])
                Friend.create(user_id: params[:requester_id], friend_id: current_user.id)
                Request.find_by(user_id: current_user.id, requester_id: params[:requester_id]).delete
            else
                Request.find_by(user_id: current_user.id, requester_id: params[:requester_id]).delete
            end
            redirect to "/friends"
        else
            redirect to "/"
        end
      end

      post '/friends_collection' do
        if logged_in?
          @friend = User.find_by(id: params[:id])
          erb :"users/friends_collection"
        else
          redirect to "/"
        end
      end

      post '/friends_playbill' do
        if logged_in?
          @playbill = Playbill.find_by(id: params[:id])
          @friend = @playbill.user
          erb :"users/friends_playbill"
        else
          redirect to "/"
        end
      end

      get '/settings' do
        if logged_in?
          erb :"users/settings"
        else
          redirect to "/"
        end
      end

      patch '/settings' do
        binding.pry
        if logged_in?
          current_user.update(params[:update])
          redirect to "/playbills"
        else
          redirect to "/"
        end
      end

      delete '/settings' do
        # binding.pry
        if logged_in?
          delete_account(current_user)
          redirect to "/"
        else
          redirect to "/"
        end
      end

end