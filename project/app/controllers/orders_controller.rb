class OrdersController < ApplicationController
  before_action :set_order, only: %i[ show edit update destroy ]
  before_action :must_login

  def change_status
    @order = Order.find(params[:id])
    @order.status = "已发货"
    @order.save
    #Order.find[params[:id]].status = "已发货"
    redirect_to orders_url, notice: '成功发货'
  end

  # GET /orders or /orders.json
  def index
    if current_user && current_user.admin?
      @orders = Order.all
    elsif current_user
      @orders = Order.all.select{|o| o.user_id == current_user.id}
    else
      @orders = []
    end
  end

  # GET /orders/1 or /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
    @@cart_item = CartItem.find(params[:item_id])
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
    #@cart_item = CartItem.find(params[:item_id])
    @order = Order.new(order_params)
    @order.item_id = @@cart_item.id
    @order.status = "待发货"
    @order.user = current_user
    @order.total = CartItem.find(@order.item_id).total_price
    @order.quantity = CartItem.find(@order.item_id).quantity

    respond_to do |format|
      if @order.save
        format.html { redirect_to order_url(@order), notice: "Order was successfully created." }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to order_url(@order), notice: "Order was successfully updated." }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    #@order.destroy
    if @order.status == "待发货"
      @order.status = "已取消"
      notice = "成功取消订单"
    elsif @order.status == "已发货"
      @order.status = "已收货"
      product = Product.find(CartItem.find(@order.item_id).product_id)
      if !product.sales
        product.sales = 0
      end
      product.sales = product.sales + @order.quantity
      product.save
      notice = "收货完成."
    end
    @order.save

    respond_to do |format|
      format.html { redirect_to orders_url, notice: notice }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:address, :phone,
         :post, :status, :item_id, :user_id, :total,
          :quantity)
    end
end
