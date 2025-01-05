require "test_helper"

class MentorTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    group = groups(:group_one)
    mentor = Mentor.new(
      first_name: "John",
      middle_name: "Michael",
      last_name: "Doe",
      group: group
    )
    assert mentor.valid?
  end

  test "should belong to a group" do
    mentor = mentors(:mentor_one)
    assert_not_nil mentor.group
  end

  test "should be invalid without a first_name" do
    group = groups(:group_one)
    mentor = Mentor.new(
      first_name: nil,
      middle_name: "Michael",
      last_name: "Doe",
      group: group
    )
    assert_not mentor.valid?
    assert_includes mentor.errors[:first_name], "can't be blank"
  end

  test "should be invalid without a middle_name" do
    group = groups(:group_one)
    mentor = Mentor.new(
      first_name: "John",
      middle_name: nil,
      last_name: "Doe",
      group: group
    )
    assert_not mentor.valid?
    assert_includes mentor.errors[:middle_name], "can't be blank"
  end

  test "should be invalid without a last_name" do
    group = groups(:group_one)
    mentor = Mentor.new(
      first_name: "John",
      middle_name: "Michael",
      last_name: nil,
      group: group
    )
    assert_not mentor.valid?
    assert_includes mentor.errors[:last_name], "can't be blank"
  end

  test "should be invalid without a group" do
    mentor = Mentor.new(
      first_name: "John",
      middle_name: "Michael",
      last_name: "Doe",
      group: nil
    )
    assert_not mentor.valid?
    assert_includes mentor.errors[:group], "must exist"
  end

  test "should have many monthly_reports" do
    mentor = mentors(:mentor_one)
    assert_respond_to mentor, :monthly_reports
  end
end
