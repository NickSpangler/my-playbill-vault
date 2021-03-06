require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, ENV['SESSION_SECRET']
  end

  get "/" do
    erb :index
  end

  helpers do

    def logged_in?
      !!current_user
    end

    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end
    
    def logout
      session.clear
    end

    def to_param(string)
      string.downcase.gsub(" ", "-")
    end

    def delete_account(user)
      user.playbills.destroy_all
      user.friends.destroy_all
      Friend.where(friend_id: user.id).destroy_all
      user.requests.destroy_all
      Request.where(requester_id: user.id).destroy_all
      user.destroy
    end
  end


end
