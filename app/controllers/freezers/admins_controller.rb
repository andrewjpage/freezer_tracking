class Freezers::AdminsController < ApplicationController
  before_filter :admin_login_required
 
  def index
    @freezers = Freezer.all

    respond_to do |format|
      format.html
    end
  end

  
  def show
    @freezer = Freezer.find(params[:id], :include => [:freezers])

    respond_to do |format|
      format.html
    end
  end

  
  def new
    @freezer = Freezer.new

    respond_to do |format|
      format.html
    end
  end


  def edit
    @freezer = Freezer.find(params[:id])
  end


  def create
    @freezer = Freezer.new(params[:freezer])

    respond_to do |format|
      if @freezer.save
        format.html { redirect_to(@freezer, :notice => 'Freezer was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

 
  def update
    @freezer = Freezer.find(params[:id])

    respond_to do |format|
      if @freezer.update_attributes(params[:freezer])
        format.html { redirect_to(@freezer, :notice => 'Freezer was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  
  def destroy
    @freezer = Freezer.find(params[:id])
    @freezer.destroy

    respond_to do |format|
      format.html { redirect_to(freezers_url) }
    end
  end
end
