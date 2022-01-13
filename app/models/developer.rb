class Developer < ApplicationRecord
  include Availability
  include Avatarable
  extend FriendlyId
  friendly_id :randomizer, use: :slugged

  enum search_status: {
    actively_looking: 1,
    open: 2,
    not_interested: 3
  }

  serialize :pivot_skills
  serialize :technical_skills

  belongs_to :user
  has_many :conversations, -> { visible }
  has_one :role_type, dependent: :destroy, autosave: true
  has_one_attached :cover_image

  accepts_nested_attributes_for :role_type

  validates :name, presence: true
  validates :hero, presence: true
  validates :bio, presence: true
  validates :time_zone, presence: true, on: :create
  validates :cover_image, content_type: ["image/png", "image/jpeg", "image/jpg"],
    max_file_size: 10.megabytes
  validates :github, {not_url: true}
  validates :twitter, {not_url: true}
  validates :linkedin, {not_url: true}

  @skills_regex = /^[-\w\s]+(?:,[-\w\s]*)*$/i

  validates :technical_skills, format: {with: @skills_regex, multiline: true}

  validates :pivot_skills, format: {with: @skills_regex, multiline: true}

  scope :available, -> { where(available_on: ..Time.current.to_date) }
  scope :newest_first, -> { order(created_at: :desc) }
  scope :available_first, -> { where.not(available_on: nil).order(:available_on) }

  after_create_commit :send_admin_notification

  def role_type
    super || build_role_type
  end

  private

  def send_admin_notification
    NewDeveloperProfileNotification.with(developer: self).deliver_later(User.admin)
  end

  def randomizer
    Digest::SHA1.hexdigest("#{name} #{id}")[0..8]
  end
end
