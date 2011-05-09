class BuildingAreas::AdminsController < ApplicationController
  before_filter :admin_login_required
 
  def index
    @building_areas = BuildingArea.all

    respond_to do |format|
      format.html
    end
  end

  
  def show
    @building_area = BuildingArea.find(params[:id], :include => [:freezers])

    respond_to do |format|
      format.html
    end
  end

  
  def new
    @building_area = BuildingArea.new

    respond_to do |format|
      format.html
    end
  end


  def edit
    @building_area = BuildingArea.find(params[:id])
  end


  def create
    @building_area = BuildingArea.new(params[:building_area])

    respond_to do |format|
      if @building_area.save
        format.html { redirect_to(@building_area, :notice => 'Building area was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

 
  def update
    @building_area = BuildingArea.find(params[:id])

    respond_to do |format|
      if @building_area.update_attributes(params[:building_area])
        format.html { redirect_to(@building_area, :notice => 'Building area was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  
  def destroy
    @building_area = BuildingArea.find(params[:id])
    @building_area.destroy

    respond_to do |format|
      format.html { redirect_to(building_areas_url) }
    end
  end
end
