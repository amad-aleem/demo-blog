# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    @first_post = Post.published.first
    @posts = Post.published.recent.all
  end
end
