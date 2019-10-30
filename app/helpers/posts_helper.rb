# frozen_string_literal: true

module PostsHelper
  def likedByUser(comment)
    comment.likes.where(user_id: current_user.id).exists?
  end
end
