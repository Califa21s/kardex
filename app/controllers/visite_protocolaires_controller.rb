class VisiteProtocolairesController < ApplicationController
  before_action :set_visite_protocolaire, only: [:show, :edit, :update, :destroy]
   before_filter :page_acc 

  # GET /visite_protocolaires
  # GET /visite_protocolaires.json
  def index
   @visite_protocolaires = VisiteProtocolaire.all.includes(:type_potentiel,:type_machine)
    @visite_protocolaires=@visite_protocolaires.sort_by {|visite_protocolaire| [visite_protocolaire.type_machine.Nom_constructeur,visite_protocolaire.type_machine.type_machine]}
  end

  # GET /visite_protocolaires/1
  # GET /visite_protocolaires/1.json
  def show
  end

  # GET /visite_protocolaires/new
  def new
    @visite_protocolaire = VisiteProtocolaire.new
  end

  # GET /visite_protocolaires/1/edit
  def edit
  end

  # POST /visite_protocolaires
  # POST /visite_protocolaires.json
  def create
    @visite_protocolaire = VisiteProtocolaire.new(visite_protocolaire_params)

    respond_to do |format|
      if @visite_protocolaire.save
        format.html { redirect_to @visite_protocolaire, notice: 'Visite protocolaire was successfully created.' }
        format.json { render action: 'show', status: :created, location: @visite_protocolaire }
      else
        format.html { render action: 'new' }
        format.json { render json: @visite_protocolaire.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /visite_protocolaires/1
  # PATCH/PUT /visite_protocolaires/1.json
  def update
    respond_to do |format|
      if @visite_protocolaire.update(visite_protocolaire_params)
        format.html { redirect_to @visite_protocolaire, notice: 'Visite protocolaire was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @visite_protocolaire.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /visite_protocolaires/1
  # DELETE /visite_protocolaires/1.json
  def destroy
    @visite_protocolaire.destroy
    respond_to do |format|
      format.html { redirect_to visite_protocolaires_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_visite_protocolaire
      @visite_protocolaire = VisiteProtocolaire.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def visite_protocolaire_params
      params[:visite_protocolaire].permit(:idtype_potentiel,:valeur_potentiel,:idtype_machine,:Nom,:tolerance,:potentiel_variable,:commentaire)
    end
end
