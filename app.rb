require "sinatra"
require "sinatra/activerecord"
require_relative './models/User'
require_relative './models/Post'

set :database, {adapter: 'postgresql', database: 'rumblr'}
enable :sessions

get '/index' do
    erb :index
end

get '/signup' do
    erb :sign_up
end

get '/login' do
    erb :log_in
end

get '/profile' do
    @user = User.find(session[:id])
    erb :profile
end

get '/logout' do
    session.clear
    redirect '/login'
end