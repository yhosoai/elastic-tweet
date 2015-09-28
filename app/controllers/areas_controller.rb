# require 'elasticsearch/persistence'

class AreasController < ApplicationController
  before_action :set_area, only: [:show, :edit, :update, :destroy]
  protect_from_forgery :except => :refresh_tweets

  # GET /areas
  # GET /areas.json
  def index
    @areas = Area.all
  end

  # GET /areas/1
  # GET /areas/1.json
  def show
    # repository = Elasticsearch::Persistence::Repository.new
    # repository.search(query: { match: { text: 'test' } }).first

    @tweets = Tweet.showTweetsInArea(@area)
    
  end
  def refresh_tweets
    @area = Area.find(params[:id])
    hashtag = params[:hashtag]
    @tweets = Tweet.showTweetsInArea(@area,hashtag)

    respond_to do |format|
      format.js { render :partial => '/tweets/refresh_tweets', :status => 200 }
    end
  end
  
  
  # GET /areas/new
  def new
    @area = Area.new
  end

  # GET /areas/1/edit
  def edit
  end

  # POST /areas
  # POST /areas.json
  def create
    @area = Area.new(area_params)

    respond_to do |format|
      if @area.save
        format.html { redirect_to @area, notice: 'Area was successfully created.' }
        format.json { render :show, status: :created, location: @area }
      else
        @existing_area = Area.find_lat_lon(@area)
        
        if(@existing_area)
          format.html { redirect_to @existing_area, notice: 'Area already existed' }
          format.json { render :show, status: :found, location: @location }
        else
          format.html { render :new }
          format.json { render json: @area.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /areas/1
  # PATCH/PUT /areas/1.json
  def update
    respond_to do |format|
      if @area.update(area_params)
        format.html { redirect_to @area, notice: 'Area was successfully updated.' }
        format.json { render :show, status: :ok, location: @area }
      else
        format.html { render :edit }
        format.json { render json: @area.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /areas/1
  # DELETE /areas/1.json
  def destroy
    @area.destroy
    respond_to do |format|
      format.html { redirect_to areas_url, notice: 'Area was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_area
      @area = Area.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def area_params
      params.require(:area).permit(:latitude, :longitude, :radius)
    end
end
