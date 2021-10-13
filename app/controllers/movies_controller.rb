class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.all_ratings
    if params["ratings"].nil? and params["sort"].nil? and (session["ratings"] or session["sort"])
      redirect_to movies_path("ratings": params["ratings"], "sort": params["sort"])
    end
    if session.has_key?(:visited_before)
      ratings = params["ratings"] || session["ratings"]
      if ratings.nil?
        @ratings_to_show = []
        @movies = Movie.with_ratings(ratings)
      else
        @ratings_to_show = ratings.keys
        @movies = Movie.with_ratings(ratings.keys)
      end
      sort = params["sort"] || session["sort"]
      
      if sort != nil
        @movies = @movies.order(sort)
        if sort == "title"
          @title = "hilite bg-warning"
        else
          @rd = "hilite bg-warning"
        end
      end
    else
      @ratings_to_show = @all_ratings
      session[:visited_before] = true
    end
    session["ratings"] = ratings
    session["sort"] = sort
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
