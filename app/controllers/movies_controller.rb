class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #@movies = Movie.find(:all, :order => params[:sort])
    if params[:sort] == "title ASC" 
      @title_hilite = "hilite" #setting the title header to hilite if clicked
    elsif params[:sort] == "release_date ASC" 
      @rd_hilite = "hilite" #setting the release date header to hilite if clicked
    end

    @all_ratings = ['G', 'PG', 'PG-13', 'R']
    @selected_ratings = @all_ratings

    flash[:ratings] = params[:ratings].keys if params[:ratings] != nil
    @selected_ratings = flash[:ratings] if flash[:ratings] != nil
    @movies = Movie.find_all_by_rating(@selected_ratings, :order => params[:sort])
  end

  def show
    id = params[:id]
    @movie = Movie.find(id)
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
