require "test_helper"

class MonthlyReportTest < ActiveSupport::TestCase
  setup do
    @group = groups(:group_one)
    @mentor = mentors(:mentor_one)
  end

  test "should be valid with valid attributes" do
    report = MonthlyReport.new(
      group: @group,
      mentor: @mentor,
      report_date: Date.today,
      data: { key: "value" }
    )
    assert report.valid?
  end

  test "should be invalid without a report_date" do
    report = MonthlyReport.new(
      group: @group,
      mentor: @mentor,
      data: { key: "value" }
    )
    assert_not report.valid?
    assert_includes report.errors[:report_date], "can't be blank"
  end

  test "should be invalid without data" do
    report = MonthlyReport.new(
      group: @group,
      mentor: @mentor,
      report_date: Date.today
    )
    assert_not report.valid?
    assert_includes report.errors[:data], "can't be blank"
  end

  # test "should generate files after creation" do
  #   report = MonthlyReport.create(
  #     group: @group,
  #     mentor: @mentor,
  #     report_date: Date.today,
  #     data: { key: "value" }
  #   )
  #   assert report.files.attached?
  #   assert report.files.any?
  # end

  # test "should attach a file with the correct filename and content type" do
  #   report = MonthlyReport.create(
  #     group: @group,
  #     mentor: @mentor,
  #     report_date: Date.today,
  #     data: { key: "value" }
  #   )
  #   file = report.files.first
  #   assert_equal "report_#{report.id}.xls", file.filename.to_s
  #   assert_equal "application/vnd.ms-excel", file.content_type
  # end

  # test "should allow accessing attached files" do
  #   report = MonthlyReport.create(
  #     group: @group,
  #     mentor: @mentor,
  #     report_date: Date.today,
  #     data: { key: "value" }
  #   )
  #   file = report.files.first
  #   assert file.present?
  #   assert file.download.present?
  # end
end
