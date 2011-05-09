class Assets::AdminsController < ApplicationController
  before_filter :admin_login_required
 
  def index
    @assets = Asset.all

    respond_to do |format|
      format.html
    end
  end

  
  def show
    @asset = Asset.find(params[:id], :include => [:freezers])

    respond_to do |format|
      format.html
    end
  end

  
  def new
    @asset = Asset.new

    respond_to do |format|
      format.html
    end
  end


  def edit
    @asset = Asset.find(params[:id])
  end


  def create
    @asset = Asset.new(params[:asset])

    respond_to do |format|
      if @asset.save
        format.html { redirect_to(@asset, :notice => 'Asset was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

 
  def update
    @asset = Asset.find(params[:id])

    respond_to do |format|
      if @asset.update_attributes(params[:asset])
        format.html { redirect_to(@asset, :notice => 'Asset was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  
  def destroy
    @asset = Asset.find(params[:id])
    @asset.destroy

    respond_to do |format|
      format.html { redirect_to(assets_url) }
    end
  end
end
