class User < ActiveRecord::Base
  has_paper_trail

  devise :database_authenticatable, :registerable#, :recoverable, :confirmable,
         #:lockable, :timeoutable, :validatable
          #, :rememberable, :trackable, :omniauthable

  # Validations
  #validates :email, uniqueness: true, presence: true
end
