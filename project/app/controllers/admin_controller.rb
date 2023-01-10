class AdminController < ApplicationController
  

  def login
    if request.post?
      user = User.authenticate(params[:name], params[:password])
      if user
        session[:user_id] = user.id
        uri = session[:origin_uri]
        session[:origin_uri] = nil
        redirect_to(uri || {:action => "index"})
      else
        flash.now[:notice] = "Invalid user/password combination"
      end
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "登出"
    redirect_to(:action => "login")
  end

  def index
  end
end
