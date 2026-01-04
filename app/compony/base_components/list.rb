module BaseComponents
  class List < Compony::Components::List
    setup do
      filter_input_class "form-control"
      sorting_links false

      content :filter, hidden: true do
        div class: "accordion my-2", id: "filter-accordion" do
          div class: "accordion-item" do
            h2 class: "accordion-header" do
              button I18n.t("compony.components.index.filters"),
                     class: "accordion-button collapsed", type: "button", 'data-bs-toggle': "collapse",
                     'data-bs-target': "#filter-collapse", 'aria-expanded': "false", 'aria-controls': "filter-collapse"
            end
            div id: "filter-collapse", class: "accordion-collapse collapse", 'data-bs-parent': "#filter-accordion" do
              div class: "accordion-body" do
                form_html = search_form_for @q, url: url_for, as: param_name(:q) do |f|
                  div class: "card card-body" do
                    # Sorting in filter
                    if sorting_in_filter_enabled? && @sorts.any?
                      div f.label(:s, I18n.t("compony.components.index.sorting"))
                      div f.select(:s, sorting_in_filter_select_opts, { include_blank: true, selected: params.dig(param_name(:q), :s) }, class: "form-select")
                    end
                    # Filters
                    if filtering_enabled? && @filters.any?
                      @filters.each do |filter|
                        div do
                          instance_exec(f, &filter[:payload])
                        end
                      end
                    end
                    # Submit button
                    div class: "mt-2" do
                      # Fake submit button rendered by a button component and submitting the form via JS:
                      concat render_intent(name: :submit, label: @submit_label || I18n.t("compony.components.form.submit"), button: {
                        onclick: "this.closest('form').requestSubmit(); return false;"
                      })
                      # Real (but hidden) submit button to allow Return to submit:
                      button type: :submit, hidden: true
                    end
                  end
                end
                concat form_html
              end
            end
          end
        end
      end

      content :sorting_links, hidden: true do
        div do
          strong I18n.t("compony.components.index.sorting")
          @sorts.each do |sort|
            span sort_link(@q, sort[:name], sort[:label])
          end
        end
      end

      content :data, hidden: true do
        table class: "table table-striped" do
          thead do
            tr do
              @columns.each do |column|
                relevant_sort = @sorts.find { |s| s[:name] == column[:name] }
                if relevant_sort
                  th sort_link(@q, relevant_sort[:name], relevant_sort[:label])
                else
                  th column[:label], class: "list-data-label"
                end
              end
              unless @skip_row_intents
                th I18n.t("compony.components.index.actions"), class: "list-actions-label"
              end
            end
          end
          tbody do
            @processed_data.each do |record|
              tr do
                @columns.each do |column|
                  td class: column[:class] do
                    instance_exec(record, &column[:payload])
                  end
                end
                unless @skip_row_intents
                  td class: "d-flex gap-1" do
                    row_intents(data: record, label: { format: :short }, button: { data: { 'turbo-frame': :_top } }).each do |row_intent|
                      next if @skipped_row_intents.include?(row_intent.name)
                      div row_intent.render(controller)
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
