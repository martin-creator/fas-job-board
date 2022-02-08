class DeveloperQuery
  include Pagy::Backend

  alias_method :build_pagy, :pagy

  attr_reader :options

  def initialize(options = {})
    @options = options
  end

  def available
    return nil if options[:availability].blank?

    options[:availability]
  end

  def search_field
    return nil if options[:search_field].blank?

    options[:search_field]
  end

  def job_type
    return nil if options[:job_type].blank?

    options[:job_type]
  end

  def pagy
    @pagy ||= initialize_pagy_and_developers.first
  end

  def records
    @records ||= initialize_pagy_and_developers.last
  end

  private

  def initialize_pagy
    records = Developer.newest_first.with_attached_avatar

    if available && search_field && job_type
      records = records
        .joins(:role_type)
        .where("technical_skills LIKE ?", "%#{search_field}%")
        .or(records.where("pivot_skills LIKE ?", "%#{search_field}%"))
        .and(records.where(role_type: {"#{job_type}": true}))
        .and(records.where(search_status: available))
    end

    if available && search_field
      records = records
        .where("technical_skills LIKE ?", "%#{search_field}%")
        .or(records.where("pivot_skills LIKE ?", "%#{search_field}%"))
        .and(records.where(search_status: available))
    end

    if available && job_type
      records = records
        .joins(:role_type)
        .where(role_type: {"#{job_type}": true})
        .and(records.where(search_status: available))
    end

    if available
      records = records.where(search_status: available)
    end

    if search_field && job_type
      records = records
        .joins(:role_type)
        .where("technical_skills LIKE ?", "%#{search_field}%")
        .or(records.where("pivot_skills LIKE ?", "%#{search_field}%"))
        .and(records.where(role_type: {"#{job_type}": true}))
    end

    if search_field
      records = records
        .where("technical_skills LIKE ?", "%#{search_field}%")
        .or(records.where("pivot_skills LIKE ?", "%#{search_field}%"))
    end

    if job_type
      records = records
        .joins(:role_type)
        .where(role_type: {"#{job_type}": true})
    end

    @pagy, @records = build_pagy(records)
  end

  # Needed for #pagy (aliased to #build_pagy) helper.
  def params
    options
  end
end
