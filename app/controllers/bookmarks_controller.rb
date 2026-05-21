class BookmarksController < ApplicationController
  before_action :set_bookmark, only: %i[ destroy ]

  def create
    @list = List.find(params[:list_id])
    @movies_ids = params["bookmark"]["movie_ids"].reject(&:blank?)
    @movies_ids.each do |movie_id|
      Bookmark.find_or_create_by!(
        movie_id: movie_id,
        list: @list,
      ) do |bookmark|
        bookmark.comment = "Added from list"
      end
    end
    redirect_to list_path(@list)
  end

  def destroy
    @bookmark.destroy
    redirect_to list_path(@bookmark.list), status: :see_other
  end

  private

  def set_bookmark
    @bookmark = Bookmark.find(params[:id])
  end

  def bookmark_params
    params.require(:bookmark).permit(:comment, movie_ids: [])
  end
end
