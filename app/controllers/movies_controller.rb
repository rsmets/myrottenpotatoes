class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

   @title_header, @release_header = nil
   @all_ratings = Movie.getratings
   @selected_ratings = @all_ratings

   if params[:commit]
     session.delete(:ratings)
     if session[:sort]
       sort = session[:sort]
       session.delete(:sort)
       rediect = true
     end
   end

   if params[:sort]
     sort = params[:sort]
   elsif session[:sort]
     sort = session[:sort]
     session.delete(:sort)
     redirect = true
     if session[:ratings]
       @ratings = session[:ratings]
       session.delete(:ratings)
     end
   end

   if params[:ratings]
     @ratings = params[:ratings]
   elsif session[:ratings]
     @ratings = session[:ratings]
     session.delete(:ratings)
     redirect = true
     if session[:sort]
       sort = session[:sort]
       session.delete(:sort)
     end
   end

   if params[:sort] == "title ASC"
     @title_hilite = "hilite" #setting the title header to hilite if clicked
   elsif params[:sort] == "release_date ASC"
     @rd_hilite = "hilite" #setting the release date header to hilite if clicked
   end
              
   if redirect
     if @ratings && sort
       redirect_to(:action => "index", :sort => sort, :ratings => @ratings)
     elsif @ratings
       redirect_to(:action => "index", :ratings => @ratings)
     elsif sort
       redirect_to(:action => "index", :sort => sort)
     else
       redirect_to(:action => "index")
     end
   end

   @selected_ratings = @ratings.keys if @ratings

   @movies = Movie.find_all_by_rating(@selected_ratings)
   @movies = Movie.find_all_by_rating(@selected_ratings, :order => sort) if sort
        
   session[:sort] = sort if sort
   session[:ratings] = @ratings if @ratings

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
