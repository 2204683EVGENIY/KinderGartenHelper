require "test_helper"

class SelectReportDayControllerTest < ActionDispatch::IntegrationTest
  test "should get select_day with valid params" do
    day = (Time.current.to_date + 3.days).strftime("%Y-%m-%d")

    get select_day_url, params: { day: day }
    assert_response :success
    assert_select "input#day[value=?]", day
  end

  test "should get select_day with unvalid params" do
    day = (Time.current.to_date + 3.days).strftime("%Y-%m-%d")

    get select_day_url, params: { day: "some_invalid_data#{ day }some_invalid_data" }
    assert_response :success
    assert_select "input#day[value=?]", day
  end

  test "should fallback to current day if day is invalid" do
    day = (Time.current.to_date - 1.year).strftime("%Y-%m-%d")

    get select_day_url, params: { day: day }
    assert_response :success
    assert_select "input#day[value=?]", Time.current.to_date.strftime("%Y-%m-%d")
  end

  test "should fallback to current day if day is empty" do
    get select_day_url, params: { day: "" }
    assert_response :success
    assert_select "input#day[value=?]", Time.current.to_date.strftime("%Y-%m-%d")
  end

  test "should fallback to current day if day has unvalid params" do
    get select_day_url, params: { day: "some invalid data" }
    assert_response :success
    assert_select "input#day[value=?]", Time.current.to_date.strftime("%Y-%m-%d")
  end

  test "should successfully add info about visit" do
    child = children(:child_one)
    day = Time.current.to_date.strftime("%Y-%m-%d")

    post add_info_about_visit_url, params: { child: child.id, day: day }
    visit_info = InfoAboutVisit.find_by(date: day, child_id: child.id)
    assert visit_info.present?
    assert_equal true, visit_info.kindergarten_visited
  end

  test "should add info about visit is failed without day" do
    child = children(:child_one)
    day = Time.current.to_date.strftime("%Y-%m-%d")

    post add_info_about_visit_url, params: { child: child.id }
    visit_info = InfoAboutVisit.find_by(date: day, child_id: child.id)
    assert visit_info.nil?
  end

  test "should add info about visit is failed without child" do
    child = children(:child_one)
    day = Time.current.to_date.strftime("%Y-%m-%d")

    post add_info_about_visit_url, params: { day: day }
    visit_info = InfoAboutVisit.find_by(date: day, child_id: child.id)
    assert visit_info.nil?
  end

  test "should successfully add info about skip" do
    child = children(:child_one)
    day = Time.current.to_date.strftime("%Y-%m-%d")

    post add_info_about_skip_url, params: { child: child.id, day: day }
    visit_info = InfoAboutVisit.find_by(date: day, child_id: child.id)
    assert visit_info.present?
    assert_equal false, visit_info.kindergarten_visited
    assert_equal "other", visit_info.reason
  end

  test "should add info about skip is failed without day" do
    child = children(:child_one)
    day = Time.current.to_date.strftime("%Y-%m-%d")

    post add_info_about_skip_url, params: { child: child.id }
    visit_info = InfoAboutVisit.find_by(date: day, child_id: child.id)
    assert visit_info.nil?
  end

  test "should add info about skip is failed without child" do
    child = children(:child_one)
    day = Time.current.to_date.strftime("%Y-%m-%d")

    post add_info_about_skip_url, params: { day: day }
    visit_info = InfoAboutVisit.find_by(date: day, child_id: child.id)
    assert visit_info.nil?
  end

  test "should successfully refresh info about visit" do
    child = children(:child_one)
    day = Time.current.to_date.strftime("%Y-%m-%d")

    post add_info_about_visit_url, params: { child: child.id, day: day }
    patch refresh_info_about_visit_url, params: { child: child.id, day: day }

    visit_info = InfoAboutVisit.find_by(date: day, child_id: child.id)
    assert visit_info.present?
    assert_equal false, visit_info.kindergarten_visited
    assert_equal "other", visit_info.reason
  end

  test "should successfully refresh info about skip" do
    child = children(:child_one)
    day = Time.current.to_date.strftime("%Y-%m-%d")

    post add_info_about_skip_url, params: { child: child.id, day: day }
    patch refresh_info_about_visit_url, params: { child: child.id, day: day }

    visit_info = InfoAboutVisit.find_by(date: day, child_id: child.id)
    assert visit_info.present?
    assert_equal true, visit_info.kindergarten_visited
    assert_nil(visit_info.reason)
  end

  test "expect refresh info is failed without child" do
    child = children(:child_one)
    day = Time.current.to_date.strftime("%Y-%m-%d")

    post add_info_about_skip_url, params: { child: child.id, day: day }
    patch refresh_info_about_visit_url, params: { day: day }

    visit_info = InfoAboutVisit.find_by(date: day, child_id: child.id)
    assert visit_info.present?
    assert_equal false, visit_info.kindergarten_visited
    assert_equal "other", visit_info.reason
  end

  test "expect refresh info is failed without day" do
    child = children(:child_one)
    day = Time.current.to_date.strftime("%Y-%m-%d")

    post add_info_about_visit_url, params: { child: child.id, day: day }
    patch refresh_info_about_visit_url, params: { child: child.id }

    visit_info = InfoAboutVisit.find_by(date: day, child_id: child.id)
    assert visit_info.present?
    assert_equal true, visit_info.kindergarten_visited
  end

  test "expect add info to children will be successfully create if children seted" do
    child_one = children(:child_one)
    child_two = children(:child_two)
    day = Time.current.to_date.strftime("%Y-%m-%d")

    SelectReportDayController.class_eval do
      define_method(:turbo_update) do |child, date|
      end
    end

    post add_info_to_childrens_url, params: {
      child_ids: [ "#{ child_one.id }", "#{ child_two.id }" ],
      commit: "Mark as visited",
      day: day
    }

    first_visit_info = InfoAboutVisit.find_by(date: day, child_id: child_one.id)
    second_visit_info = InfoAboutVisit.find_by(date: day, child_id: child_two.id)

    assert first_visit_info.present?
    assert_equal true, first_visit_info.kindergarten_visited
    assert_nil(first_visit_info.reason)
    assert second_visit_info.present?
    assert_equal true, second_visit_info.kindergarten_visited
    assert_nil(second_visit_info.reason)
  end

  test "expect add info to children will be successfully create if child seted" do
    child_one = children(:child_one)
    day = Time.current.to_date.strftime("%Y-%m-%d")

    SelectReportDayController.class_eval do
      define_method(:turbo_update) do |child, date|
      end
    end

    post add_info_to_childrens_url, params: {
      child_ids: [ "#{ child_one.id }" ],
      commit: "Mark as visited",
      day: day
    }

    first_visit_info = InfoAboutVisit.find_by(date: day, child_id: child_one.id)

    assert first_visit_info.present?
    assert_equal true, first_visit_info.kindergarten_visited
    assert_nil(first_visit_info.reason)
  end
end
