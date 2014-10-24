class User < ActiveRecord::Base
  has_paper_trail

  devise :database_authenticatable, :validatable#, :registerable, :recoverable, :confirmable,
         #:lockable, :timeoutable
          #, :rememberable, :trackable, :omniauthable

  # Validations
  #validates :email, uniqueness: true, presence: true
end
