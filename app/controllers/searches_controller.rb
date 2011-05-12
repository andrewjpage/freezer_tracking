class SearchesController  < ApplicationController
  def new
  end
  
  def search
    @search = Search.new(params[:search])
    respond_to do |format|
      if @search.valid?
        @search.perform_search
        format.html
      else
        format.html { redirect_to( searches_path, :notice => @search.errors.full_messages.first) }
      end
    end
  end
end