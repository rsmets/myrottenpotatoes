class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    
     if params[:commit]
       session.delete(:ratings)
       if session[:sort]
         sort = session[:sort]
         session.delete(:sort)
         redirect_to(:action => "index", :sort => sort)
       else
         redirect_to(:action => "index")
       end
     end

     if params[:sort]
       sort = params[:sort]
     elsif session[:sort]
       sort = session[:sort]
       session.delete(:sort)
       if session[:ratings]
         @ratings = session[:ratings]
         session.delete(:ratings)
         redirect_to(:action => "index", :sort => sort, :ratings => @ratings)
       else
         redirect_to(:action => "index", :sort => sort)
       end
     end

    if params[:ratings]
      @ratings = params[:ratings]
    elsif session[:ratings]
      @ratings = session[:ratings]
      session.delete(:ratings)
      if session[:sort]
        sort = session[:sort]
        session.delete(:sort)
        redirect_to(:action => "index", :sort => sort, :ratings => @ratings)
      else
        redirect_to(:action => "index", :ratings => @ratings)
      end
    end

    @all_ratings = []
    Movie.all.each do |movie|
      @all_ratings << movie.rating
    end
    @all_ratings.uniq!.sort!

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

    if params[:sort]
      session[:sort] = sort
   end

   if params[:ratings]
     session[:ratings] = @ratings
   end

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
