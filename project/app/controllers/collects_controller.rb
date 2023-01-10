class CollectsController < ApplicationController
  before_action :set_collect, only: %i[ show edit update destroy ]
  before_action :must_buyer

  # GET /collects or /collects.json
  def index
    #@collects = Collect.all
    if current_user && !current_user.admin?
      @collects = Collect.all.select{|c| c.user_id == current_user.id}
    else
      @collects = []
    end
  end

  # GET /collects/1 or /collects/1.json
  def show
  end

  # GET /collects/new
  def new
    @collect = Collect.new
  end

  # GET /collects/1/edit
  def edit
  end

  # POST /collects or /collects.json
  def create
    #@collect = Collect.new(collect_params)
    product = Product.find(params[:product_id])
    #@collect = current_user.add_collect(product.id)
    current_collect = current_user.collects.find_by_product_id(product.id)
    if (current_collect)
      already = true #flash[:notice] = "已经添加过该商品"
    else
      current_collect = current_user.collects.build(:product_id => product.id)
    end
    @collect = current_collect

    respond_to do |format|
      if @collect.save
        format.html { redirect_to products_url, notice: (already ? "已经添加过该商品" : "添加成功,可在收藏夹内查看.") }
        format.json { render :show, status: :created, location: @collect }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @collect.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /collects/1 or /collects/1.json
  def update
    respond_to do |format|
      if @collect.update(collect_params)
        format.html { redirect_to collect_url(@collect), notice: "Collect was successfully updated." }
        format.json { render :show, status: :ok, location: @collect }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @collect.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /collects/1 or /collects/1.json
  def destroy
    @collect.destroy

    respond_to do |format|
      format.html { redirect_to collects_url, notice: "Collect was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_collect
      @collect = Collect.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def collect_params
      params.fetch(:collect, {})
    end
end
