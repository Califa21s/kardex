class VisiteEquipementsController < ApplicationController
	before_action :set_visite_equipement, only: [:show, :edit, :update, :destroy]
	before_filter :page_acc 
	helper_method :val_pot
  # GET /visite_equipements
  # GET /visite_equipements.json
  def index
    @visite_equipements = VisiteEquipement.includes(:equipement => :type_equipement).all(:order =>"type_equipements.nom_constructeur,type_equipements.type_equipement,equipements.num_serie,id_visite_protocolaire_equipement desc")
     #@visite_equipements=@visite_equipements.sort_by{ |visiteequipement| [visiteequipement.equipement.type_equipement.nom_constructeur,visiteequipement.equipement.type_equipement.type_equipement, visiteequipement.equipement.num_serie]}
  end

  # GET /visite_equipements/1
  # GET /visite_equipements/1.json
  def show
  end

  # GET /visite_equipements/new
  def new
	@tableau_mois=["Janvier","Février","Mars","Avril","Mai","Juin","Juillet","Aout","Septembre","Octobre","Novembre","Décembre"]
	@visite_equipement = VisiteEquipement.new
	 if !(params[:id_equipement].nil?) then 
		@visite_equipement.idequipement=params[:id_equipement].to_i
	end
	@unite=" "
	if !(params[:id_visite_pro].nil?) then 
		@visite_equipement.id_visite_protocolaire_equipement=params[:id_visite_pro]
		#recup type de protentiel lié à la visite 
		@visite_prot=VisiteProtocolaireEquipement.find(params[:id_visite_pro])
		@unite=@visite_prot.type_potentiel.unitee_saisie
		@visite_induites=@visite_prot.maitre
	end
	if (!params[:id_visite_pro].nil? and !params[:id_equipement].nil? and @unite!="date") then
		@visite_equipement.val_potentiel=val_pot(params[:id_equipement],@visite_prot.type_potentiel.type_potentiel)
	end
	#on récupère les visites induites
	
  end

  # GET /visite_equipements/1/edit
  def edit
	@tableau_mois=["Janvier","Février","Mars","Avril","Mai","Juin","Juillet","Aout","Septembre","Octobre","Novembre","Décembre"]
	if !(params[:id_equipement].nil?) then 
		@visite_equipement.idequipement=params[:id_equipement]
	end
	@unite=" "
	if !(params[:id_visite_pro].nil?) then 
		@visite_equipement.id_visite_protocolaire_equipement=params[:id_visite_pro]
		#recup type de protentiel lié à la visite 
		@visite_prot=VisiteProtocolaireEquipement.find(params[:id_visite_pro])
		@unite=@visite_prot.type_potentiel.unitee_saisie
	end
	#si les deux sont définis on récupère la valeur du carnet
	#sinon potentiel = 0
	if (!params[:id_visite_pro].nil? and !params[:id_equipement].nil? and @unite!="date") then
		@visite_equipement.val_potentiel=val_pot(params[:id_equipement],@visite_prot.type_potentiel.type_potentiel)
	end
  end

  # POST /visite_equipements
  # POST /visite_equipements.json
  def create
    @visite_equipement = VisiteEquipement.new(visite_equipement_params.permit(:idequipement,:date_visite,:idtype_potentiel,:val_potentiel,:id_visite_protocolaire_equipement,:nom,:commentaire))
	@tableau_mois=["Janvier","Février","Mars","Avril","Mai","Juin","Juillet","Aout","Septembre","Octobre","Novembre","Décembre"]
    respond_to do |format|
      if @visite_equipement.save
	#on passe aux visites induites
	#on récupére toutes les visites induites
	@visite_induites=@visite_equipement.visite_protocolaire_equipement.maitre
	val_pot=params[:induite]
       #pour chaque visites induites
       @visite_induites.each  do |induite|
	       #on initailise une visite equipement avec les paramètres de la visite maitre
		@vis_equ_ind=VisiteEquipement.new(visite_equipement_params.permit(:idequipement,:date_visite,:idtype_potentiel,:val_potentiel,:id_visite_protocolaire_equipement,:nom,:commentaire) )
		#on modifie les valeurs ad hoc
		@vis_equ_ind.idtype_potentiel=induite.induite.type_potentiel.id
		@vis_equ_ind.val_potentiel=val_pot[induite.induite.id.to_s]["pot_montage"]
		@vis_equ_ind.id_visite_protocolaire_equipement=induite.induite.id
		#et pis on sauvegarde
		@vis_equ_ind.save
       end
	       
        format.html {if (params[:retour].nil?) then 
		redirect_to(@visite_equipement, :notice => 'visite équipement créée.')
	else
		#renvoi vers la page détails machine
		redirect_to url_for(:controller => 'machines',:action=>"show", :id => params[:retour],:onglet =>1), :notice => 'visite équipement créée.'
	end
	 }
        format.json { render action: 'show', status: :created, location: @visite_equipement }
      else
        format.html { render action: 'new' }
        format.json { render json: @visite_equipement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /visite_equipements/1
  # PATCH/PUT /visite_equipements/1.json
  def update
    respond_to do |format|
      if @visite_equipement.update(visite_equipement_params.permit(:idequipement,:date_visite,:idtype_potentiel,:val_potentiel,:id_visite_protocolaire_equipement,:nom,:commentaire))
        format.html { redirect_to @visite_equipement, notice: "La visite d'équipement a été correctement mis à jour." }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @visite_equipement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /visite_equipements/1
  # DELETE /visite_equipements/1.json
  def destroy
    @visite_equipement.destroy
    respond_to do |format|
      format.html { redirect_to visite_equipements_url }
      format.json { head :no_content }
    end
  end
  
  def get_type_visite
	  #remet à jour la division "Unité" donc on calcule
	  @visite_equipement=VisiteEquipement.new
	  @visite_prot=VisiteProtocolaireEquipement.find(params[:id_visite_protocolaire])
	  @unite=@visite_prot.type_potentiel.unitee_saisie
	  @visite_equipement.val_potentiel=val_pot(params[:id_equipement],@visite_prot.type_potentiel.type_potentiel)
	  @visite_induites=@visite_prot.maitre
	respond_to do |format|
		format.js 
	end
  end
  
  
  def get_visite_equ
	@equipement=Equipement.find(params[:id_equipement])
	@vpes=VisiteProtocolaireEquipement.all(:conditions => ['idtype_equipement = ? ',@equipement.type_equipement.id])
	
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_visite_equipement
      @visite_equipement = VisiteEquipement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def visite_equipement_params
      params[:visite_equipement]
    end
    def val_pot(id_equipement,type_pot)
		#on récupére la machine 
		equip=Equipement.find(id_equipement)
		mont= EstMonteSur.all(:conditions=>["date_retrait is null and idequipement=?",params[:id_equipement]])
		#on récupére le carnet
		releve=Carnet.liste_machine_carnet(mont[0].idmachine)
		#on récupère la valeur
		case type_pot
			when "Calendaire"
			val_potentiel=0
			when "utilisation moteur"
			val_potentiel=releve["heure_moteur"]
			when "Heure de vol" 
			val_potentiel=releve["heure_de_vol"]
			when "Nb cycles" 
			val_potentiel=releve["nombre_cycle"]
			else
			val_potentiel=0
		end
		@val_pot=val_potentiel
    end
    
end
