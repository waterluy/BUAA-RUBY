class ApplicationController < ActionController::Base
    # before_action :authorize, :except => :login

    helper_method :current_user, :current_cart

    def current_user
        @current_user ||= User.find(session[:current_userid]) if session[:current_userid]
    end

    def current_cart
        @current_cart ||= (current_user ? current_user.cart : nil)
    end

    def must_login
        if !current_user
            redirect_to login_users_url, notice: "请先登录" unless (current_user)
        end
    end

    def must_admin
        if !(current_user && current_user.admin?)
            redirect_to login_users_url, notice: "管理员登录" unless (current_user && current_user.admin?)
        end
    end

    def must_buyer
        if !(current_user && !current_user.admin?)
            redirect_to login_users_url, notice: "买家登录" unless (current_user && current_user.admin?)
        end
    end

    protected
        def authorize
            unless User.find_by_id(session[:user_id])
                session[:origin_uri] = request.request_id
                flash[:notice] = "请管理员登陆"
                redirect_to :controller => 'admin', :action => 'login'                
            end
        end

end
