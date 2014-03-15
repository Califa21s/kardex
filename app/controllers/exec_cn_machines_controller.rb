class ExecCnMachinesController < ApplicationController
  before_action :set_exec_cn_machine, only: [:show, :edit, :update, :destroy]
  before_filter :page_acc

  # GET /exec_cn_machines
  # GET /exec_cn_machines.json
  def index
    @exec_cn_machines = ExecCnMachine.all.includes({cn_machine:  [:type_machine,:type_potentiel]},:machine )
    @exec_cn_machines=@exec_cn_machines.sort_by{|exec_cn_machine| [exec_cn_machine.machine.type_machine.type_machine,exec_cn_machine.machine.Immatriculation,exec_cn_machine.cn_machine.nom]}
  end

  # GET /exec_cn_machines/1
  # GET /exec_cn_machines/1.json
  def show
	  
  end

  # GET /exec_cn_machines/new
  def new
	@tableau_mois=["Janvier","Février","Mars","Avril","Mai","Juin","Juillet","Aout","Septembre","Octobre","Novembre","Décembre"]
	@exec_cn_machine = ExecCnMachine.new
	 if !(params[:id_machine].nil?) then 
		@exec_cn_machine.id_machine=params[:id_machine]
	end
	@exec_cn_machine.val_potentiel_exec=0
	@unite="&nbsp;"
	if !(params[:idcn_machine].nil?) then 
		@exec_cn_machine.idcn_machine=params[:idcn_machine]
		#recup type de protentiel lié à la visite 
		@visite_prot=CnMachine.find(params[:idcn_machine])
		@unite=@visite_prot.type_potentiel.unitee_saisie
	end
  end

  # GET /exec_cn_machines/1/edit
  def edit
	   @tableau_mois=["Janvier","Février","Mars","Avril","Mai","Juin","Juillet","Aout","Septembre","Octobre","Novembre","Décembre"]
  end

  # POST /exec_cn_machines
  # POST /exec_cn_machines.json
  def create
    @exec_cn_machine = ExecCnMachine.new(exec_cn_machine_params.permit(:id_machine,:idcn_machine,:idtype_potentiel,:val_potentiel_exec,:date_exec,:non_applicable,:commentaire))

    respond_to do |format|
      if @exec_cn_machine.save
        format.html {
		if (params[:retour].nil?) then 
			redirect_to @exec_cn_machine, notice: 'Exécution de CN correctement enregistrée' 
		else
			#renvoi vers la page détails machine
			redirect_to url_for(:controller => 'machines',:action=>"show", :id => params[:retour],:onglet =>2), :notice => 'Execution CN machine pris en compte.'
		end
	}
        format.json { render action: 'show', status: :created, location: @exec_cn_machine }
      else
        format.html { render action: 'new' }
        format.json { render json: @exec_cn_machine.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exec_cn_machines/1
  # PATCH/PUT /exec_cn_machines/1.json
  def update
    respond_to do |format|
      if @exec_cn_machine.update(exec_cn_machine_params.permit(:id_machine,:idcn_machine,:idtype_potentiel,:val_potentiel_exec,:date_exec,:non_applicable,:commentaire))
        format.html { redirect_to @exec_cn_machine, notice: 'Exécution de CN mis à jour.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @exec_cn_machine.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exec_cn_machines/1
  # DELETE /exec_cn_machines/1.json
  def destroy
    @exec_cn_machine.destroy
    respond_to do |format|
      format.html { redirect_to exec_cn_machines_url }
      format.json { head :no_content }
    end
  end
  def cn_typemachine
	@machine=Machine.find(params[:machine_id])
	@cn_machines=CnMachine.find(:all, :conditions => ['idtype_machine = ? ',@machine.type_machine.id])
	  respond_to do |format|
		format.js 
	end
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exec_cn_machine
      @exec_cn_machine = ExecCnMachine.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exec_cn_machine_params
      params[:exec_cn_machine]
    end
end
