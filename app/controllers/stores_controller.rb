require 'will_paginate/array'

class StoresController < ApplicationController
  # GET /stores
  # GET /stores.json
  caches_page :index, :show

  def index
    store = Store.new
    @stores = store.get_stores_by_location(params[:location])
    @stores = @stores.paginate(page: params[:page], per_page: 4) if !@stores.blank?
    @location = params[:location]
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /stores/1
  # GET /stores/1.json
  def show
    @store = Store.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @store }
    end
  end

  def setLatLng
    require 'net/http'
    stores = Store.where("lat = ? and lng = ?", 0, 0)
    stores.each do |store|
      address = "#{store.address1} #{store.address2} #{store.city} #{store.state} #{store.zip}"
      #address.gsub!(' ', '%20')
      address = Rack::Utils.escape(address)
      url = "http://maps.googleapis.com/maps/api/geocode/json?address=#{address}&sensor=false"
      url_data = Net::HTTP.get(URI.parse(url))
      json_data = JSON.parse(url_data)
      store.lat = json_data["results"][0]["geometry"]["location"]["lat"]
      store.lng = json_data["results"][0]["geometry"]["location"]["lng"]
      store.save
      sleep 1
    end
  end

  # GET /stores/new
  # GET /stores/new.json
  def new
    @store = Store.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @store }
    end
  end

  # GET /stores/1/edit
  def edit
    @store = Store.find(params[:id])
  end

  # POST /stores
  # POST /stores.json
  def create
    @store = Store.new(params[:store])

    respond_to do |format|
      if @store.save
        format.html { redirect_to @store, notice: 'Store was successfully created.' }
        format.json { render json: @store, status: :created, location: @store }
      else
        format.html { render action: "new" }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /stores/1
  # PUT /stores/1.json
  def update
    @store = Store.find(params[:id])

    respond_to do |format|
      if @store.update_attributes(params[:store])
        format.html { redirect_to @store, notice: 'Store was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stores/1
  # DELETE /stores/1.json
  def destroy
    @store = Store.find(params[:id])
    @store.destroy

    respond_to do |format|
      format.html { redirect_to stores_url }
      format.json { head :no_content }
    end
  end
end
