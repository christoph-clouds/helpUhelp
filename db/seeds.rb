# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Role.create(title: "admin")
Role.create(title: "volunteer")
Status.create(title: "pending")
Status.create(title: "declined")
Status.create(title: "confirmed")
r = Role.find(1)
User.create(role: r, first_name: "admin", last_name: "admin", email: "admin@admin.at", telephone: "1234", password: "admin")

