require './config/environment'

class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "fwitter_secret"
  end
  get '/' do
    erb :"application/index"
  end

  get '/signup' do
    erb :"application/signup"
  end

  post '/signup' do 
    binding.pry
    if params[:username] != ""
      user = User.new(:username => params[:username], :password => params[:password])
    else
      redirect "/failure"
    end
    if user.save
      redirect "/tweets"
    else
      redirect "/failure"
    end
  end

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

end