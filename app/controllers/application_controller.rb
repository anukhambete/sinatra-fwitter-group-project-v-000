require './config/environment'
require 'pry'

class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  enable :sessions
  set :session_secret, "password_security"

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/' do
    erb :index
  end

  get '/signup' do
    #binding.pry
    if logged_in?
      redirect to "/tweets"
    else
      erb :'/users/create_user'
    end
  end

  get '/login' do
    if logged_in?
      redirect to "/tweets"
    else
      erb :'/users/login'
    end
  end

  get '/tweets' do
  #  binding.pry
    if logged_in?
      @tweets = Tweet.all
      @user = User.find(session[:user_id])
        erb :'/tweets/tweets'
    else
      redirect to "/login"
    end
  end

  post '/signup' do
    #binding.pry
		if !params[:username].blank? && !params[:password].blank? && !params[:email].blank?
      user = User.new(username: params[:username], password: params[:password], email: params[:email])
      user.save
      session[:user_id] = user.id
      #binding.pry
      redirect to "/tweets"
      #binding.pry
      #redirect "/failure"
    else
      #session[:user_id] = user.id
      redirect to "/signup"
    end
  end

  post "/login" do
    ##your code here
    user = User.find_by(:username => params[:username])
		if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/tweets"
    else
      redirect "/login"
    end
  end

  get "/logout" do
    if logged_in?
      session.clear
      redirect "/login"
    else
      redirect "/login"
    end
  end

  get '/users/:slug' do
    #binding.pry
    @user = User.find_by_slug(params[:slug])
    @tweets = @user.tweets
    erb :'/users/show'
  end



  
  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
