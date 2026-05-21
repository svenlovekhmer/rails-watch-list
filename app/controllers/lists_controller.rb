class ListsController < ApplicationController
  before_action :set_list, only: %i[ edit show update destroy]
  def index
    @lists = List.all
  end

  def new
    @list = List.new
  end

  def create
    @list = List.new(list_params)
    if @list.save!
      redirect_to lists_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # @bookmark = Bookmark.new
  end

  def show
    @bookmarks = @list.bookmarks
    @bookmark = Bookmark.new
    @available_movies = Movie.where.not(id: @list.movies.pluck(:id))
  end

  def update
    @list.update(list_params)
    redirect_to lists_path
  end

  def destroy
    @list.destroy
    redirect_to lists_path, status: :see_other
  end

  private

  def list_params
    params.require(:list).permit(:name)
  end

  def set_list
    @list = List.find(params[:id])
  end
end
