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
end
