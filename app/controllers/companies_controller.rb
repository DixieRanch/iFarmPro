class CompaniesController < ApplicationController

  skip_before_filter :signed_in_user, only: [:new, :create]

  def new
    @company = Company.new
    @company.users.build
  end

  def create
    @company = Company.new(params[:company])
    if @company.save
      sign_in @company.users.first
      flash[:success] = "Welcome to iFarmPro!"
      redirect_to @company
    else
      render 'new'
    end
  end

  def show
    @company = current_user.company
  end
end