class DeveloperQueryComponent < ApplicationComponent
  attr_reader :query

  delegate :sort, to: :query

  def initialize(query)
    @query = query
  end

  def selected?(time_zone_pair)
    query.time_zones.include?(time_zone_pair.first)
  end

  def time_zones
    @time_zones ||= Developer.where.not(time_zone: [nil, ""])
      .map { |d| formatted_time_zone(d.time_zone) }
      .uniq.sort
      .map { |offset| [offset, "#{offset} #{t("developer_query_component.gmt")}"] }
  end
end
