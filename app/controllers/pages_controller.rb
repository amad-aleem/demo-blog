# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    @first_post = Post.find(Post.published.joins(:likes).group(:likeable_id).count.max_by{|k,v| v}.first)
    @posts = Post.published.recent.all
  end
end
