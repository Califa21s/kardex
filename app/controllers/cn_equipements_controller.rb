class CnEquipementsController < ApplicationController
  before_action :set_cn_equipement, only: [:show, :edit, :update, :destroy]

  # GET /cn_equipements
  # GET /cn_equipements.json
  def index
    @cn_equipements = CnEquipement.all
     @cn_equipements=@cn_equipements.sort_by{|cn_equip| [cn_equip.type_equipement.nom_constructeur,cn_equip.type_equipement.type_equipement]}

  end

  # GET /cn_equipements/1
  # GET /cn_equipements/1.json
  def show
	@cn_docs=DocDiver.find(:all,:conditions=>["type_doc_id=2 and id_entite=?",params[:id]])
	@bs_docs=DocDiver.find(:all,:conditions=>["type_doc_id=4 and id_entite=?",params[:id]])
  end

  # GET /cn_equipements/new
  def new
    @cn_equipement = CnEquipement.new
     if !(params[:id_type_equipement].nil?) then 
		@cn_equipement.idtype_equipement=params[:id_type_equipement]
	end
     @cn_equipement.val_potentiel=0
  end

  # GET /cn_equipements/1/edit
  def edit
	@cn_docs=DocDiver.find(:all,:conditions=>["type_doc_id=2 and id_entite=?",params[:id]])
	@bs_docs=DocDiver.find(:all,:conditions=>["type_doc_id=4 and id_entite=?",params[:id]])
	@doc=DocDiver.new
	 #doc = cn équipement par défaut
	@doc.type_doc_id=2
  end

  # POST /cn_equipements
  # POST /cn_equipements.json
  def create
    @cn_equipement = CnEquipement.new(cn_equipement_params)

    respond_to do |format|
      if @cn_equipement.save
        format.html { 
		if (params[:retour].nil?) then 
			redirect_to(@cn_equipement, :notice => 'Cn équipement créée.')
		else
			#renvoi vers la page détails machine
			redirect_to url_for(:controller => 'type_equipements',:action=>"show", :id => params[:retour]), :notice => 'Cn équipement créée.'
		end
		#
		 }
        format.json { render action: 'show', status: :created, location: @cn_equipement }
      else
        format.html { render action: 'new' }
        format.json { render json: @cn_equipement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cn_equipements/1
  # PATCH/PUT /cn_equipements/1.json
  def update
    respond_to do |format|
      if @cn_equipement.update(cn_equipement_params)
        format.html { redirect_to @cn_equipement, notice: 'Cn équipement modifiée.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @cn_equipement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cn_equipements/1
  # DELETE /cn_equipements/1.json
  def destroy
    @cn_equipement.destroy
    respond_to do |format|
      format.html { redirect_to cn_equipements_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cn_equipement
      @cn_equipement = CnEquipement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cn_equipement_params
      params[:cn_equipement]
    end
end
