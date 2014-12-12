class ItemsController < ApplicationController
  autocomplete :item, :articul, display_value: :full_name

  def index
    @items = scope.search(params[:search]).page(params[:page]).per(20)
  end

  def new
    @item = account.items.build
    render 'edit'
  end

  def create
    @item = account.items.build(item_params)
    if @item.save
      redirect_to [:items], notice: 'Изделие добавлено'
    else
      render 'edit'
    end
  end

  def edit
    @item = scope.find(params[:id])
  end

  def update
    @item = scope.find(params[:id])
    if @item.update(item_params)
      redirect_to [:items], notice: 'Изделие обновлено'
    else
      render 'edit'
    end
  end

  def show
    @item = scope.find(params[:id])
    render(partial: @item, locals: {evil_role: 'subtree'}) if request.xhr?
  end

  def destroy
    @item = scope.find(params[:id])
  end

  def autocomplete_item_articul
    @items = Item.for_account(account.id).search(params[:term]).order(:articul).limit(10)
  end

  private

  def scope
    return Item.for_account(account.id).complex(account.id) if params[:tab] == 'complex'
    return Item.for_account(account.id).basic(account.id) if params[:tab] == 'basic'
    return Item.for_account(account.id).final(account.id) if params[:tab] == 'final'
    Item.for_account(account.id)
  end

  def item_params
    res = params[:item]
    res[:parent_itemizations_attributes].each { |k, v| v.merge!(account_id: account.id) } if res[:parent_itemizations_attributes]
    res.permit!
  end
end
