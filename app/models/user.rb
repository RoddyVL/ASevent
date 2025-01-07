class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :orders
  has_many :bookings

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
