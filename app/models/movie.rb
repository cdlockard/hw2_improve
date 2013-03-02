class Movie < ActiveRecord::Base
	def Movie.get_ratings
		return ['G','PG','PG-13','R','NC-17']
	end

end
