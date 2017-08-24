class PasswordResetsController < ApplicationController
  
  skip_before_filter :signed_in_user
  
  def new
    
  end
end
