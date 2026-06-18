module Authentication
  extend ActiveSupport::Concern

  included do
    # Populate Current.session on every request when a valid session cookie is
    # present. This NEVER redirects - it only makes current_user available (e.g.
    # for the navbar on public pages). Access enforcement happens per Compony
    # component via ApplicationController#enforce_authentication, which public
    # components bypass with skip_authentication!.
    before_action :resume_session
    helper_method :authenticated?, :current_user
  end

  def authenticated?
    Current.session.present?
  end

  def current_user
    Current.user
  end

  private

  def resume_session
    Current.session ||= find_session_by_cookie
  end

  def find_session_by_cookie
    return unless cookies.signed[:session_id]

    Session.find_by(id: cookies.signed[:session_id])
  end

  def request_authentication
    session[:original_path] = request.url
    redirect_to Compony.path(:login, :sessions)
  end

  def after_authentication_url
    session.delete(:original_path) || root_url
  end

  def start_new_session_for(user, remember: true)
    session = user.sessions.create!(
      user_agent: request.user_agent,
      ip_address: request.remote_ip,
      remember:   remember
    )
    Current.session = session
    issue_session_cookie(session)
    session
  end

  # For a "Stay signed in" session the cookie is persistent (survives browser
  # restarts); otherwise it is a browser-session cookie cleared on close.
  def issue_session_cookie(session)
    cookie = { value: session.id, httponly: true, same_site: :lax }
    if session.remember?
      cookies.signed.permanent[:session_id] = cookie
    else
      cookies.signed[:session_id] = cookie
    end
  end

  def terminate_session
    Current.session&.destroy
    cookies.delete(:session_id)
  end
end
