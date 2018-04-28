require "sinatra"
require "sinatra/activerecord"
require_relative './models/User'
require_relative './models/Post'

set :database, {adapter: 'postgresql', database: 'rumblr'}
enable :sessions

get '/' do
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

get '/createBlog' do
    @user = User.find(session[:id])
    erb :createBlog
end

get '/logout' do
    session.clear
    redirect '/login'
end

post '/user/login' do 
    @user = User.find_by(email: params[:email], password: params[:password])
    if @user != nil
        session[:id] = @user.id
        redirect '/profile'
    else   
        #Could not find this user. Redirecting them to the signup page
        redirect '/signup'
    end 
end

post '/user/new' do 
    #Creating a new user based on the values from the form
    @newuser = User.create(first_name: params[:first_name], last_name: params[:last_name], birthday: params[:birthday], email: params[:email], password: params[:password])
    #Setting the session with key of ID to be equal to the users id
    #Essentialy this "Logs them in"
    session[:id] = @newuser.id
    redirect '/profile'
end

post '/post/new' do
    #Creating a new post based on the values from the form
    @newpost = Post.create(title: params[:title], content: params[:content], user_id: session[:id])
    redirect '/profile'
end

private 
#Potentially useful function instead of checking if the user exists
def user_exists?
    (session[:id] != nil) ? true : false
end

def current_user
    User.find(session[:id])
end