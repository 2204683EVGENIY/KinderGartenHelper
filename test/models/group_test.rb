require "test_helper"

class GroupTest < ActiveSupport::TestCase
  # Test the validity of a valid Group
  test "should be valid with valid attributes" do
    group = Group.new(title: "Group C")
    assert group.valid?, "Group should be valid with a title"
  end

  # Test the presence of title
  test "should be invalid without a title" do
    group = Group.new(title: nil)
    assert_not group.valid?, "Group should be invalid without a title"
    assert_includes group.errors[:title], "can't be blank", "Title validation error missing"
  end

  # Test uniqueness of title
  test "should not allow duplicate titles" do
    existing_group = groups(:group_one) # Using fixture
    new_group = Group.new(title: existing_group.title)
    assert_not new_group.valid?, "Group should be invalid with a duplicate title"
    assert_includes new_group.errors[:title], "has already been taken", "Uniqueness validation error missing"
  end

  # Test associations
  test "should respond to mentors association" do
    group = groups(:group_one)
    assert_respond_to group, :mentors, "Group does not have mentors association"
  end

  test "should respond to childrens association" do
    group = groups(:group_one)
    assert_respond_to group, :childrens, "Group does not have childrens association"
  end

  test "should respond to monthly reports association" do
    group = groups(:group_one)
    assert_respond_to group, :monthly_reports, "Group does not have monthly reports association"
  end
end
