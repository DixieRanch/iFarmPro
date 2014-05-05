class ReportsController < ApplicationController

  def show
    @report = Report.generate(params[:id])
    render template: "reports/#{params[:id]}"
  end
end