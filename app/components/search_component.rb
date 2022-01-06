class SearchComponent < ApplicationComponent
  attr_accessor :pivot_skills, :technical_skills, :role_types, :availability

  def initialize(pivot_skills = nil, technical_skills = nil, role_types = nil, availability = nil)
    @pivot_skills = pivot_skills
    @technical_skills = technical_skills
    @role_types = role_types
    @availability = availability
  end
end
