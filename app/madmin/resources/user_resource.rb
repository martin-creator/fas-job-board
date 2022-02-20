class UserResource < Madmin::Resource
  # Attributes
  attribute :id, form: false
  attribute :email
  attribute :encrypted_password
  attribute :reset_password_token
  attribute :reset_password_sent_at
  attribute :remember_created_at
  attribute :confirmation_token
  attribute :confirmed_at
  attribute :confirmation_sent_at
  attribute :unconfirmed_email
  attribute :created_at, form: false
  attribute :updated_at, form: false
  attribute :admin
  attribute :provider
  attribute :uid

  # Associations
  attribute :pay_customers
  attribute :charges
  attribute :subscriptions
  attribute :payment_processor
  attribute :notifications
  attribute :business
  attribute :developer
  attribute :conversations

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
