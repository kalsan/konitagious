class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :registerable, :omniauthable, :confirmable
  devise :database_authenticatable,
    :recoverable, :rememberable, :validatable,
     :lockable, :timeoutable, :trackable

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :phone, allow_blank: true, phone: true

  field :id, :string
  field :first_name, :string
  field :last_name, :string
  field :label, :string
  field :email, :email
  field :phone, :phone

  protected

  def password_required?
    return false if encrypted_password.present?
    super
  end
end
