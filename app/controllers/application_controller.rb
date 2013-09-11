# FIXME: add devise messages
# registration edit
#   Successfully updated your profile.
#   There was a problem with your profile.
# registration create
#   Welcome! Please sign in with your new account.
#   There was a problem with your information.
# session destroy
#   You have been successfully signed out.
# session new
#   Invalid email or password.
require 'ipaddr'

class ApplicationController < ActionController::Base
  protect_from_forgery

  # before_action :check_ip_for_admins

  def root
    authenticate_user!
    start_page = current_user.try(:admin?) ? new_admin_user_path : manage_orders_path
    redirect_to start_page
  end

  def help
    render 'partials/help'
  end

  private # ----------

  def ip_allowed?
    request_ip  = IPAddr.new request.remote_ip
    Rails.configuration.allowed_ips.any? do |addr|
      IPAddr.new(addr).include? request_ip
    end
  end

  def check_ip_for_admins
    if current_user && current_user.admin?
      if !ip_allowed?
        sign_out current_user
        redirect_to new_user_session_path,
          notice: 'Admin users may only login from approved ip addresses'
      end
    end
  end


  # Redirects to the login path to allow the flash messages to display for sign_out.
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
