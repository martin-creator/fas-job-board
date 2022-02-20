class Pay::ChargeResource < Madmin::Resource
  # Attributes
  attribute :id, form: false
  attribute :processor_id
  attribute :amount
  attribute :currency
  attribute :application_fee_amount
  attribute :amount_refunded
  attribute :metadata
  attribute :created_at, form: false
  attribute :updated_at, form: false
  attribute :paddle_receipt_url
  attribute :stripe_account
  attribute :payment_method_type
  attribute :brand
  attribute :last4
  attribute :exp_month
  attribute :exp_year
  attribute :email
  attribute :username
  attribute :bank

  # Associations
  attribute :customer
  attribute :subscription

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
