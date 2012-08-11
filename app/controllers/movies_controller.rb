class MoviesController < ApplicationController

  def initialize()
    @ratings = ["Fdsa"]
    @all_ratings = Movie.get_all_ratings()
    super
  end
  
  attr_accessor :ratings
  attr_accessor :all_ratings
  
  def refresh
    @ratings = params[:ratings]
    debugger
  end
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @ratings = []
    if params[:ratings]
      @ratings += params[:ratings].keys
      flash[:ratings] = @ratings
    elsif flash[:ratings]
      @ratings = flash[:ratings]
      flash[:ratings] = @ratings
    end
    @movies = []
    @ratings.each do |rating| 
      @movies += Movie.find(:all,:conditions => {:rating => rating})
    end
    if params[:sortby] == "Release"
      @movies.sort! { |a,b| a.release_date <=> b.release_date }
      @sort_by = :Release
      flash[:sortby] = :Release
    elsif params[:sortby] == "Title"
      @movies.sort! { |a,b| a.title.downcase <=> b.title.downcase }
      @sort_by = :Title
      flash[:sortby] = :Title
    else
      @sort_by = flash[:sortby]
      flash[:sortby] = @sort_by
    #else
    #  @sort_by = nil
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
