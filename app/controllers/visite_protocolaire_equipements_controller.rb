class VisiteProtocolaireEquipementsController < ApplicationController
  before_action :set_visite_protocolaire_equipement, only: [:show, :edit, :update, :destroy]
  before_filter :page_acc 
  # GET /visite_protocolaire_equipements
  # GET /visite_protocolaire_equipements.json
  def index
    @visite_protocolaire_equipements = VisiteProtocolaireEquipement.all
     @visite_protocolaire_equipements =@visite_protocolaire_equipements.sort_by {|visite| [visite.type_equipement.nom_constructeur,visite.type_equipement.type_equipement ]}

  end

  # GET /visite_protocolaire_equipements/1
  # GET /visite_protocolaire_equipements/1.json
  def show
  end

  # GET /visite_protocolaire_equipements/new
  def new
    @visite_protocolaire_equipement = VisiteProtocolaireEquipement.new
  end

  # GET /visite_protocolaire_equipements/1/edit
  def edit
  end

  # POST /visite_protocolaire_equipements
  # POST /visite_protocolaire_equipements.json
  def create
    @visite_protocolaire_equipement = VisiteProtocolaireEquipement.new(visite_protocolaire_equipement_params.permit(:idtype_potentiel,:valeur_potentiel,:idtype_equipement,:Nom,:tolerance,:commentaire))

    respond_to do |format|
      if @visite_protocolaire_equipement.save
        format.html { redirect_to @visite_protocolaire_equipement, notice: 'la Visite protocolaire équipement a été créé.' }
        format.json { render action: 'show', status: :created, location: @visite_protocolaire_equipement }
      else
        format.html { render action: 'new' }
        format.json { render json: @visite_protocolaire_equipement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /visite_protocolaire_equipements/1
  # PATCH/PUT /visite_protocolaire_equipements/1.json
  def update
    respond_to do |format|
      if @visite_protocolaire_equipement.update(visite_protocolaire_equipement_paramspermit(:idtype_potentiel,:valeur_potentiel,:idtype_equipement,:Nom,:tolerance,:commentaire))
        format.html { redirect_to @visite_protocolaire_equipement, notice: 'la Visite protocolaire équipement a été mis à jour.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @visite_protocolaire_equipement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /visite_protocolaire_equipements/1
  # DELETE /visite_protocolaire_equipements/1.json
  def destroy
    @visite_protocolaire_equipement.destroy
    respond_to do |format|
      format.html { redirect_to visite_protocolaire_equipements_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_visite_protocolaire_equipement
      @visite_protocolaire_equipement = VisiteProtocolaireEquipement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def visite_protocolaire_equipement_params
      params[:visite_protocolaire_equipement]
    end
end
