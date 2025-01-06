require "test_helper"

class InfoAboutVisitTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    child = children(:child_one)
    visit = InfoAboutVisit.new(
      child: child,
      date: Date.today,
      kindergarten_visited: false,
      reason: "sick"
    )
    assert visit.valid?
  end

  test "should be invalid without a child" do
    visit = InfoAboutVisit.new(
      child: nil,
      date: Date.today,
      kindergarten_visited: false,
      reason: "sick"
    )
    assert_not visit.valid?
    assert_includes visit.errors[:child], "must exist"
  end

  test "should be invalid without a date" do
    child = children(:child_one)
    visit = InfoAboutVisit.new(
      child: child,
      date: nil,
      kindergarten_visited: true
    )
    assert_not visit.valid?
    assert_includes visit.errors[:date], "can't be blank"
  end

  test "should be invalid without kindergarten_visited" do
    child = children(:child_one)
    visit = InfoAboutVisit.new(
      child: child,
      date: Date.today,
      kindergarten_visited: nil,
      reason: "sick"
    )
    assert_not visit.valid?
    assert_includes visit.errors[:kindergarten_visited], "is not included in the list"
  end

  test "should be valid without reason" do
    child = children(:child_two)
    visit = InfoAboutVisit.new(
      child: child,
      date: Date.today,
      kindergarten_visited: true,
      reason: nil
    )
    assert visit.valid?
  end

  test "should be invalid with an invalid reason" do
    child = children(:child_one)
    visit = InfoAboutVisit.new(
      child: child,
      date: Date.today,
      kindergarten_visited: false,
      reason: "invalid_reason"
    )
    assert_not visit.valid?
    assert_includes visit.errors[:reason], "'invalid_reason' is not a valid reason"
  end

  test "should have valid enum values for reason" do
    assert_equal "sick", InfoAboutVisit.reasons.key(0)
    assert_equal "vacation", InfoAboutVisit.reasons.key(1)
    assert_equal "other", InfoAboutVisit.reasons.key(2)
  end

  test "should belong to a child" do
    visit = info_about_visits(:visit_one)
    assert_not_nil visit.child
  end
end
