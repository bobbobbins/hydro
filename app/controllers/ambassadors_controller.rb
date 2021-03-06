class AmbassadorsController < ApplicationController
  # GET /ambassadors
  # GET /ambassadors.json
  caches_page :index, :show, :list

  def index
    @ambassadors = Ambassador.all
    @page = Page.find(19)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ambassadors }
    end
  end

  def list
    @ambassadors = Ambassador.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /ambassadors/1
  # GET /ambassadors/1.json
  def show
    @ambassador = Ambassador.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ambassador }
    end
  end

  # GET /ambassadors/new
  # GET /ambassadors/new.json
  def new
    @ambassador = Ambassador.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ambassador }
    end
  end

  # GET /ambassadors/1/edit
  def edit
    @ambassador = Ambassador.find(params[:id])
  end

  # POST /ambassadors
  # POST /ambassadors.json
  def create
    @ambassador = Ambassador.new(params[:ambassador])

    respond_to do |format|
      if @ambassador.save
        format.html { redirect_to @ambassador, notice: 'Ambassador was successfully created.' }
        format.json { render json: @ambassador, status: :created, location: @ambassador }
      else
        format.html { render action: "new" }
        format.json { render json: @ambassador.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ambassadors/1
  # PUT /ambassadors/1.json
  def update
    @ambassador = Ambassador.find(params[:id])

    respond_to do |format|
      if @ambassador.update_attributes(params[:ambassador])
        format.html { redirect_to @ambassador, notice: 'Ambassador was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @ambassador.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ambassadors/1
  # DELETE /ambassadors/1.json
  def destroy
    @ambassador = Ambassador.find(params[:id])
    @ambassador.destroy

    respond_to do |format|
      format.html { redirect_to ambassadors_url }
      format.json { head :no_content }
    end
  end
end
