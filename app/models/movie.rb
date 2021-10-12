class Movie < ActiveRecord::Base
  @all_ratings = Movie.distinct.pluck(:rating)
end
