class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :loggend_in_user, only: [:index, :show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
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
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end

  private
    # ストロングパラメーター
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :agreement)
    end

    # beforeフィルター
    
    # paramsハッシュからユーザーを取得
    def set_user
      @user = User.find(params[:id])
    end

    # ログイン済みのユーザーか確認
    def loggend_in_user
      unless logged_in?
        store_location # sessions_helper参照
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end

    # アクセスしたユーザーが現在ログインしているユーザーか確認
    def correct_user
      unless current_user?(@user)
        flash[:danger] = "他のユーザー情報は閲覧出来ません。"
        redirect_to root_url
      end
    end

    # システム管理権限所有かどうか判定
    def admin_user
      unless current_user.admin?
        flash[:danger] = "管理者権限がありません。"
        redirect_to root_url
      end
    end
end