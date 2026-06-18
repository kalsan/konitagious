class Components::Passwords::Reset < Compony::Component
  setup do
    standalone path: "/passwords/:token/reset" do
      skip_authentication!
      layout "auth"
      verb :get do
        authorize { true }
        respond do
          if User.find_by_token_for(:password_reset, params[:token])
            render_standalone(controller)
          else
            controller.redirect_to(Compony.path(:forgot, :passwords), alert: "Password reset link is invalid or has expired.")
          end
        end
      end
      verb :patch do
        authorize { true }
        respond do
          user = User.find_by_token_for(:password_reset, params[:token])
          if user.nil?
            controller.redirect_to(Compony.path(:forgot, :passwords), alert: "Password reset link is invalid or has expired.")
          elsif user.update(password: params.dig(:password, :password), password_confirmation: params.dig(:password, :password_confirmation))
            user.sessions.destroy_all
            controller.redirect_to(Compony.path(:login, :sessions), notice: "Your password has been reset. Please log in.")
          else
            controller.redirect_to(Compony.path(:reset, :passwords, token: params[:token]), alert: "Passwords did not match or are too short.")
          end
        end
      end
    end

    label(:all) { "Change your password" }

    content do
      h2 "Change your password", class: "pb-4"
      concat(form_with(url: Compony.path(:reset, :passwords, token: params[:token]), method: :patch, scope: :password) do |f|
        safe_join([
          content_tag(:div, safe_join([
            f.label(:password, "New password", class: "form-label"),
            f.password_field(:password, autofocus: true, autocomplete: "new-password", class: "form-control")
          ]), class: "mb-3"),
          content_tag(:div, safe_join([
            f.label(:password_confirmation, "Confirm your new password", class: "form-label"),
            f.password_field(:password_confirmation, autocomplete: "new-password", class: "form-control")
          ]), class: "mb-3"),
          f.submit("Change my password", class: "btn btn-primary")
        ])
      end)
    end
  end
end
