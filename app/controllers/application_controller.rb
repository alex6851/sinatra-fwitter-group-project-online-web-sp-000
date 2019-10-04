require './config/environment'

class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "fwitter_secret"
  end

  helpers do

    def logged_in?
      !!current_user
    end

    def current_user
      @current_user ||= User.find_by(session[:user_id])
    end

  end

  get '/' do
    if logged_in?
      redirect '/tweets'
    else
      erb :"applications/index"
    end
  end

  get '/signup' do
    if !logged_in?
      erb :"applications/signup"
    else
    redirect to '/tweets'
    end
  end

  post '/signup' do 

    if params[:username] != "" && params[:password] != "" && params[:email] != ""
      @user = User.new(:username => params[:username], :password => params[:password], :email => params[:email])
      @user.save
      session[:user_id] = @user.id
      redirect to '/tweets'
    else
      redirect "/signup"
    end
  end

  get '/login' do
    if !logged_in?
      erb :'users/login'
    else
      redirect '/tweets'
    end
  end

  post "/login" do
    user = User.find_by(:username => params[:username])
  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect '/tweets'
  else
    redirect "/signup"
  end
end

get '/logout' do
  if logged_in?
    session.destroy
    redirect to '/login'
  else
    redirect to '/'
  end
end

post "/logout" do
  session.destroy
  redirect to '/login'
end

get '/tweets' do
 if !logged_in?
  redirect '/login'
 else
  @tweets = Tweet.all
  erb :'tweets/tweets'
 end
end

get '/users/:slug' do
  @user = User.find_by_slug(params[:slug])
  erb :'users/show'
end

get '/tweets/new' do
  if logged_in?
    erb :'tweets/create_tweet'
  else
    redirect to '/login'
  end
end

get '/tweets/:id' do
  if logged_in?
    @tweet = Tweet.find_by_id(params[:id])
    erb :'tweets/show_tweet'
  else
    redirect to '/login'
  end
end

get '/tweets/:id/edit' do
  if logged_in?
    @tweet = Tweet.find_by_id(params[:id])
    if @tweet && @tweet.user == current_user
      erb :'tweets/edit_tweet'
    else
      redirect to '/tweets'
    end
  else
    redirect to '/login'
  end
end

patch '/tweets/:id' do
  if logged_in?
    if params[:content] == ""
      redirect to "/tweets/#{params[:id]}/edit"
    else
      @tweet = Tweet.find_by_id(params[:id])
      if @tweet && @tweet.user == current_user
        if @tweet.update(content: params[:content])
          redirect to "/tweets/#{@tweet.id}"
        else
          redirect to "/tweets/#{@tweet.id}/edit"
        end
      else
        redirect to '/tweets'
      end
    end
  else
    redirect to '/login'
  end
end

delete '/tweets/:id/delete' do
  if logged_in?
    @tweet = Tweet.find_by_id(params[:id])
    if @tweet && @tweet.user == current_user
      @tweet.delete
    end
    redirect to '/tweets'
  else
    redirect to '/login'
  end
end




  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end




end