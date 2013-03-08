class Movie < ActiveRecord::Base
	#March 2 HW2 Colin added:
	def Movie.get_ratings
		return ['G','PG','PG-13','R','NC-17']
	end
	#************#

end
