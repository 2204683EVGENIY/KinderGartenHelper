require "test_helper"

class ChildTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    group = groups(:group_one)
    child = Child.new(
      first_name: "Jane",
      middle_name: "Elizabeth",
      last_name: "Smith",
      account_number: 123456,
      active: true,
      group: group
    )
    assert child.valid?
  end

  test "should be invalid without a first_name" do
    group = groups(:group_one)
    child = Child.new(
      first_name: nil,
      middle_name: "Elizabeth",
      last_name: "Smith",
      account_number: 123456,
      active: true,
      group: group
    )
    assert_not child.valid?
    assert_includes child.errors[:first_name], "can't be blank"
  end

  test "should be invalid without a middle_name" do
    group = groups(:group_one)
    child = Child.new(
      first_name: "Jane",
      middle_name: nil,
      last_name: "Smith",
      account_number: 123456,
      active: true,
      group: group
    )
    assert_not child.valid?
    assert_includes child.errors[:middle_name], "can't be blank"
  end

  test "should be invalid without a last_name" do
    group = groups(:group_one)
    child = Child.new(
      first_name: "Jane",
      middle_name: "Elizabeth",
      last_name: nil,
      account_number: 123456,
      active: true,
      group: group
    )
    assert_not child.valid?
    assert_includes child.errors[:last_name], "can't be blank"
  end

  test "should be invalid without an account_number" do
    group = groups(:group_one)
    child = Child.new(
      first_name: "Jane",
      middle_name: "Elizabeth",
      last_name: "Smith",
      account_number: nil,
      active: true,
      group: group
    )
    assert_not child.valid?
    assert_includes child.errors[:account_number], "can't be blank"
  end

  test "should have a unique account_number" do
    group = groups(:group_one)
    Child.create!(
      first_name: "Jane",
      middle_name: "Elizabeth",
      last_name: "Smith",
      account_number: 123456,
      active: true,
      group: group
    )
    duplicate_child = Child.new(
      first_name: "John",
      middle_name: "Michael",
      last_name: "Doe",
      account_number: 123456,
      active: false,
      group: group
    )
    assert_not duplicate_child.valid?
    assert_includes duplicate_child.errors[:account_number], "has already been taken"
  end

  test "should be invalid without an active status" do
    group = groups(:group_one)
    child = Child.new(
      first_name: "Jane",
      middle_name: "Elizabeth",
      last_name: "Smith",
      account_number: 123456,
      active: nil,
      group: group
    )
    assert_not child.valid?
    assert_includes child.errors[:active], "is not included in the list"
  end

  test "should be invalid without a group" do
    child = Child.new(
      first_name: "Jane",
      middle_name: "Elizabeth",
      last_name: "Smith",
      account_number: 123456,
      active: true,
      group: nil
    )
    assert_not child.valid?
    assert_includes child.errors[:group], "must exist"
  end

  test "should belong to a group" do
    child = children(:child_one)
    assert_not_nil child.group
  end

  test "should have many info_about_visits" do
    child = children(:child_one)
    assert_respond_to child, :info_about_visits
  end
end
