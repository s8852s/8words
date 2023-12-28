class UsersController < ApplicationController
  def index
    @users = User.order(:id)
  end

  def new
    @user = User.new
  end

  def create
    params[:user][:xunkong ] = params[:user][:xunkong].to_s
    params[:user][:gender] = params[:user][:gender].to_i
    @user = User.new(params.require(:user).permit!)
    redirect_to users_path if @user.save
  end

  def show
    @user = User.find(params[:id])
    @year = params[:year] == 'min_guo' ? "liunian_min_guo" : "liunian_xi_yuan"
    @mode = params[:mode].presence || '0'
  end

  def update
    @user = User.find(params[:id])
    if @user.update(params.require(:user).permit!)
      redirect_to user_path(@user), notice: '成功'
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      redirect_to users_path, notice: '刪除成功'
    end
  end

  private

  def user_params
    params
  end

  def bazi
    @bazi_hash = {}
    bazi_array = params[:user][:bazi].split(',')
    @bazi_hash[:year] = bazi_array[0]
    @bazi_hash[:month] = bazi_array[1]
    @bazi_hash[:day] = bazi_array[2]
    @bazi_hash[:time] = bazi_array[3]
    @bazi_hash
  end

  def wuxing
    @wuxing_hash = {}
    
  end
end
