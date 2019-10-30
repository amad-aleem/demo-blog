# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :authenticate_user!

  def create
    @report = current_user.reports.new
    @report.user_id = current_user.id
    @report.reportable_type = params[:model]
    @report.reportable_id = params[:id]
    @report.body = params[:report][:body]
    if @report.save
      flash[:notice] = 'Reported successfully'
      redirect_back(fallback_location: root_path)
    else
      @report.errors.full_messages.each do |msg|
        flash[:alert] = msg
      end
      redirect_back(fallback_location: root_path)
    end
  end

  def index
    @post = Post.find(params[:id])
    @reports = Report.where(reportable_id: @post.id, reportable_type: 'Post')
  end
end
