class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def enforce_authentication
    unless current_user
      session[:original_path] = request.path
      redirect_to new_user_session_path
    end
  end

  def after_sign_in_path_for(_)
    session[:original_path] || root_path
  end
end
