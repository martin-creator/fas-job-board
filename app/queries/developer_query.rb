class DeveloperQuery
  include Pagy::Backend

  alias_method :build_pagy, :pagy

  attr_reader :options

  def initialize(options = {})
    @options = options
  end

  def available?
    return nil if options[:available].blank?

    options[:available]
  end

  def search_field
    return nil if options[:search_field].blank?

    options[:search_field]
  end

  def search_status
    return nil if options[:search_status].blank?

    options[:search_status]
  end

  def pagy
    @pagy ||= initialize_pagy.first
  end

  def records
    @records ||= initialize_pagy.last
  end

  private

  def initialize_pagy
    records = Developer.most_recently_added.with_attached_avatar

    if available? && search_field && search_status
      records = records.where("technical_skills LIKE ? OR pivot_skills LIKE ? AND search_status = ?", "%#{search_field}%", "%#{search_field}%", "%#{search_status}%")
      records = records.available
    end

    if available? && search_field
      records = records.where("technical_skills LIKE ? OR pivot_skills LIKE ?", "%#{search_field}%", "%#{search_field}%")
      records = records.available
    end

    if available? && search_status
      records = records.where("search_status = ?", "%#{search_status}%")
      records = records.available
    end

    if available?
      records = records.available
    end

    if search_field && search_status
      records = records.where("technical_skills LIKE ? OR pivot_skills LIKE ? AND search_status = ?", "%#{search_field}%", "%#{search_field}%", "%#{search_status}%")
    end

    if search_field
      records = records.where("technical_skills LIKE ? OR pivot_skills LIKE ?", "%#{search_field}%", "%#{search_field}%")
    end

    if search_status
      records = records.where("search_status = ?", "%#{search_status}%")
    end

    @pagy, @records = build_pagy(records)
  end

  # Needed for #pagy (aliased to #build_pagy) helper.
  def params
    options
  end
end
