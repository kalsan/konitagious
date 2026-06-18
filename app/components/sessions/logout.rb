class Components::Sessions::Logout < Compony::Component
  setup do
    standalone path: "/logout" do
      skip_authentication!
      verb :delete do
        authorize { true }
        respond do
          controller.send(:terminate_session)
          controller.redirect_to(Compony.path(:login, :sessions), status: :see_other)
        end
      end
    end

    label(:all) { "Logout" }
  end
end
