# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
tag_pool = FactoryBot.create_list(:tag, 10)
users = FactoryBot.create_list(:user, 5)

activities = FactoryBot.create_list(:activity, 10, tag_pool: tag_pool, user_pool:  users)

activities.each do |activity|
  FactoryBot.create_list(:comment, 5, commentable: activity)
end
