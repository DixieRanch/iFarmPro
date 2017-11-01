class ReportsController < ApplicationController
  def show
    @report = Report.generate(params[:id])
    @year = params[:year] || Time.zone.now.year
    render template: "reports/#{params[:id]}"
  end
end
