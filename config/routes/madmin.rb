# Below are the routes for madmin
namespace :madmin do
  resources :role_types
  resources :conversations
  resources :notifications
  resources :messages
  resources :businesses
  resources :developers
  resources :users
  namespace :active_storage do
    resources :attachments
  end
  namespace :active_storage do
    resources :variant_records
  end
  namespace :active_storage do
    resources :blobs
  end
  namespace :pay do
    resources :merchants
  end
  namespace :pay do
    resources :subscriptions
  end
  namespace :pay do
    resources :webhooks
  end
  namespace :pay do
    resources :charges
  end
  namespace :pay do
    resources :payment_methods
  end
  namespace :pay do
    resources :customers
  end
  root to: "dashboard#show"
end
