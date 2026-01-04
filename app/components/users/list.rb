class Components::Users::List < BaseComponents::List
  setup do
    columns :first_name, :last_name, :email
    filter :label
    sorts :first_name, :last_name
  end
end
