require "pry"
require "sinatra"
require "sinatra/activerecord"
require_relative './models/User'
require_relative './models/Post'

# set :database, {adapter: 'postgresql', database: 'rumblr'}
enable :sessions

get '/' do
    @posts = Post.all
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

get '/blogs' do
    @user = User.find(session[:id])
    @posts = Post.where(user_id: session[:id])
    erb :blogs
end

#finds user's current blog, redirects to editBlog page
get '/posts/:post_id/edit' do
    @user = User.find(session[:id])      #finding user current logged in
    @post = Post.find(params[:post_id])  #finding post currently being edited
    erb :editBlog
end

#edits user's blog, redirects back to user's blog page
put '/posts/:post_id/edit' do
    @user = User.find(session[:id]) 
    @editpost = Post.update(params[:post_id], title: params[:title], content: params[:content])
    redirect '/blogs'
end

#deletes user's blog post
delete '/posts/:post_id' do
    @user = User.find(session[:id])
    Post.destroy(params[:post_id])
    redirect '/blogs'
end

#deletes user's account
delete '/user/:user_id/delete' do
    @posts = Post.where(user_id: session[:id]).destroy_all
    @user = User.where(user_id: session[:id]).destroy_all
    session.clear
    redirect '/index'
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