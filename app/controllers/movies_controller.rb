class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #if session==nil
    #  session=Hash.new
    #end
    #session.clear
    @all_ratings=Movie.get_ratings
    if params[:ratings] != nil
      session[:ratings] = params[:ratings]
      @ratings_checked=params[:ratings].keys
    else
      if session[:ratings] != nil
        @ratings_checked=session[:ratings].keys
      else
        @ratings_checked=@all_ratings
      end
    end
    @checked_ratings_hash=params[:ratings]
    if params[:sort]=="title"
      @movies=Movie.where(:rating => @ratings_checked).order("title")
      @hilite_title="hilite"
      session[:sort]=params[:sort]
    elsif params[:sort]=="release_date"
      @movies=Movie.where(:rating => @ratings_checked).order("release_date")
      @hilite_release="hilite"
      session[:sort]=params[:sort]
    else
      if session[:sort] != nil
        @movies = Movie.where(:rating => @ratings_checked).order(session[:sort])
      else
        @movies = Movie.where(:rating => @ratings_checked)
      end
    end

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
