class Components::Commons::BootstrapButton < Compony::Components::Buttons::Link
  protected

  def prepare_opts!
    super

    color = @comp_opts[:color].presence || "primary"

    classes = @comp_opts[:class]&.split(" ") || []
    classes << "btn"
    classes << "btn-#{color}"
    @comp_opts[:class] = classes.join(" ")
  end
end
