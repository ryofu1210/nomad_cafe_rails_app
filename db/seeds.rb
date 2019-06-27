# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

TABLES = %w(favorites stores users)
ActiveRecord::Base.connection.execute("select * from users;");
TABLES.each do |table_name|
  User.connection.execute("TRUNCATE TABLE #{table_name} CASCADE;")
end

ActiveRecord::Base.transaction do
	2.times do |i|
	  user = User.create(
        nickname: "test #{i}",
        profile: "プロフィールプロフィールプロフィール",
	      email: "test#{i}@example.com",
	      password: "password",
	      password_confirmation: "password",
	      confirmed_at: Time.now
	  )
		
	  2.times do |j|
	    store = Store.create(
        name: "name #{j}",
        long_stay: 1,
        consent: true,
        wifi: true,
        wifi_description: "Wi2/Wi2_club",
        comment: "コメントコメントコメントコメントコメントコメント",
        user: user,
        status: 0
			)

			Favorite.create(
				user: user,
				store: store
			)
	  end
	end
end