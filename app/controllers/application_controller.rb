class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Invoked by Compony per component (Compony.authentication_before_action).
  # Public components bypass this via `skip_authentication!`.
  def enforce_authentication
    request_authentication unless authenticated?
  end
end
