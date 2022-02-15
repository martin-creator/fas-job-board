module DevelopersHelper
  extend ActiveSupport::Concern

  included do
    def developer_attributes
      {
        user: users(:empty),
        name: "Name",
        hero: "Hero",
        bio: "Bio",
        pivot_skills: "customer relations, writing",
        technical_skills: "Ruby, Rails",
        avatar: active_storage_blobs(:one),
        time_zone: "Pacific Time (US & Canada)"
      }
    end
  end
end
