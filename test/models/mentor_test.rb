require "test_helper"

class MentorTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    mentor = Mentor.new(
      first_name: "John",
      middle_name: "Michael",
      last_name: "Doe"
    )
    assert mentor.valid?
  end

  test "should belong to a group" do
    mentor = mentors(:mentor_one)
    assert_not_nil mentor.groups
  end

  test "should be invalid without a first_name" do
    mentor = Mentor.new(
      first_name: nil,
      middle_name: "Michael",
      last_name: "Doe"
    )
    assert_not mentor.valid?
    assert_includes mentor.errors[:first_name], "can't be blank"
  end

  test "should be invalid without a middle_name" do
    mentor = Mentor.new(
      first_name: "John",
      middle_name: nil,
      last_name: "Doe"
    )
    assert_not mentor.valid?
    assert_includes mentor.errors[:middle_name], "can't be blank"
  end

  test "should be invalid without a last_name" do
    mentor = Mentor.new(
      first_name: "John",
      middle_name: "Michael",
      last_name: nil
    )
    assert_not mentor.valid?
    assert_includes mentor.errors[:last_name], "can't be blank"
  end

  test "should have many monthly_reports" do
    mentor = mentors(:mentor_one)
    assert_respond_to mentor, :monthly_reports
  end
end
