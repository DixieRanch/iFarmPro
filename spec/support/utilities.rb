include ApplicationHelper

def sign_in(user)
  Company.current_id = user.company.id
  create(:field)
  visit signin_path
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
  # Sign in when not using Capybara as well.
  # session[:remember_token] = user.remember_token
  # The above code doesn't work. 'session' is unavailable in integeration tests.
  # If a non-Capybara login is needed, use:
  post sessions_path, 'session[email]' => user.email, 
                      'session[password]' => user.password
  Company.current_id = user.company.id
end

def sign_in_new(user)
  visit signin_path
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
  Company.current_id = user.company.id
end

def last_email
  ActionMailer::Base.deliveries.last
end

def reset_email
  ActionMailer::Base.deliveries = []
end