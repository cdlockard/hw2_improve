class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    #March 5, HW2: Colin added session hash information:
    #Check to see if params has data. If it is missing one or more items that are
    #saved in sessions hash, pass sessions info into params and reload
    if (params[:ratings]==nil and session[:ratings]!=nil) or (params[:sort]==nil and session[:sort]!=nil)
      if params[:ratings]==nil and session[:ratings] != nil
        params[:ratings]=session[:ratings]
      end
      if params[:sort]==nil and session[:sort] !=nil
        params[:sort]=session[:sort]
      end
      flash.keep #preserve flash values
      redirect_to movies_path :ratings=>params[:ratings], :sort=>params[:sort]
    end
    #*----------*#

    #March 2 HW2, Colin added @all_ratings
    @all_ratings=Movie.get_ratings #get list of all ratings
    if params[:ratings] != nil #if user has previously selected certain ratings, add to session and populate checkboxes
      session[:ratings] = params[:ratings]
      @ratings_checked=params[:ratings].keys
    else #otherwise, if no value in params(meaning user either hasn't made a selection or has deselected all), check all boxes
      @ratings_checked=@all_ratings
    end
    #*----------*#

    #March 2 HW2, Colin added @checked_ratings_hash
    @checked_ratings_hash=params[:ratings]
    #*----------*#

    #Feb 28 HW2, Colin added sorting by title/release date and hiliting:
    #March 2 HW2, added filtering by ratings:
    if params[:sort]=="title"
      @movies=Movie.where(:rating => @ratings_checked).order("title")
      @hilite_title="hilite"
      #March 4 added session population:
      session[:sort]=params[:sort]
      #*---------*#
    elsif params[:sort]=="release_date"
      @movies=Movie.where(:rating => @ratings_checked).order("release_date")
      @hilite_release="hilite"
      #March 4 added session population:
      session[:sort]=params[:sort]
      #*---------*#
    else
      @movies = Movie.where(:rating => @ratings_checked)
    end
    #*----------*#
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end