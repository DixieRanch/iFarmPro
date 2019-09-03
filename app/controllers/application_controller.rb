class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :signed_in_user
  around_action :scope_current_company
  before_action :farm_setup

  private

  # -------- Company Data Segration Methods -------

  def scope_current_company
    Company.current_id = current_company.id if signed_in?
    yield
  ensure
    Company.current_id = nil
  end

  def current_company
    current_user.company
  end

  # -------- User Authentication Methods ----------

  def signed_in_user
    return if signed_in?
    store_location
    redirect_to signin_url, notice: 'Please sign in.'
  end

  def sign_in(user)
    if user.activated?
      session[:remember_token] = user.remember_token
      scope_current_farm(user)
      self.current_user = user
      redirect_back_or root_path
    else
      user.send_activation_email unless user.email_digest?
      redirect_to account_activation_path(user.email)
    end
  end

  def signed_in?
    !current_user.nil?
  end
  helper_method :signed_in?

  def sign_out
    self.current_user = nil
    session.delete(:remember_token)
  end

  attr_writer :current_user

  def current_user
    @current_user ||= User.find_by(remember_token: session[:remember_token])
  end
  helper_method :current_user

  def current_user?(user)
    user == current_user
  end

  # -------- Company Data Segration Methods ----------

  def scope_current_farm(user)
    Farm.unscoped do
      if user.company.farms.order('id').to_a.any?
        session[:farm_id] = user.company.farms.order('id').first.id
      end
    end
  end

  def current_farm
    Farm.find_by(id: session[:farm_id])
  end
  helper_method :current_farm

  # -------- Friendly Forwarding Methods ----------

  def store_location
    session[:return_to] = request.url
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  # --------- Farm Setup Methods ----------

  def farm_setup
    return unless signed_in?
    redirect_to_farm_setup
  end

  def redirect_to_farm_setup
    if Farm.all.empty?
      flash[:info] = '<strong>Welcome to iFarmPro.</strong>
                        Please setup your first farm.'
      flash.keep
      redirect_to new_farm_path
    elsif Field.all.empty?
      flash[:info] = '<strong>Welcome to iFarmPro.</strong>
                        Please add a field to get started.'
      redirect_to edit_farm_path(Farm.first)
    end
  end
end
