class Components::PublicPages::Homepage < Compony::Component
  setup do
    standalone path: "/homepage" do
      verb :get do
        authorize { true }
      end
    end

    content do
      div class: "card card-body" do
        h1 "foo"
      end
    end
  end
end
