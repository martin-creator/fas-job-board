class Pay::SubscriptionResource < Madmin::Resource
  # Attributes
  attribute :id, form: false
  attribute :name
  attribute :processor_id
  attribute :processor_plan
  attribute :quantity
  attribute :status
  attribute :trial_ends_at
  attribute :ends_at
  attribute :application_fee_percent
  attribute :metadata
  attribute :created_at, form: false
  attribute :updated_at, form: false
  attribute :prorate, index: false
  attribute :paddle_update_url
  attribute :paddle_cancel_url
  attribute :paddle_paused_from
  attribute :stripe_account

  # Associations
  attribute :customer
  attribute :charges

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
