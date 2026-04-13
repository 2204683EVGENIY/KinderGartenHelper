# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

user = User.find_by(email_address: "galinavologzhanina2@gmail.com")
mentor = Mentor.find_by(user: user)
group = Group.create(title: "Фантазёры")
GroupMentor.create(group: group, mentor: mentor)
Child.create(
  group: group,
  first_name: "Альбрехт",
  middle_name: "Марьяна",
  last_name: "Андреевна",
  active: true
)
Child.create(
  group: group,
  first_name: "Бердизода",
  middle_name: "Алиса",
  last_name: "Илёс",
  active: true
)
Child.create(
  group: group,
  first_name: "Биримкулов",
  middle_name: "Алихан",
  last_name: "Аргенович",
  active: true
)
Child.create(
  group: group,
  first_name: "Бородавко",
  middle_name: "Егор",
  last_name: "Денисович",
  active: true
)
Child.create(
  group: group,
  first_name: "Величко",
  middle_name: "Екатерина",
  last_name: "Яновна",
  active: true
)
Child.create(
  group: group,
  first_name: "Городницкий",
  middle_name: "Пётр",
  last_name: "Андреевич",
  active: true
)
Child.create(
  group: group,
  first_name: "Копнов",
  middle_name: "Константин",
  last_name: "Алексеевич",
  active: true
)
Child.create(
  group: group,
  first_name: "Мещеряков",
  middle_name: "Платон",
  last_name: "Дмитриевич",
  active: true
)
Child.create(
  group: group,
  first_name: "Мурашов",
  middle_name: "Максим",
  last_name: "Дмитриевич",
  active: true
)
Child.create(
  group: group,
  first_name: "Ороспеков",
  middle_name: "Райымкул",
  last_name: "Акжолович",
  active: true
)
Child.create(
  group: group,
  first_name: "Пастухов",
  middle_name: "Вячеслав",
  last_name: "Евгеньевич",
  active: true
)
Child.create(
  group: group,
  first_name: "Патрашин",
  middle_name: "Тимур",
  last_name: "Мухаммедович",
  active: true
)
Child.create(
  group: group,
  first_name: "Передерин",
  middle_name: "Марк",
  last_name: "Иванович",
  active: true
)
Child.create(
  group: group,
  first_name: "Пулоти",
  middle_name: "Умаршох",
  last_name: "Бехруззода",
  active: true
)
Child.create(
  group: group,
  first_name: "Резанович",
  middle_name: "Любовь",
  last_name: "Дмитриевна",
  active: true
)
Child.create(
  group: group,
  first_name: "Решаева",
  middle_name: "Сафина",
  last_name: "Ихтиёржоновна",
  active: true
)
Child.create(
  group: group,
  first_name: "Ситкенская",
  middle_name: "Камила",
  last_name: "",
  active: true
)
Child.create(
  group: group,
  first_name: "Сохадшозода",
  middle_name: "Оиша",
  last_name: "Джахонбек",
  active: true
)
Child.create(
  group: group,
  first_name: "Султанзода",
  middle_name: "Алиса",
  last_name: "",
  active: true
)
Child.create(
  group: group,
  first_name: "Хан",
  middle_name: "Арслан",
  last_name: "Эргашович",
  active: true
)
Child.create(
  group: group,
  first_name: "Часовщикова",
  middle_name: "Вероника",
  last_name: "Николаевна",
  active: true
)
Child.create(
  group: group,
  first_name: "Черняков",
  middle_name: "Максим",
  last_name: "Алексеевич",
  active: true
)
Child.create(
  group: group,
  first_name: "Чёрный",
  middle_name: "Даниил",
  last_name: "Вадимович",
  active: true
)
Child.create(
  group: group,
  first_name: "Шодиев",
  middle_name: "Аюб",
  last_name: "Межрожджонович",
  active: true
)
Child.create(
  group: group,
  first_name: "Умханов",
  middle_name: "Амир",
  last_name: "",
  active: true
)
Child.create(
  group: group,
  first_name: "Тимирбоева",
  middle_name: "Ляйсан",
  last_name: "",
  active: true
)
