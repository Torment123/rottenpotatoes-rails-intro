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
    # @movies = Movie.order(params[:sort])
    
    # @all_ratings = Movie.uniq.pluck(:rating)
    
    # if params[:ratings].nil?
      # @movies = Movie.order(params[:sort])
    # else
      # @movies = Movie.where(rating: params[:ratings].keys).order(params[:sort])
    # end
  
    
    # @filtered_keys = params[:ratings].keys
    # @movies = Movie.where(:rating => @filtered_keys)
    
    if session[:ratings].nil?
      session[:ratings] = Movie.uniq.pluck(:rating)
    end
    
    if params[:ratings].nil?
      flash.keep
      redirect_to movies_path(:ratings => session[:ratings],:sort => params[:sort])
    
    elsif params[:sort].nil? && !session[:sort].nil?
      flash.keep
      redirect_to movies_path(:ratings => params[:ratings], :sort => session[:sort])
    else
      session[:sort] = params[:sort]
      session[:ratings] = params[:ratings].keys
    
      @movies = Movie.where(rating: session[:ratings]).order(params[:sort]])
    end
    
    
    
    
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

end
