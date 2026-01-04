class Components::Users::Form < Compony::Components::Form
  setup do
    form_fields do
      concat field :first_name
      concat field :last_name
      concat field :email
      concat field :phone
      concat pw_field :password
      concat pw_field :password_confirmation
    end

    schema_field :first_name
    schema_field :last_name
    schema_field :email
    schema_field :phone
    schema_pw_field :password
    schema_pw_field :password_confirmation
  end
end
