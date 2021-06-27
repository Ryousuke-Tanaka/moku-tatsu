crumb :root do
  link "トップページ", root_path
end

# session
crumb :session_new do
  link "ログイン", login_path
  parent :root
end

# ユーザー
crumb :user_new do
  link "ユーザー登録", new_user_path
  parent :root
end

crumb :user_show do |user|
  link "マイページ", user_path(user)
  parent :root
end

crumb :user_index do |user|
  link "ユーザー一覧", users_path
  parent :user_show, user
end

crumb :user_edit do |user|
  link "ユーザー編集"
  parent :user_show, user
end

# 投稿
crumb :post_index do |post|
  link "全体の投稿", user_posts_path(post)
  parent :user_show, post
end

crumb :post_show_own_post do |user|
  user = User.find(params[:id])
  link "#{ user.name }さんの投稿ページ", posts_show_own_post_user_path(user.id)
  parent :post_index, user
end

crumb :post_show do |post|
  link "#{ post.user.name }さんの投稿詳細"
  parent :post_show_own_post, post
end

# フォロー、フォロワー
crumb :user_follow do |post|
  if controller.action_name == "following"
    link "#{ post.name }さんのフォロー"
  else
    link "#{ post.name }さんのフォロワー"
  end
  parent :post_show_own_post, post
end

