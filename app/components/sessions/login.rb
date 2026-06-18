class Components::Sessions::Login < Compony::Component
  setup do
    standalone path: "/login" do
      skip_authentication!
      layout "auth"
      verb :get do
        authorize { true }
      end
      verb :post do
        authorize { true }
        respond do
          credentials = params.fetch(:session, {})
          user = User.authenticate_by(email: credentials[:email].to_s.strip.downcase, password: credentials[:password].to_s)
          if user
            controller.send(:start_new_session_for, user, remember: credentials[:stay_signed_in] == "1")
            controller.redirect_to(controller.send(:after_authentication_url))
          else
            controller.redirect_to(Compony.path(:login, :sessions), alert: "Wrong email or password.")
          end
        end
      end
    end

    label(:all) { "Login" }

    content do
      h2 "Log in to your account", class: "pb-4"
      concat(form_with(url: Compony.path(:login, :sessions), method: :post, scope: :session) do |f|
        safe_join([
          content_tag(:div, safe_join([
            f.label(:email, "Email", class: "form-label"),
            f.email_field(:email, autofocus: true, autocomplete: "email", value: params.dig(:session, :email), class: "form-control")
          ]), class: "mb-3"),
          content_tag(:div, safe_join([
            f.label(:password, "Password", class: "form-label"),
            f.password_field(:password, autocomplete: "current-password", class: "form-control")
          ]), class: "mb-3"),
          content_tag(:div, link_to("Forgot your password?", Compony.path(:forgot, :passwords)), class: "mb-3"),
          content_tag(:div, safe_join([
            f.check_box(:stay_signed_in, { checked: true, class: "form-check-input" }, "1", "0"),
            f.label(:stay_signed_in, "Stay signed in", class: "form-check-label")
          ]), class: "form-check mb-3"),
          f.submit("Login", class: "btn btn-primary")
        ])
      end)
    end
  end
end
