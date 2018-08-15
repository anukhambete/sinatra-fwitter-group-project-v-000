class TweetsController < ApplicationController

  get '/tweets/new' do
    if logged_in?
      erb :'/tweets/create_tweet'
    else
      redirect "/login"
    end
  end

  get '/tweets/:id' do
    #binding.pry
    if logged_in?
      @user = User.find(session[:user_id])
      @tweet = Tweet.find(params[:id])
      erb :'/tweets/show_tweet'
    else
      redirect to "/login"
    end
  end

  post '/tweets' do
    #binding.pry
    @user = User.find(session[:user_id])
    if !params[:content].blank?
      @tweet = Tweet.create(content: params[:content])
      @user.tweets << @tweet
      @user.save
      @tweet.save
    else
      redirect "/tweets/new"
    end
  end

  get '/tweets/:id/edit' do
    #binding.pry
    if logged_in?
      @tweet = Tweet.find(params[:id])
       if @tweet.user_id == current_user.id
         erb :'/tweets/edit_tweet'
       else
         redirect to "/tweets/#{@tweet.id}"
       end
    else
       redirect to "/login"
    end
  end

  post '/tweets/:id' do
    #binding.pry
    @tweet = Tweet.find(params[:id])
    if !params[:content].blank?
      @tweet = Tweet.find(params[:id])
      @tweet.update(content: params[:content])
      @tweet.save
      redirect to "/tweets/#{@tweet.id}"
    else
      redirect to "/tweets/#{@tweet.id}/edit"
    end
  end

  delete '/tweets/:id/delete' do
    #binding.pry
    if logged_in?
      @tweet = Tweet.find(params[:id])
      if current_user.tweets.include?(@tweet)
        @tweet = Tweet.find(params[:id])
        @tweet.delete
      else
        redirect to "/tweets/#{@tweet.id}"
      end
    else
      redirect to "/login"
    end
  end

end
