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
    erb :signup
end

get '/login' do
    erb :login
end

get '/profile' do
    @user = User.find(session[:id])
    erb :profile
end

get '/logout' do
    session.clear
    redirect '/login'
end

post '/user/login' do 
    @user = User.find_by(email: params[:email], password: params[:password])
    if @user != nil
        session[:id] = @user.id
        erb :profile
    else   
        #Could not find this user. Redirecting them to the signup page
        redirect '/signup'
    end 
end

action="/user/login"

post '/user/post' do 
    @post = Post.find_by(title: params[:title], content: params[:content])
    if @post != nil
        session[:id] = @post.id
        erb :profile
    else   
        #Could not find this user. Redirecting them to the signup page
        redirect '/profile'
    end 
end

action="/user/post"

private 
#Potentially useful function instead of checking if the user exists
def user_exists?
    (session[:id] != nil) ? true : false
end

def current_user
    User.find(session[:id])
end