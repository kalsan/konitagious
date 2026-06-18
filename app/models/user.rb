class User < ApplicationRecord
  # Password authentication via has_secure_password (bcrypt). Adds presence (on
  # create), confirmation and length validations for :password, and provides
  # User.authenticate_by. The bcrypt hash lives in password_digest (renamed from
  # devise's encrypted_password in the migration, so existing passwords survive).
  has_secure_password

  has_many :sessions, dependent: :destroy

  # Stateless, signed token for password resets (replaces devise :recoverable).
  # Expires after 15 minutes and is invalidated once the password_digest changes.
  generates_token_for :password_reset, expires_in: 15.minutes do
    password_salt&.last(10)
  end

  normalizes :email, with: ->(e) { e.strip.downcase }

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :phone, allow_blank: true, phone: true

  field :id, :string
  field :first_name, :string
  field :last_name, :string
  field :label, :string
  field :email, :email
  field :phone, :phone
end
