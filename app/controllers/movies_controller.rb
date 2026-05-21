class MoviesController < ApplicationController
  def index
    @movies = Movie.all
  end

  private

  def set_movie
    @movie = Movie.find(params[:id])
  end
end
