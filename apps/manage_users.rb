require_relative './admin'

module Scriptum
  class ManageUsersApp < AdminApp

    set :views, ["views/manage_users", "views/admin"]

    get "/" do
      @users = User.all
      @page_title = "Users"
      erb :index
    end

    get "/new" do
      @user = User.new(params[:user])
      @page_title = "New User"
      erb :new
    end

    post "/" do
      @user = User.new(params[:user])
      if @user.save
        flash[:success] = "User added"
        redirect to('/')
      else
        erb :new
      end
    end

    get "/:id/edit" do
      @user = User.find!(params[:id])
      @page_title = "Editing User: #{@user.username}"
      erb :edit
    end

    put "/:id" do
      @user = User.find!(params[:id])
      if @user.update_attributes(params[:user])
        flash[:success] = "User updated"
        redirect to("/")
      else
        erb :edit
      end
    end

    get "/:id/delete" do
      @user = User.find!(params[:id])
      @page_title = "Deleting User: #{@user.username}"
      erb :delete
    end

    delete "/:id" do
      @user = User.find!(params[:id])
      if params[:delete_user_action] == "reassign"
        reassign_user = User.find(params[:reassign_user])
        if reassign_user.nil?
          flash[:error] = "Could not find user to transfer posts to"
          erb :delete
        else
          Authorship.change(@user, reassign_user)
        end
      end
      if @user.destroy
        flash[:success] = "User deleted"
        redirect to("/")
      else
        erb :delete
      end
    end
  end
end
