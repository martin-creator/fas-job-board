class OpenGraphTagsComponent < ApplicationComponent
  def initialize(title: nil, description: nil, image: nil)
    @title = title
    @description = description
    @image = image
  end

  def title
    @title || "hirethePIVOT"
  end

  def description
    @description || t("open_graph_tags_component.default_description")
  end

  def url
    root_url
  end

  def image
    @image || helpers.image_url("logo.svg")
  end

  def twitter
    "@rabbigreenberg"
  end
end
