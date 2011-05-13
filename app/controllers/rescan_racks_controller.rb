class RescanRacksController < ApplicationController
  def index
    @assets = Asset.where( :dirty_layout => true ).paginate(:page => params[:page])
  end
end
