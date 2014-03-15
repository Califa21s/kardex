class CnMachinesController < ApplicationController
  before_action :set_cn_machine, only: [:show, :edit, :update, :destroy]

  # GET /cn_machines
  # GET /cn_machines.json
  def index
    @cn_machines = CnMachine.all.includes(:type_potentiel,:type_machine)
    @cn_machines=@cn_machines.sort_by {|cn_machine| [cn_machine.type_machine.Nom_constructeur, cn_machine.type_machine.type_machine,cn_machine.reference]}
  end

  # GET /cn_machines/1
  # GET /cn_machines/1.json
  def show
	@cn_machine = CnMachine.find(params[:id])
	@cn_docs=DocDiver.find(:all,:conditions=>["type_doc_id=1 and id_entite=?",params[:id]])
	@bs_docs=DocDiver.find(:all,:conditions=>["type_doc_id=3 and id_entite=?",params[:id]])
  end

  # GET /cn_machines/new
  def new
    @cn_machine = CnMachine.new
    if !(params[:idtype_machine].nil?) then 
		@cn_machine.idtype_machine=params[:idtype_machine]
	end
  end

  # GET /cn_machines/1/edit
  def edit
	@cn_docs=DocDiver.find(:all,:conditions=>["type_doc_id=1 and id_entite=?",params[:id]])
	@bs_docs=DocDiver.find(:all,:conditions=>["type_doc_id=3 and id_entite=?",params[:id]])
	@doc=DocDiver.new
	 #doc = cn machine par défaut
	@doc.type_doc_id=1
  end

  # POST /cn_machines
  # POST /cn_machines.json
  def create
   @cn_machine = CnMachine.new(params[:cn_machine].permit(:idtype_machine,:date_premiere_execution,:reference,:service_bulletin,:est_annule,:idtype_potentiel,:val_potentiel,:nom,:commentaire))

    respond_to do |format|
      if @cn_machine.save
        format.html {
		#a faire un test si param retour on redirige sur le type machine sinon on reboucle sur la liste des VP
		if (params[:retour].nil?) then 
			redirect_to(@cn_machine, :notice => 'la Cn a ete cree.') 
		else
			@type_machine = TypeMachine.find(params[:retour])
			@visite_protocolaires=VisiteProtocolaire.find_all_by_idtype_machine(params[:retour])
			@potentiel_machines=PotentielMachine.find_all_by_idtype_machine(params[:retour])
			@cn_machines=CnMachine.find_all_by_idtype_machine(params[:retour])
			render 'type_machines/show',:notice => 'la Cn a ete cree.'
		end	
		}
        format.xml  { render :xml => @cn_machine, :status => :created, :location => @cn_machine }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cn_machine.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cn_machines/1
  # PATCH/PUT /cn_machines/1.json
  def update
    respond_to do |format|
      if @cn_machine.update(cn_machine_params.permit(:idtype_machine,:date_premiere_execution,:reference,:service_bulletin,:est_annule,:idtype_potentiel,:val_potentiel,:nom,:commentaire))
        format.html { redirect_to @cn_machine, notice: 'Cn machine correctement mis à jour.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @cn_machine.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cn_machines/1
  # DELETE /cn_machines/1.json
  def destroy
    @cn_machine.destroy
    respond_to do |format|
      format.html { redirect_to cn_machines_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cn_machine
      @cn_machine = CnMachine.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cn_machine_params
      params[:cn_machine]
    end
end
