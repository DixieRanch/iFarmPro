# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime
#  updated_at :datetime
#

class CompaniesController < ApplicationController

  skip_before_filter :signed_in_user, only: [:new, :create]

  def new
    @company = Company.new
    @company.users.build
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      sign_in @company.users.first
      flash[:success] = "Welcome to iFarmPro!"
      redirect_to new_farm_path
    else
      render 'new'
    end
  end

  def show
    @company = current_user.company
  end

private
    def company_params
      params.require(:company).permit(permitted_params)
    end

    def permitted_params
      [:name, users_attributes]
    end

    def users_attributes
      { users_attributes: [:email, :password, :password_confirmation, :id] }
    end
end
