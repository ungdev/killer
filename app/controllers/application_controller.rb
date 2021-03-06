require "etu_utt/api"
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :user_signed_in?, :store_tokens, :flush_tokens

  before_filter :log_additional_data

  protected

  def log_additional_data
      request.env["exception_notifier.exception_data"] = {
        :user => current_user,
        :access_token => current_access_token
      }
  end

  def user_for_paper_trail
    user_signed_in? ? @current_user['login'] : 'user not signed in'
  end

  def user_signed_in?
  	current_access_token != nil && current_user != nil
  end

  def current_user

  	@current_user ||= EtuUtt::Api.get(current_access_token, 'public/user/account')
    logger.debug '----------CURRRENT_USER----------'
    logger.debug @current_user
    @current_user

  end
  
  # Return the curent access_token or another one (trough the refresh token) if it is expired 
  def current_access_token

    logger.debug '----------CURRRENT_ACCESS-TOKEN----------'
    logger.debug session[:access_token]
  # TODO: Improve this
	#store_tokens(EtuUtt::Api.new.get_tokens(session[:refresh_token], 'refresh_token')) 
	return session[:access_token]
  end

  def store_tokens(tokens)
	session[:access_token] = tokens[:access_token]
	session[:expires_at] = tokens[:expires_at]
	session[:refresh_token] = tokens[:refresh_token]
  end

  def flush_tokens
  	session[:access_token], session[:expires_at],session[:refresh_token] = nil, nil, nil
  end

end
