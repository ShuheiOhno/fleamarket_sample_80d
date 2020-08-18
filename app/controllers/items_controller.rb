class ItemsController < ApplicationController
  def index
    @items = Item.includes(:images).order('created_at DESC')
  end
  
  def new
    @item = Item.new
    @item.images.new
    @brands = []
    Brand.all.each do |brand|
      @brands << [brand.name, brand.id]
    end
    
    @category_parent_array = []
    Category.where(ancestry: nil).each do |parent|
      @category_parent_array << [parent.name, parent.id]
    end
    
  end
  
  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      render :new
    end
  end
  
  def show
  end

  
  def get_category_children
    @category_children = Category.find(params[:parent_id]).children
  end
  
  def get_category_grandchildren
     @category_grandchildren = Category.find(params[:child_id]).children
  end
  


  def destroy
    @items = Item.find(params[:id])
    if @items.seller_id == current_user.id && @items.destroy
      redirect_to root_path
    # else redirect先は詳細画面
    end
  end

  # 商品情報編集の為追記

  def edit
    @item = Item.find(params[:id])

    @brands = []
    Brand.all.each do |brand|
    @brands << [brand.name, brand.id]

    @category_parent_array = []
    Category.where(ancestry: nil).each do |parent|
    @category_parent_array << [parent.name, parent.id]
    
    # child = grandchild.parent
    # if @category_id == 46 or @category_id == 74 or @category_id == 134 or @category_id == 142 or @category_id == 147 or @category_id == 150 or @category_id == 158
    # else
    #  @category_parent_array = []
    #  @category_parent_array << @item.category.name
    #  @category_parent_array << @item.category.id
    # end
    #  @category_children_array = Category.where
    # # (ancestry: child.ancestry)
    # #  @child_array = []
    # #  @child_array << child.name
    # #  @child_array << child.id

    #  @category_grandchildren_array = Category.where
    # #  (ancestry: grandchild.ancestry)
    # #  @grandchild_array = []
    # #  @grandchild_array << grandchild.name
    # #  @grandchild_array << grandchild.id
    end
    end
  end


  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      redirect_to items_path
    else
      render :edit
    end
    
  end

  # def update_done
  #   @item_update = Item.order("updated_at DESC").first
  # end




  private
  def item_params
    params.require(:item).permit(
      :name, :explanation, :price, 
      :category_id, :status_id, 
      :delivery_fee_id, :prefecture_id,
      :days_until_shipping_id, :brand_id,
      images_attributes: [:src, :_destroy, :id]
    ).merge(seller_id: current_user.id, buyer_id: nil)
  end

  # def ensure_current_user
  #   item = Item.find(params[:id])
  #   if item.seller_id != current_user.id
  #     redirect_to action: :index
  #   end
  # end

  def set_item
    @item = Item.find(params[:id])
  end

end
