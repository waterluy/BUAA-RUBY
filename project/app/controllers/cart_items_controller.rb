class CartItemsController < ApplicationController
  before_action :set_cart_item, only: %i[ show edit update destroy ]
  before_action :must_login

  # GET /cart_items or /cart_items.json
  def index
    @cart_items = CartItem.all
  end

  # GET /cart_items/1 or /cart_items/1.json
  def show
  end

  # GET /cart_items/new
  def new
    @cart_item = CartItem.new
  end

  # GET /cart_items/1/edit
  def edit
  end

  # POST /cart_items or /cart_items.json
  def create
    #@cart_item = CartItem.new(cart_item_params)
    @cart = current_cart
    product = Product.find(params[:product_id])
    #@cart_item = @cart.cart_items9.build(:product => product) cart_url(@cart)
    @cart_item = @cart.add_item(product.id)

    respond_to do |format|
      if @cart_item.save
        format.html { redirect_to products_url, notice: "添加成功,可在购物车内查看." }
        format.json { render :show, status: :created, location: @cart_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cart_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cart_items/1 or /cart_items/1.json
  def update
    respond_to do |format|
      if @cart_item.update(cart_item_params)
        format.html { redirect_to cart_item_url(@cart_item), notice: "Cart item was successfully updated." }
        format.json { render :show, status: :ok, location: @cart_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cart_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cart_items/1 or /cart_items/1.json
  def destroy
    @cart_item.destroy

    respond_to do |format|
      format.html { redirect_to cart_url(current_cart), notice: "删除成功." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cart_item
      @cart_item = CartItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cart_item_params
      params.require(:cart_item).permit(:quantity)
    end
end
