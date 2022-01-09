require "test_helper"

class SearchComponentTest < ViewComponent::TestCase
  test "shows a form with a select input" do
    component = SearchComponent.new
    render_inline(component)
    assert_selector "select"
  end

  test "it lists drop drown options as Filters" do
    component = SearchComponent.new
    render_inline(component)
    assert_text "Filters"
  end
end
