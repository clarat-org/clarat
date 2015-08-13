# The external web addresses of organizations and offers.
class Website < ActiveRecord::Base
  # associtations
  has_many :hyperlinks
  has_many :organizations, through: :hyperlinks,
                           source: :linkable, source_type: 'Organization'
  has_many :offers, through: :hyperlinks,
                    source: :linkable, source_type: 'Offer'

  # Enumerization
  extend Enumerize
  HOSTS = %w(own facebook twitter youtube gplus pinterest document other)
  enumerize :host, in: HOSTS

  # Validations
  validates :host, presence: true
  validates :url, format: %r{\Ahttps?://\S+\.\S+\z}, uniqueness: true,
                  presence: true

  # Scopes
  scope :own, -> { where(host: 'own') }
  scope :facebook, -> { where(host: 'facebook') }
  scope :twitter, -> { where(host: 'twitter') }
  scope :youtube, -> { where(host: 'youtube') }
  scope :gplus, -> { where(host: 'gplus') }
  scope :pinterest, -> { where(host: 'pinterest') }
  scope :document, -> { where(host: 'document') }
  scope :other, -> { where(host: 'other') }

  scope :pdf, -> { where('websites.url LIKE ?', '%.pdf') }
  scope :non_pdf, -> { where.not('websites.url LIKE ?', '%.pdf') }

  def shorten_url
    URI.parse(self.url).host
  end

  def pdf_appendix
    url.ends_with?('.pdf') ? ' (PDF)' : ''
  end
end
