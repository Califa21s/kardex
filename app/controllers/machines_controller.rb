class MachinesController < ApplicationController
  before_action :set_machine, only: [:show, :edit, :update, :destroy]
  helper_method :styling,:pres_pot,:pres_val
  before_filter :page_acc 
  # GET /machines
  # GET /machines.json
  def index
    @machines = Machine.all
    @modif=EstAcce.page_acc("machines","edit",session[:personne].id_fonction)
    @suppr= EstAcce.page_acc("machines","destroy",session[:personne].id_fonction)
    @machines=@machines.sort_by{|machine|  [machine.type_machine.type_machine, machine.Immatriculation]}
     respond_to do |format|
      format.html {}
      format.pdf { 
		test =CensReport.new(:page_size => "A4", :page_layout => :portrait)
		output=test.to_pdf()
		send_data output, :filename => "cen.pdf",:type => "application/pdf"
      }
      end
  end

  # GET /machines/1
  # GET /machines/1.json
  def show
	   respond_to do |format|
      format.html {
		 @machine = Machine.find(params[:id])
		      #rÈcupÈration des relevÈs
		    @releve=Carnet.liste_machine_carnet(params[:id])
		    #rÈcupÈration des visites
		    @visite_machines=VisiteMachine.dernieres_visites(params[:id])
		    #rÈcupÈration des Èquipements montÈs sur la machine 
		    @equipement=EstMonteSur.find(:all,:conditions=>["idmachine=? and date_retrait is null",params[:id]])
		    @montages=Equipement.potentiel_restant_machine(params[:id])
		    @montages=@montages.sort_by {|potentiel_restant| potentiel_restant[1]["moteur_helice"] }
		    #visite ‡ trier en fonction moteur et hÈlice
		    @visites_equipement=VisiteEquipement.dernieres_visites(params[:id])
		    @visites_equipement=@visites_equipement.sort_by {|visite_equipement| visite_equipement[1]["moteur_helice"]}
		    @cn_machine=ExecCnMachine.etat_cn(params[:id])
		    #cn on trie en fonction moteur
		    @cn_equipement_machine=ExecCnEquipement.etat_cn(params[:id])
		    @cn_equipement_machine=@cn_equipement_machine.sort_by{|cn_equipement| [cn_equipement[1]["moteur_helice"],cn_equipement[1]["equipement_type"]]}
		    @modif_repars=@machine.modif_repar
		    @pots_machs=PotentielMachine.potentiel_machine(params[:id])
		    #calcul de l'age
		    @age_annee = (Date.today- @machine.date_construct).to_i/365
		    @age_mois= (((Date.today- @machine.date_construct).to_i)-(365 *@age_annee))/30
		    #rÈcupÈration utilisation moyenne
		    @util=Carnet.utilisation_moyenne(params[:id])
		    #a calculer couleur d'onglet 
		    #couleur visite protocolaire (machine + Èquipement)
		    @couleur_visite = Machine.couleur_visite(params[:id])
		    #couleur CN machine 
		    @couleur_cn_machine=Machine.couleur_cn_machine(params[:id])
		    #couleur CN equipement
		    @couleur_cn_equipement=Machine.couleur_cn_equipement(params[:id])
		    #couleur durÈe de vie
		    @couleur_potentiel_machine=Machine.couleur_potentiel_machine(params[:id])
		    #rÈcupÈration des manuels maintenance disponibles
		    @mm_docs=DocDiver.find(:all,:conditions=>["type_doc_id=5 and id_entite=?",@machine.type_machine.id])
		    #calcul de l'onglet courant pour retour des autres pages
		    @onglet=Array.new(6,'hidden')
		    if params[:onglet].nil? then @onglet[0]="visible" else @onglet[params[:onglet].to_i]="visible" end
		    @onglet1=Array.new(6,'visible')
		    if params[:onglet].nil? then @onglet1[0]="hidden" else @onglet1[params[:onglet].to_i]="hidden" end
	}# show.html.erb
	format.xml  { render :xml => @machine }
	format.pdf { 
		test =KardexsReport.new(:page_size => "A4", :page_layout => :portrait)
		output=test.to_pdf(params[:id])
		send_data output, :filename => "Kardex.pdf",:type => "application/pdf"
      }
    end
	  
	  
	  
  end

  # GET /machines/new
  def new
	  @tableau_mois=["Janvier","F√©vrier","Mars","Avril","Mai","Juin","Juillet","Aout","Septembre","Octobre","Novembre","D√©cembre"]
	@machine = Machine.new
  end

  # GET /machines/1/edit
  def edit
	  @tableau_mois=["Janvier","F√©vrier","Mars","Avril","Mai","Juin","Juillet","Aout","Septembre","Octobre","Novembre","D√©cembre"]
  end

  # POST /machines
  # POST /machines.json
  def create
    @machine = Machine.new(machine_params.permit(:Immatriculation,:num_serie,:date_construct,:type_machine_idtype_machine))

    respond_to do |format|
      if @machine.save
        format.html { redirect_to @machine, notice: 'Machine cr√©√©e.' }
        format.json { render action: 'show', status: :created, location: @machine }
      else
        format.html { render action: 'new' }
        format.json { render json: @machine.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /machines/1
  # PATCH/PUT /machines/1.json
  def update
    respond_to do |format|
      if @machine.update(machine_params.permit(:Immatriculation,:num_serie,:date_construct,:type_machine_idtype_machine))
        format.html { redirect_to @machine, notice: 'Machinemise √† jour.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @machine.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /machines/1
  # DELETE /machines/1.json
  def destroy
    @machine.destroy
    respond_to do |format|
      format.html { redirect_to machines_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_machine
      @machine = Machine.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def machine_params
      params[:machine]
    end
end
