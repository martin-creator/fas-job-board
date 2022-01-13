require "test_helper"

class DeveloperTest < ActiveSupport::TestCase
  setup do
    @developer = developers :available
  end

  test "unspecified availability" do
    @developer.available_on = nil

    assert_equal "unspecified", @developer.availability_status
    assert @developer.available_unspecified?
  end

  test "available in a future date" do
    @developer.available_on = Date.current + 2.weeks

    assert_equal "in_future", @developer.availability_status
    assert @developer.available_in_future?
  end

  test "available from a past date" do
    @developer.available_on = Date.current - 3.weeks

    assert_equal "now", @developer.availability_status
    assert @developer.available_now?
  end

  test "available from today" do
    @developer.available_on = Date.current

    assert_equal "now", @developer.availability_status
    assert @developer.available_now?
  end

  test "is valid" do
    user = users(:with_available_profile)
    developer = Developer.new(user:, name: "Foo", hero: "Bar", bio: "FooBar", avatar: active_storage_blobs(:one), time_zone: "Pacific Time (US & Canada)", technical_skills: "Ruby, Rails", pivot_skills: "writing, project management")

    assert developer.valid?
  end

  test "invalid without user" do
    developer = Developer.new(user: nil)

    refute developer.valid?
    assert_not_nil developer.errors[:user]
  end

  test "invalid without name" do
    user = users(:with_available_profile)
    developer = Developer.new(user:, name: nil)

    refute developer.valid?
    assert_not_nil developer.errors[:name]
  end

  test "invalid without hero" do
    user = users(:with_available_profile)
    developer = Developer.new(user:, hero: nil)

    refute developer.valid?
    assert_not_nil developer.errors[:hero]
  end

  test "invalid without bio" do
    user = users(:with_available_profile)
    developer = Developer.new(user:, bio: nil)

    refute developer.valid?
    assert_not_nil developer.errors[:bio]
  end

  test "is valid with pivot skills and technical skills" do
    user = users(:with_available_profile)
    developer = Developer.new(user:, name: "Foo", hero: "Bar", bio: "FooBar", avatar: active_storage_blobs(:one), time_zone: "Pacific Time (US & Canada)", pivot_skills: "customer relations, writing", technical_skills: "Ruby, Rails")

    assert developer.valid?
  end

  test "removes blank entries for pivot skills" do
    user = users(:with_available_profile)
    developer = Developer.new(user:, name: "Foo", hero: "Bar", bio: "FooBar", avatar: active_storage_blobs(:one), time_zone: "Pacific Time (US & Canada)", pivot_skills: "customer relations, ,writing, ", technical_skills: "Ruby, Rails")

    assert developer.pivot_skills = ["customer relations", "writing"]
  end

  test "removes blank entries for technical skills" do
    user = users(:with_available_profile)
    developer = Developer.new(user:, name: "Foo", hero: "Bar", bio: "FooBar", avatar: active_storage_blobs(:one), time_zone: "Pacific Time (US & Canada)", pivot_skills: "customer relations, writing", technical_skills: "Ruby, ,Rails, Python, ")

    assert developer.technical_skills = ["Ruby", "Rails", "Python"]
  end

  test "available scope is only available developers" do
    travel_to Time.zone.local(2021, 5, 4)

    developers = Developer.available

    assert_includes developers, developers(:available)
    refute_includes developers, developers(:unavailable)
  end

  test "successful profile creation sends a notification to the admins" do
    assert_difference "Notification.count", 1 do
      Developer.create!(valid_developer_attributes)
    end

    assert_equal Notification.last.type, NewDeveloperProfileNotification.name
    assert_equal Notification.last.recipient, users(:admin)
  end

  test "should accept avatars of valid file formats" do
    valid_formats = %w[image/png image/jpeg image/jpg]

    valid_formats.each do |file_format|
      @developer.avatar.stub :content_type, file_format do
        assert @developer.valid?, "#{file_format} should be a valid"
      end
    end
  end

  test "should reject avatars of invalid file formats" do
    invalid_formats = %w[image/bmp image/gif video/mp4]

    invalid_formats.each do |file_format|
      @developer.avatar.stub :content_type, file_format do
        refute @developer.valid?, "#{file_format} should be an invalid format"
      end
    end
  end

  test "should enforce a maximum avatar file size" do
    @developer.avatar.blob.stub :byte_size, 3.megabytes do
      refute @developer.valid?
    end
  end

  test "should accept cover images of valid file formats" do
    valid_formats = %w[image/png image/jpeg image/jpg]

    valid_formats.each do |file_format|
      @developer.cover_image.stub :content_type, file_format do
        assert @developer.valid?, "#{@developer.errors.full_messages} should be a valid"
      end
    end
  end

  test "should reject cover images of invalid file formats" do
    invalid_formats = %w[image/bmp video/mp4]

    invalid_formats.each do |file_format|
      @developer.cover_image.stub :content_type, file_format do
        refute @developer.valid?, "#{file_format} should be an invalid format"
      end
    end
  end

  test "should enforce a maximum cover image file size" do
    @developer.cover_image.blob.stub :byte_size, 11.megabytes do
      refute @developer.valid?
    end
  end

  test "invalid with twitter full URL" do
    user = users(:with_available_profile)
    developer = Developer.new(user:, twitter: "https://twitter.com/hirethepivot")

    refute developer.valid?
    assert_not_nil developer.errors[:twitter]
  end

  test "invalid with linkedin full URL" do
    user = users(:with_available_profile)
    developer = Developer.new(user:, twitter: "https://www.linkedin.com")

    refute developer.valid?
    assert_not_nil developer.errors[:linkedin]
  end

  test "invalid with github full URL" do
    user = users(:with_available_profile)
    developer = Developer.new(user:, twitter: "github.com")

    refute developer.valid?
    assert_not_nil developer.errors[:github]
  end

  test "is valid with github username" do
    user = users(:with_available_profile)
    developer = Developer.new(user:, name: "Foo", hero: "Bar", bio: "FooBar", avatar: active_storage_blobs(:one), time_zone: "Pacific Time (US & Canada)", pivot_skills: "customer relations, writing", technical_skills: "Ruby, Rails", github: "rails")

    assert developer.valid?
  end

  test "is valid with linkedin username" do
    user = users(:with_available_profile)
    developer = Developer.new(user:, name: "Foo", hero: "Bar", bio: "FooBar", avatar: active_storage_blobs(:one), time_zone: "Pacific Time (US & Canada)", pivot_skills: "customer relations, writing", technical_skills: "Ruby, Rails", linkedin: "ruby")

    assert developer.valid?
  end

  test "is valid with twitter username" do
    user = users(:with_available_profile)
    developer = Developer.new(user:, name: "Foo", hero: "Bar", bio: "FooBar", avatar: active_storage_blobs(:one), time_zone: "Pacific Time (US & Canada)", pivot_skills: "customer relations, writing", technical_skills: "Ruby, Rails", twitter: "hirethepivot")

    assert developer.valid?
  end

  def valid_developer_attributes
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
