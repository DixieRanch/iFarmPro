# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  email             :string
#  created_at        :datetime
#  updated_at        :datetime
#  password_digest   :string
#  remember_token    :string
#  company_id        :integer
#  activation_digest :string
#  activated         :boolean          default(FALSE)
#  activated_at      :datetime
#

class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.company_id = Company.current_id
    if @user.save
      flash[:success] = 'New user succesfully created'
      redirect_to root_path
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(permitted_params)
  end

  def permitted_params
    [:email, :password, :password_confirmation]
  end
end
