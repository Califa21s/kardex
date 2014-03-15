class PageAccesController < ApplicationController
  before_action :set_page_acce, only: [:show, :edit, :update, :destroy]
   before_filter :page_acc

  # GET /page_acces
  # GET /page_acces.json
  def index
    @page_acces = PageAcce.all
  end

  # GET /page_acces/1
  # GET /page_acces/1.json
  def show
  end

  # GET /page_acces/new
  def new
    @page_acce = PageAcce.new
  end

  # GET /page_acces/1/edit
  def edit
  end

  # POST /page_acces
  # POST /page_acces.json
  def create
    @page_acce = PageAcce.new(page_acce_params.permit(:Nom, :adresse, :menu_item_id))

    respond_to do |format|
      if @page_acce.save
        format.html { redirect_to @page_acce, notice: 'Page acce was successfully created.' }
        format.json { render action: 'show', status: :created, location: @page_acce }
      else
        format.html { render action: 'new' }
        format.json { render json: @page_acce.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /page_acces/1
  # PATCH/PUT /page_acces/1.json
  def update
    respond_to do |format|
      if @page_acce.update(page_acce_params.permit(:Nom, :adresse, :menu_item_id))
        format.html { redirect_to @page_acce, notice: 'Page acce was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @page_acce.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /page_acces/1
  # DELETE /page_acces/1.json
  def destroy
    @page_acce.destroy
    respond_to do |format|
      format.html { redirect_to page_acces_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page_acce
      @page_acce = PageAcce.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_acce_params
      params[:page_acce]
    end
end
