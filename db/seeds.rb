# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

group_one = Group.create(
                        title: "Group A"
                      )

group_two = Group.create(
                        title: "Group B"
                      )

mentor = Mentor.create(
                  first_name: "BabySitter",
                  middle_name: "For",
                  last_name: "Group A && B",
                )

group_mentors = GroupMentor.create(
                               group_id: group_one.id,
                               mentor_id:  mentor.id,
                             )

group_mentors = GroupMentor.create(
                               group_id: group_two.id,
                               mentor_id:  mentor.id,
                             )

childrens = 15.times do |i|
                      Child.create(
                        first_name: "Child #{ i }",
                        middle_name: "From",
                        last_name: "Group A",
                        account_number: rand(100_000..999_999),
                        group_id: group_one.id,
                        active: true
                      )
                    end

childrens = 15.times do |i|
                      Child.create(
                        first_name: "Child #{ i }",
                        middle_name: "From",
                        last_name: "Group B",
                        account_number: rand(100_000..999_999),
                        group_id: group_two.id,
                        active: true
                      )
                    end
