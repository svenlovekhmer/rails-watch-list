class BookmarksController < ApplicationController
  before_action :set_bookmark, only: %i[ destroy ]

  def create
    @list = List.find(params[:list_id])
    # Cas 1 : plusieurs films depuis la modale
    if params[:bookmark][:movie_ids]
      movie_ids = params[:bookmark][:movie_ids].reject(&:blank?)
    # Cas 2 : un seul film depuis les tests
    elsif params[:bookmark][:movie_id]
      movie_ids = [ params[:bookmark][:movie_id] ]
    # Cas 3 : rien envoyé
    else
      movie_ids = []
    end
    movie_ids.each do |movie_id|
    params[:bookmark][:comment].presence ? comment = params[:bookmark][:comment] : comment = "Added from list"
      @bookmark = Bookmark.new(
        movie_id: movie_id,
        list: @list,
        comment: comment
      )
      if @bookmark.save
        redirect_to list_path(@list)
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def destroy
    @bookmark.destroy
    redirect_to list_path(@bookmark.list), status: :see_other
  end

  def new
    @list = List.find(params[:list_id])
    @bookmark = Bookmark.new
    @bookmark.list = @list
  end

  private

  def set_bookmark
    @bookmark = Bookmark.find(params[:id])
  end

  def bookmark_params
    params.require(:bookmark).permit(:comment, movie_ids: [])
  end
end
