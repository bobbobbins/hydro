#ActionView::Base.field_error_proc = Proc.new{ |html_tag, instance| "<div class=\"field_with_errors\">#{html_tag}</div>".html_safe }
class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :items_in_cart,  :current_cart, :header_categories, :authorize_net

  before_filter :authenticate

  protected

  def authenticate
    if !Rails.env.production?
      authenticate_or_request_with_http_basic do |username, password|
        username == "hydroflask" && password == "Hydr0fl4sk!"
      end
    end
  end

  private

  #---------------------------------------------------------------------------
  # Get the user's current cart (will auto-create blank one if none exists)
  def current_cart
    
    # See if the logged-in user has a cart in progress
    #cart = Cart.find_by_account_id(current_account.id) if (current_account)
    #return cart if cart
    
    # See if the current web session has a cart
    cart = Cart.find_by_id(session[:cart_id])
    
    # No cart found in session or for user account, then create new one
    cart = Cart.create unless cart
    # Save user account against the cart, if the user is logged in
    cart.account_id = current_account.id if current_account
    cart.save
    
    # Save cart in the session
    session[:cart_id] = cart.id
    
    cart
  end

  def current_order
    
    if session[:order].blank?
      session[:order] = {}
    end
    # See if the logged-in user has a cart in progress
    return session[:order]
    
  end

  #---------------------------------------------------------------------------
  
  #---------------------------------------------------------------------------
  # A new user Account is created, the user is signed in to the session,
  # their acccount is associated with the existing cart being used, and
  # the Account object is returned.
  def sign_in_user_and_associate_to_cart(cart, new_email, new_account_password)
    
    # If the person forgot to sign in, and their account already exists
    the_account = Account.find_by_email(new_email)
    
    # ignore their old cart, and associate their cart with this one
    return sign_in_account_with_cart(cart, the_account) if the_account
    
    # If we reach this point, no account exists for the specified email, so create it now
    the_account = Account.new(:email => new_email,
                              :password => new_account_password,
                              :password_confirmation => new_account_password)
    
    
    # Note: if Account is invalid, then just the object with errors is returned
    return the_account unless the_account.valid?
    
    sign_in_account_with_cart(cart, the_account)
  end
  #---------------------------------------------------------------------------
  
  #---------------------------------------------------------------------------
  def sign_in_account_with_cart(cart, the_account)
    # Note: "sign_in" and "current_account" are Devise convenience methods
    
    # Important: we need to call sign_in 2 TIMES, to make devise update the session properly:
    #            See: http://stackoverflow.com/questions/4660565/how-to-manually-create-a-new-user-and-user-session-in-devise
    sign_in(the_account)
    
    # :bypass is set to ignore devise related callbacks and only save the
    # user into session.
    sign_in(the_account, :bypass => true)
    
    # "current_account" will be set unless an error occurred
    if (current_account != the_account)
      the_account.errors(:base, "Sign-in failed. Please try again")
      flash[:auto_signup_notification] = "Sign-in failed. Please try again"
      return the_account
    end
    
    # within sign_in, "current_account" was set, so assciate with the cart, and save
    cart.account_id = current_account.id  
    cart.save!
    
    # Save cart in the session
    session[:cart_id] = cart.id
    
    flash[:auto_signup_notification] = "Signed-in as #{current_account.email}" if current_account
    
    current_account  # should be the same as the_account at this point
  end
  #---------------------------------------------------------------------------

  def items_in_cart
    # protect from nil current_cart, although it should never happen
    current_cart ? current_cart.line_items.count : 0
  end

  def header_categories
    Category.find(:all)
  end

  after_filter :store_location

  #FIXME: if the location the person is on is a POST url that has just been done, this will
  #       error when the user tries to sign in.  e.g. email_subscriptions/subscribe
  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    # But don't redirect back to any of the accounts pages after a logout (that causes redirect loop)
    if (!request.fullpath.include?("/accounts") && \
        !request.fullpath.include?("/accounts/sign_in") && \
        !request.fullpath.include?("/accounts/sign_up") && \
        !request.fullpath.include?("/accounts/password") && \
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath
    else
      session[:previous_url] = root_path  # redirect to root_path after logout
    end
  end

  # redirect to the page the user was on before sign-in, or if they were on the main sign-in view, redirect to root
  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  def after_sign_out_path_for(resource)
    session[:previous_url] || root_path
  end

  #FIXME: this does not seem to be working at all
  def redirect_url
    flash[:error] = "Invalid login or password"
    
    #session[:previous_url] || login_path
    login_path  # always want login failures to go back to the login screen
  end
end
