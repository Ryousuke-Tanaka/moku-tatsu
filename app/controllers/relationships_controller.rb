class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    user = User.find(params[:followed_id])
    current_user.follow(user)
    # 通知機能
    user.create_notification_follow!(current_user)
    respond_to do |format|
      format.html { redirect_to user_posts_url(current_user) }
      format.js
    end
  end

  def destroy
    user = Relationship.find(params[:id]).followed_id
    current_user.unfollow(user)
    respond_to do |format|
      format.html { redirect_to user_posts_url(current_user) }
      format.js
    end
  end

end
