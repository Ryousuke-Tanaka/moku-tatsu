class UsersController < ApplicationController
  before_action :limitaion_login_user, only:[:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy, :following, :followers]
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @goals = Goal.where(user_id: @user.id)
    @goal = Goal.new
    @todoes = Todo.where(doing_id: @user.todoes.ids)
    @notifications = current_user.passive_notifications.paginate(page: params[:page], per_page: 20)
    @notifications.where(checked: false).each do |notification|
      notification.update_attributes(checked: true)
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.image = "default.png" if params[:image].nil?

    if @user.save
      log_in @user # 保存成功後、ログインする
      flash[:success] = "新規作成に成功しました。"
      redirect_to @user
    else
      render :new
    end
  end

  def edit
  end
  
  def update
    @user.image = "default.png" if params[:image].nil?
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "#{ @user.name }のデータを削除しました。"
    redirect_to users_url
  end

  # フォロー
  def following
    @title = "フォロー"
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  # フォロワー
  def followers
    @title = "フォロワー"
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private
    # ストロングパラメーター
    def user_params
      params.require(:user).permit(:name, :nickname, :anonymous, :email, :image, :password, :password_confirmation, :agreement)
    end
end
