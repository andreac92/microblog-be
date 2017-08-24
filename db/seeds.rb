# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create(email: 'user@lol.com', name: 'Jane Doe', password: 'netlify123', site_id: 'b3669d12-5cdc-470b-a225-55a2fbbc4354')
user.posts.create(content: 'Test post!!')