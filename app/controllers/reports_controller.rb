# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :authenticate_user!

  def create
    @report = current_user.reports.new
    @report.reportable_type = params[:model]
    @report.reportable_id = params[:id]
    @report.body = params[:report][:body]
    if @report.save
      flash[:notice] = 'Reported successfully'
      redirect_back(fallback_location: root_path)
    else
      @report.errors.full_messages.join('\n')
      redirect_back(fallback_location: root_path)
    end
  end

  def index
    @post = Post.includes(:user).find(params[:id])
    @reports = @post.reports
  end
end
