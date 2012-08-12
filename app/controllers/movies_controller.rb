class MoviesController < ApplicationController

  def initialize()
    @ratings = {}
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
    @ratings = {}
    if params[:ratings] or params[:sortby]
      session.clear
    elsif params.keys
      if (!params.keys.include?(:ratings) and !params.keys.include?(:sortby)) and ((session[:ratings] and !session[:ratings].empty?) or (session[:sortby] and !session[:sortby].empty?))
        flash.keep
        redirect_to movies_path(:sortby => session[:sortby], :ratings => session[:ratings])
      end
    end
    if params[:ratings]
      @ratings = params[:ratings]
      session[:ratings] = @ratings
    elsif params[:commit] != "Refresh" and session[:ratings]
      @ratings = session[:ratings]
      session[:ratings] = @ratings
    end
    @movies = []
    @ratings.keys.each do |rating| 
      @movies += Movie.find(:all,:conditions => {:rating => rating})
    end
    @sort_by = session[:sortby]
    session[:sortby] = @sort_by
    if params[:sortby]
      @sort_by = params[:sortby].to_sym
      session[:sortby] = @sort_by
    end
    if @sort_by == :Release
      @movies.sort! { |a,b| a.release_date <=> b.release_date }
    elsif @sort_by == :Title
      @movies.sort! { |a,b| a.title.downcase <=> b.title.downcase }
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
