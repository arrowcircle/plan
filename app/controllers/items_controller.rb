class ItemsController < ApplicationController
  autocomplete :item, :name
  def index
    @items = scope.search(params[:search])
  end

  def new
    @item = Item.new
    render 'edit'
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to [:items], notice: 'Номенклатура добавлена'
    else
      render 'edit'
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      redirect_to [:items], notice: 'Номенклатура обновлена'
    else
      render 'edit'
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def destroy
    @item = Item.find(params[:id])
  end

  private

  def scope
    return Item.complex if params[:tab] == 'complex'
    return Item.basic if params[:tab] == 'basic'
    Item
  end

  def item_params
    params.require(:item).permit!
  end
end
