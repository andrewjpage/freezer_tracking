class AssetAuditsController < ApplicationController
 
  def index
    @asset_audits = AssetAudit.all.paginate(:page => params[:page], :order => 'id desc')
    respond_to do |format|
      format.html
    end
  end
  
end
