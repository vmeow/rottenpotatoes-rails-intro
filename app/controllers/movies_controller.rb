class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    if params[:ratings_] != nil
      @checks = params[:ratings_]
      session[:ratings_] = params[:ratings_]
    elsif session[:ratings_] != nil
      @checks = session[:ratings_]
    end
    
    if params[:sort] != nil
      sort = params[:sort]
      session[:sort] = params[:sort]
    elsif params[:sort] == nil and session[:sort] != nil
      flash.keep
      redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
    elsif session[:sort] != nil
      sort = session[:sort]
    end
    
    case sort
    when 'title'
      @title_header = 'hilite'
      if @checks != nil
        @movies = Movie.where('rating': @checks.keys).order(:title)
      else
        @movies = Movie.order(:title)
      end
    when 'release_date'
      @date_header = 'hilite'
      if @checks != nil
        @movies = Movie.where('rating': @checks.keys).order(:release_date)
      else
        @movies = Movie.order(:release_date)
      end
    when nil
      if @checks != nil
        @movies = Movie.where('rating': @checks.keys)
      else
        @movies = Movie.all
      end
    end
  end

  def new
    # default: render 'new' template
    session[:ratings] = {'G':1,'PG':1,'PG-13':1,'R':1}
    @checks = {'G':1,'PG':1,'PG-13':1,'R':1}
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

end
