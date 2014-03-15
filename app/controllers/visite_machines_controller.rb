﻿class VisiteMachinesController < ApplicationController
  before_action :set_visite_machine, only: [:show, :edit, :update, :destroy]
 before_filter :page_acc
 helper_method :val_pot
  # GET /visite_machines
  # GET /visite_machines.json
  def index
    @visite_machines = VisiteMachine.all
     @visite_machines =@visite_machines.sort_by{|visitemachine|  [visitemachine.machine.type_machine.type_machine,visitemachine.machine.Immatriculation,visitemachine.visite_protocolaire.Nom,visitemachine.date_visite]}

  end

  # GET /visite_machines/1
  # GET /visite_machines/1.json
  def show
  end

  # GET /visite_machines/new
  def new
    @visite_machine = VisiteMachine.new
    #on prend en compte si on vient avec des paramètres prééablie
    @visit_prot=Machine.tab_visite(nil)
    if !(params[:id_machine].nil?) then 
		@visite_machine.idmachine=params[:id_machine]
		@visit_prot=Machine.tab_visite(params[:id_machine])
		# si la machine est connu au restreint au visite définie pour la machine
	end
    @unite="&nbsp;"
    if !(params[:id_visite_pro].nil?) then 
		@visite_machine.id_visite_protocolaire=params[:id_visite_pro]
		#recup type de protentiel lié  à la visite 
		@visite_prot=VisiteProtocolaire.find(params[:id_visite_pro])
		@unite=@visite_prot.type_potentiel.unitee_saisie
		if @visite_prot.nil? then
			@pot_var=false
		else
			@pot_var=@visite_prot.potentiel_variable
		end
		@visite_machine.val_potentiel=val_pot(params[:id_machine],@visite_prot.type_potentiel.type_potentiel)
		@visite_induites=@visite_prot.maitre
    end
    @tableau_mois=["Janvier","Février","Mars","Avril","Mai","Juin","Juillet","Aout","Septembre","Octobre","Novembre","Décembre"]

  end

  # GET /visite_machines/1/edit
  def edit
    @tableau_mois=["Janvier","Février","Mars","Avril","Mai","Juin","Juillet","Aout","Septembre","Octobre","Novembre","Décembre"]
    @visit_prot=Machine.tab_visite(@visite_machine.idmachine)
    @unite=@visite_machine.visite_protocolaire.type_potentiel.unitee_saisie
    @visite_induites=@visite_machine.visite_protocolaire.maitre
  end

  # POST /visite_machines
  # POST /visite_machines.json
  def create
    @visite_machine = VisiteMachine.new(visite_machine_params.permit(:idmachine,:date_visite,:id_potentiel,:val_potentiel,:id_visite_protocolaire,:nom,:val_nouv_pot,:commentaire))
    respond_to do |format|
      if @visite_machine.save
	      #on sauve les visites induites
	      #on récupère toutes les types de visites induites
	       @visite_induites=@visite_machine.visite_protocolaire.maitre
	       val_pot=params[:induite]
	       #pour chaque visites induites
	       @visite_induites.each  do |induite|
			#on initailise une visite machine avec les paramètres de la visites maitre
			@vis_mach_ind=VisiteMachine.new(visite_machine_params.permit(:idmachine,:date_visite,:id_potentiel,:val_potentiel,:id_visite_protocolaire,:nom,:val_nouv_pot,:commentaire) )
			#on modifie les valeurs ad hoc
			@vis_mach_ind.idtype_potentiel=induite.induite.type_potentiel.id
			@vis_mach_ind.val_potentiel=val_pot[induite.induite.id.to_s]["pot_montage"]
			@vis_mach_ind.id_visite_protocolaire=induite.induite.id
			#et pis on sauvegarde
			@vis_mach_ind.save
		end
	      
		format.html { if (params[:retour].nil?) then 
			redirect_to(@visite_machine, :notice => 'la nouvelle visite a été créée.') 
		else
			#renvoi vers la page détails machine
			redirect_to url_for(:controller => 'machines',:action=>"show", :id => params[:retour],:onglet =>1), :notice => 'la nouvelle visite a été créée.'
		end
		 }
        format.json { render action: 'show', status: :created, location: @visite_machine }
      else
        format.html { render action: 'new' }
        format.json { render json: @visite_machine.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /visite_machines/1
  # PATCH/PUT /visite_machines/1.json
  def update
    respond_to do |format|
      if @visite_machine.update(visite_machine_params.permit(:id_machine,:date_visite,:id_potentiel,:val_potentiel,:id_visite_protocolaire,:nom,:val_nouv_pot,:commentaire))
        format.html { redirect_to @visite_machine, notice: 'la Visite machine a été mise à jour.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @visite_machine.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /visite_machines/1
  # DELETE /visite_machines/1.json
  def destroy
    @visite_machine.destroy
    respond_to do |format|
      format.html { redirect_to visite_machines_url }
      format.json { head :no_content }
    end
  end
  
  def get_type_visite
	@visite_machine = VisiteMachine.new
	 @visite_prot=VisiteProtocolaire.find(params[:id_visite_protocolaire])
	 @pot_var=@visite_prot.potentiel_variable
	 @unite=@visite_prot.type_potentiel.unitee_saisie
	 @visite_induites=@visite_prot.maitre
	 @visite_machine.val_potentiel=val_pot(params[:id_machine],@visite_prot.type_potentiel.type_potentiel)
	respond_to do |format|
		format.js 
	end
end
def get_type_machine
	@vis_prots=Machine.tab_visite(params[:id_machine])
end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_visite_machine
      @visite_machine = VisiteMachine.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def visite_machine_params
      params[:visite_machine]
    end
    def val_pot(id_machine,typ_pot)
	    releve=Carnet.liste_machine_carnet(id_machine)
		#on récupère la valeur
		case typ_pot
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
