# frozen_string_literal: true

class User < ApplicationRecord
  devise :confirmable,
    :database_authenticatable,
    :recoverable,
    :registerable,
    :rememberable,
    :validatable,
    :omniauthable, omniauth_providers: [:google_oauth2]
  pay_customer

  has_many :notifications, as: :recipient, dependent: :destroy
  has_one :business, dependent: :destroy
  has_one :developer, dependent: :destroy

  has_many :conversations, lambda { |user|
    unscope(where: :user_id)
      .left_joins(:business, :developer)
      .where("businesses.user_id = ? OR developers.user_id = ?", user.id, user.id)
      .visible
  }

  scope :admin, -> { where(admin: true) }

  def pay_customer_name
    business&.name
  end

  def active_business_subscription?
    subscriptions.any?(&:active?)
  end

  def self.create_from_provider_data(provider_data)
    user = User.find_by(email: provider_data.info.email)
    if user&.confirmed?
      user.provider = provider_data.provider
      user.uid = provider_data.uid
      return user
    end

    where(provider: provider_data.provider, uid: provider_data.uid).first_or_create do |user|
      user.email = provider_data.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end
end
