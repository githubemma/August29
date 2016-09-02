class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         #:recoverable,
         :rememberable,
         #:trackable,
         :validatable

  has_many :pages, through: :bookmarks
  has_many :user_email_logs, dependent: :destroy
end
