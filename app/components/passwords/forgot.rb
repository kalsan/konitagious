class Components::Passwords::Forgot < Compony::Component
  setup do
    standalone path: "/passwords/forgot" do
      skip_authentication!
      layout "auth"
      verb :get do
        authorize { true }
      end
      verb :post do
        authorize { true }
        respond do
          user = User.find_by(email: params.dig(:password, :email).to_s.strip.downcase)
          PasswordsMailer.reset(user).deliver_later if user
          controller.flash[:notice] = "Password reset instructions sent (if an account with that email exists)."
          controller.redirect_to(Compony.path(:login, :sessions))
        end
      end
    end

    label(:all) { "Forgot your password?" }

    content do
      h2 "Forgot your password?", class: "pb-4"
      concat(form_with(url: Compony.path(:forgot, :passwords), method: :post, scope: :password) do |f|
        safe_join([
          content_tag(:div, safe_join([
            f.label(:email, "Email", class: "form-label"),
            f.email_field(:email, autofocus: true, autocomplete: "email", class: "form-control")
          ]), class: "mb-3"),
          f.submit("Send me reset password instructions", class: "btn btn-primary")
        ])
      end)
      concat content_tag(:div, link_to("Login", Compony.path(:login, :sessions)), class: "pt-3")
    end
  end
end
