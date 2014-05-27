class SoilApplicationsController < ApplicationController

  def index
    get_soil_applications
    @application  = SoilApplication.new
  end

  def create
    @application = field.soil_applications.build(soil_app_params)
    parse_date
    if @application.save
      flash[:success] = "Soil Application successfully saved."
      redirect_to soil_applications_path
    else
     get_soil_applications
     render :index
    end
  end

  def edit
    get_soil_applications
    @application = SoilApplication.find(params[:id])
    render :index
  end

  def update
    @application = SoilApplication.find(params[:id])
    parse_date
    @application.field_id = field.id
    if @application.update_attributes(soil_app_params)
      flash[:success] = "Soil Application successfully updated."
      redirect_to soil_applications_path
    else
      get_soil_applications
      render :index
    end
  end

  private

    def get_soil_applications
      @applications = SoilApplication.order("date DESC")
    end

    def soil_app_params
      params[:soil_application].except(:field_id)
    end

    def field
      Field.find(params[:soil_application][:field_id])
    end

    def parse_date
     # @application.date = "01/08/2014"
    end
end