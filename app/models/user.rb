class User < ActiveRecord::Base
  has_paper_trail

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable#, :registerable,
         #:recoverable, :rememberable, :trackable, :validatable
end
