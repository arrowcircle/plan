class PlansController < ApplicationController
  def index
    @plans = scope.search(params[:search]).page(params[:page]).per(20)
  end

  def new
    @plan = account.plans.build
    render 'edit'
  end

  def create
    @plan = account.plans.build(plans_params)
    if @plan.save
      redirect_to [:plans], notice: 'План добавлен'
    else
      render 'edit'
    end
  end

  def edit
    @plan = scope.find(params[:id])
  end

  def update
    @plan = scope.find(params[:id])
    if @plan.update(plans_params)
      redirect_to [:plans], notice: 'План обновлен'
    else
      render 'edit'
    end
  end

  def show
    @plan = scope.find(params[:id])
  end

  def destroy
    @plan = scope.find(params[:id])
    @plan.destroy!
    redirect_to :back, notice: "План удален"
  end

  private

  def scope
    Plan.for_account(account.id)
  end

  def plans_params
    res = params[:plan]
    res[:planezations_attributes].each { |k, v| v.merge!(account_id: account.id) } if res[:planezations_attributes]
    res.permit!
  end
end
