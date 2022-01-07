class SearchComponent < ApplicationComponent
  attr_accessor :pivot_skills, :technical_skills, :job_type, :availability

  def initialize(pivot_skills = nil, technical_skills = nil, job_type = nil, availability = nil)
    @pivot_skills = pivot_skills
    @technical_skills = technical_skills
    @job_type = job_type
    @availability = availability
  end
end
