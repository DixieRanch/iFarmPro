class EmailResetsController < ApplicationController
  
  def show
    @email = params[:id]
  end

  def new
  end
  
  def create
    puts params
    redirect_to email_reset_path('#')
  end
end
