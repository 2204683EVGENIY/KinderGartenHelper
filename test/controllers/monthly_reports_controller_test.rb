require "test_helper"

# class MonthlyReportsControllerTest < ActionDispatch::IntegrationTest
#   test "should create monthly report with correct aggregated data" do
#     group = groups(:group_one)
#     mentor = mentors(:mentor_one)
#     child1 = children(:child_one)
#     child3 = children(:child_three)
#     date = Date.new(2025, 1, 1)

#     assert_difference "MonthlyReport.count", 1 do
#       post monthly_reports_path, params: {
#         group_id: group.id,
#         mentor_id: mentor.id,
#         report_date: date
#       }
#     end

#     report = MonthlyReport.last
#     assert_redirected_to root_path

#     assert_equal group.id, report.group_id
#     assert_equal mentor, report.mentor
#     assert_equal date, report.report_date

#     # -------- Проверяем data --------
#     data = report.data
#     assert_equal 2, data.size  # child_one и child_three

#     # === Проверяем ребенка 1 ===
#     child1_data = data.find { |d| d["account_number"] == child1.account_number }
#     assert child1_data, "child_one must be present in report data"

#     assert_equal "Emily Rose Johnson", child1_data["child_name"]

#     info1 = child1_data["monthly_report_info"]

#     # По фиксту: child_one в январе 2025:
#     # 1 посещение
#     # 3 пропуска "other"
#     # 0 vacation
#     # 0 sick (reason = 0 в первом визите — это sick, но kindergarten_visited: true, значит sick НЕ должен учитываться)
#     assert_equal 1, info1["count_of_visit"]
#     assert_equal 3, info1["count_of_unvisit"]
#     assert_equal 0, info1["count_of_sick"]
#     assert_equal 0, info1["count_of_vacation"]
#     assert_equal 3, info1["count_of_other"]

#     # === Проверяем формирование массива дней ===
#     days = child1_data["monthly_report_days"]
#     assert_equal date.end_of_month.day, days.size
#     jan1 = days.first
#     assert_equal Date.new(2025, 1, 1), jan1["date"].to_date
#     assert_equal true, jan1["kindergarten_visited"]
#     assert_equal "sick", jan1["reason"]  # reason: 0 в фикстуре сохраняется как "sick"

#     # === Проверяем ребенка 3 ===
#     child3_data = data.find { |d| d["account_number"] == child3.account_number }
#     assert child3_data

#     info3 = child3_data["monthly_report_info"]

#     # У child_three: 1 пропуск по reason = "other"
#     assert_equal 0, info3["count_of_visit"]
#     assert_equal 1, info3["count_of_unvisit"]
#     assert_equal 0, info3["count_of_sick"]
#     assert_equal 0, info3["count_of_vacation"]
#     assert_equal 1, info3["count_of_other"]
#   end

#   test "back to form should be successfully" do
#     mentor = mentors(:mentor_one)
#     groups = mentor.groups

#     get correct_month_report_data_form_url

#     assert_response :success
#     assert_select "select[name='year']" do
#       assert_select "option[selected][value=?]", Date.current.year.to_s
#     end
#     assert_select "select[name='month']" do
#       assert_select "option[selected][value=?]", Date.current.month.to_s
#     end
#     assert_select "select[name='group_id']" do
#       assert_select "option[value=?]", groups.first.id
#     end
#   end

#   test "overwrite child info should be successfully" do
#     visit = info_about_visits(:visit_one_2025_01_02)

#     patch overwrite_child_info_url, params: { reason: "sick", visit_id: visit.id }

#     visit.reload

#     assert_equal false, visit.kindergarten_visited
#     assert_equal "sick", visit.reason
#   end

#   test "overwrite child info should be failed" do
#     visit = info_about_visits(:visit_one_2025_01_02)

#     patch overwrite_child_info_url, params: { reason: "some_invalid_data", visit_id: visit.id }

#     visit.reload

#     assert_equal false, visit.kindergarten_visited
#     assert_equal "other", visit.reason
#     assert_redirected_to root_path
#   end

#   test "overwrite children info should be successfully" do
#     visit_one_2025_01_02 = info_about_visits(:visit_one_2025_01_02)
#     visit_one_2025_01_03 = info_about_visits(:visit_one_2025_01_03)
#     visit_one_2025_01_04 = info_about_visits(:visit_one_2025_01_04)

#     visit_ids = [ "#{ visit_one_2025_01_02.id }", "#{ visit_one_2025_01_03.id }", "#{ visit_one_2025_01_04.id }" ]

#     patch overwrite_children_info_url, params: { commit: "sick", visit_ids: visit_ids }

#     visit_one_2025_01_02.reload
#     visit_one_2025_01_03.reload
#     visit_one_2025_01_04.reload

#     assert_equal false, visit_one_2025_01_02.kindergarten_visited
#     assert_equal "sick", visit_one_2025_01_02.reason
#     assert_equal false, visit_one_2025_01_03.kindergarten_visited
#     assert_equal "sick", visit_one_2025_01_03.reason
#     assert_equal false, visit_one_2025_01_04.kindergarten_visited
#     assert_equal "sick", visit_one_2025_01_04.reason
#   end

#   test "overwrite children info should be failed with invalid reason" do
#     visit_one_2025_01_02 = info_about_visits(:visit_one_2025_01_02)
#     visit_one_2025_01_03 = info_about_visits(:visit_one_2025_01_03)
#     visit_one_2025_01_04 = info_about_visits(:visit_one_2025_01_04)

#     visit_ids = [ "#{ visit_one_2025_01_02.id }", "#{ visit_one_2025_01_03.id }", "#{ visit_one_2025_01_04.id }" ]

#     patch overwrite_children_info_url, params: { commit: "some_invalid_data", visit_ids: visit_ids }

#     visit_one_2025_01_02.reload
#     visit_one_2025_01_03.reload
#     visit_one_2025_01_04.reload

#     assert_equal false, visit_one_2025_01_02.kindergarten_visited
#     assert_equal "other", visit_one_2025_01_02.reason
#     assert_equal false, visit_one_2025_01_03.kindergarten_visited
#     assert_equal "other", visit_one_2025_01_03.reason
#     assert_equal false, visit_one_2025_01_04.kindergarten_visited
#     assert_equal "other", visit_one_2025_01_04.reason
#     assert_redirected_to root_path
#   end

#   test "overwrite children info should be failed without info about visits" do
#     visit_ids = [ "12142", "43653", "34658" ]

#     patch overwrite_children_info_url, params: { commit: "sick", visit_ids: visit_ids }

#     assert_redirected_to root_path
#   end

#   test "correct_data_for_month_report should be successfully" do
#     get correct_data_for_month_report_url, params: { group_id: "1", month: "3", year: "2025" }

#     assert_response :success
#   end

#   test "correct_data_for_month_report should be failed without group_id" do
#     get correct_data_for_month_report_url, params: { group_id: "some_invalid_data", month: "3", year: "2025" }

#     assert_redirected_to root_path
#   end

#   test "correct_data_for_month_report should be failed without month" do
#     get correct_data_for_month_report_url, params: { group_id: "1", month: "some_invalid_data", year: "2025" }

#     assert_redirected_to root_path
#   end

#   test "correct_data_for_month_report should be failed without year" do
#     get correct_data_for_month_report_url, params: { group_id: "1", month: "3", year: "some_invalid_data" }

#     assert_redirected_to root_path
#   end

#   test "correct_data_for_month_report should be failed without group_id, month and year" do
#     get correct_data_for_month_report_url, params: { group_id: "some_invalid_data", month: "some_invalid_data", year: "some_invalid_data" }

#     assert_redirected_to root_path
#   end
# end
