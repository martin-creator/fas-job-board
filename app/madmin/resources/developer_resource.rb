class DeveloperResource < Madmin::Resource
  # Attributes
  attribute :id, form: false
  attribute :name
  attribute :email
  attribute :available_on
  attribute :hero
  attribute :bio
  attribute :website
  attribute :github
  attribute :twitter
  attribute :created_at, form: false
  attribute :updated_at, form: false
  attribute :linkedin
  attribute :search_status
  attribute :preferred_min_hourly_rate
  attribute :preferred_max_hourly_rate
  attribute :preferred_min_salary
  attribute :preferred_max_salary
  attribute :time_zone
  attribute :pivot_skills
  attribute :technical_skills
  attribute :slug
  attribute :availability_status, index: false
  attribute :avatar, index: false
  attribute :cover_image, index: false

  # Associations
  attribute :user
  attribute :conversations
  attribute :role_type

  # Uncomment this to customize the display name of records in the admin area.
  # def self.display_name(record)
  #   record.name
  # end

  # Uncomment this to customize the default sort column and direction.
  # def self.default_sort_column
  #   "created_at"
  # end
  #
  # def self.default_sort_direction
  #   "desc"
  # end
end
