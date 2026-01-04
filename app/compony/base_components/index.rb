module BaseComponents
  class Index < Compony::Components::Index
    setup do
      content do
        h1 data_class.model_name.human(count: 2), class: "mt-2 mb-3"
        concat render_sub_comp :list, @data
      end
    end
  end
end
