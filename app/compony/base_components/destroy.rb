module BaseComponents
  class Destroy < Compony::Components::Destroy
    setup do
      button(:color) { :danger }
    end
  end
end
