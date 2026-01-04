class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :registerable, :omniauthable, :confirmable
  devise :database_authenticatable,
    :recoverable, :rememberable, :validatable,
     :lockable, :timeoutable, :trackable
end
