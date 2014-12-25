class CategoriesController < ApplicationController
  def sort
    Category.sort(params[:list])
    render nothing: true
  end

  def index
    @categories = Category.for_account(account.id).roots.order(:position)
  end

  def new
    @category = scope.build
    respond_to do |format|
      format.html { render 'edit' }
      format.js { render 'new', layout: false }
    end
  end

  def create
    @category = scope.build(category_params)
    if @category.save
      redirect_to [:categories], notice: 'Категория добавлена'
    else
      render 'edit'
    end
  end

  def edit
    @category = scope.find(params[:id])
  end

  def update
    @category = scope.find(params[:id])
    if @category.update(category_params)
      redirect_to [:categories], notice: 'Категория обновлена'
    else
      render 'edit'
    end
  end

  def destory
    @category = scope.find(params[:id])
    if @category.destroy
      redirect_to [:categories], notice: 'Категория удалена'
    else
      redirect_to [:categories], notice: "Ошибка удаления: #{@category.errors.full_messages.join(', ')}"
    end
  end

  private

  def scope
    account.categories
  end

  def category_params
    params[:category].merge!(account_id: account.id)
    params[:category].permit!
  end
end
