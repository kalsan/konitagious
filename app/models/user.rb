class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :registerable, :omniauthable, :confirmable
  devise :database_authenticatable,
    :recoverable, :rememberable, :validatable,
     :lockable, :timeoutable, :trackable

  field :id, :string
  field :first_name, :string
  field :last_name, :string
  field :label, :string
  field :email, :email
end
