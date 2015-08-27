# Devise user model, only used for researchers and supervisors to access the
# backend. Not for clients yet.
class User < ActiveRecord::Base
  has_paper_trail

  devise :database_authenticatable, :validatable, :registerable, :recoverable,
         :confirmable, :lockable, :timeoutable, :omniauthable,
         omniauth_providers: [:facebook, :google_oauth2]
  # , :rememberable, :trackable

  # Associations
  has_many :authored_notes, class_name: 'Note', inverse_of: :user

  # Validations
  # validates :email, uniqueness: true, presence: true

  # Enumerization
  extend Enumerize
  enumerize :role, in: %w(standard researcher super)

  # Scopes
  scope :researcher, -> { where(role: 'researcher') }
end
