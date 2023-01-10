class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :must_admin, only: %i[ index ]
  before_action :must_login, only: %i[ show edit update destroy ]

  def login
  end

  def do_login
    #if request.post?
      user = User.authenticate(params[:name], params[:password])
      if user
        session[:current_userid] = user.id
        redirect_to products_url, notice: "User login successfully."
        #uri = session[:origin_uri]
        #session[:origin_uri] = nil
        #redirect_to(uri || {:action => "index"})
      else
        redirect_to login_users_url, notice: "账号或密码错误"
        flash[:notice] = "账号或密码错误"
      end
    #end
  end

  def logout
    session[:current_userid] = nil
    current_user = nil
    flash[:notice] = "登出"
    redirect_to products_url, notice: 'User logout'
  end

  # GET /users or /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml {render :xml => @user}
    end
  end

  # GET /users/1 or /users/1.json
  def show
    if !current_user
      redirect_to login_users_url, notice: '请先登录'
    elsif current_user.name != User.find(params[:id]).name
      redirect_to user_url(current_user), notice: '不能查看其他用户信息'
    end
  end

  # GET /users/new
  def new
    @user = User.new

    respond_to do |format|
      format.html # index.html.erb
      format.xml {render :xml => @user}
    end
  end

  # GET /users/1/edit
  def edit
  end


  # POST /users or /users.json
  def create
    # params.require(:user).permit(:password, :password_confirmation, :name)
    @user = User.new(user_params)
    cart = Cart.new
    cart.user = @user
    @user.cart = cart
    @user.phone = "未设置"
    @user.email = "未设置"
    @user.post = "未设置"
    @user.description = "未填写"

    respond_to do |format|
      if @user.save
        format.html { redirect_to login_users_path, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "新的信息已保存." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :hashed_password, 
        :salt, :password, :password_confirmation, :role,
        :cart_id, :phone, :email, :post, :description)
    end
end
