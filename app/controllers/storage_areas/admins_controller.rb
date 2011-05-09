class StorageAreas::AdminsController < ApplicationController
  before_filter :admin_login_required
 
  def index
    @storage_areas = StorageArea.all

    respond_to do |format|
      format.html
    end
  end

  
  def show
    @storage_area = StorageArea.find(params[:id], :include => [:freezers])

    respond_to do |format|
      format.html
    end
  end

  
  def new
    @storage_area = StorageArea.new

    respond_to do |format|
      format.html
    end
  end


  def edit
    @storage_area = StorageArea.find(params[:id])
  end


  def create
    @storage_area = StorageArea.new(params[:storage_area])

    respond_to do |format|
      if @storage_area.save
        format.html { redirect_to(@storage_area, :notice => 'Storage area was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

 
  def update
    @storage_area = StorageArea.find(params[:id])

    respond_to do |format|
      if @storage_area.update_attributes(params[:storage_area])
        format.html { redirect_to(@storage_area, :notice => 'Storage area was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  
  def destroy
    @storage_area = StorageArea.find(params[:id])
    @storage_area.destroy

    respond_to do |format|
      format.html { redirect_to(storage_areas_url) }
    end
  end
end
