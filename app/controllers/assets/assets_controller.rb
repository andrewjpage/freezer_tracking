class Assets::AssetsController < ApplicationController
 
  def index
    @assets = Asset.all.paginate(:page => params[:page])
    respond_to do |format|
      format.html
    end
  end

  
  def show
    @asset = Asset.find(params[:id])
    @assets = @asset.contained_assets.paginate(:page => params[:page])

    respond_to do |format|
      format.html
    end
  end
  
  def assets_spreadsheet
     asset = Asset.find(params[:id])
     
     send_data( AssetReport.generate(asset.contained_assets), :type => "text/plain",
     :filename=>"contained_assets_for_asset_#{asset.id}.csv",
     :disposition => 'attachment')
  end
  
end
