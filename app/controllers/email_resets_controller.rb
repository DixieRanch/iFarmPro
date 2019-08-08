class EmailResetsController < ApplicationController
  def show
    @email = params[:id]
  end

  def new
  end

  def create
    redirect_to email_reset_path('#')
  end
end
