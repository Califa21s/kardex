﻿class PotentielEquipementsController < ApplicationController
  before_action :set_potentiel_equipement, only: [:show, :edit, :update, :destroy]
 before_filter :page_acc 
  # GET /potentiel_equipements
  # GET /potentiel_equipements.json
  def index
    @potentiel_equipements = PotentielEquipement.all
     @potentiel_equipements= @potentiel_equipements.sort_by {| potentiel_equipement|  [potentiel_equipement.type_equipement.nom_constructeur,potentiel_equipement.type_equipement.type_equipement]}

  end

  # GET /potentiel_equipements/1
  # GET /potentiel_equipements/1.json
  def show
  end

  # GET /potentiel_equipements/new
  def new
    @potentiel_equipement = PotentielEquipement.new
  end

  # GET /potentiel_equipements/1/edit
  def edit
  end

  # POST /potentiel_equipements
  # POST /potentiel_equipements.json
  def create
    @potentiel_equipement = PotentielEquipement.new(potentiel_equipement_params.permit(:idtype_equipement,:idtype_potentiel,:valeur_potentiel))

    respond_to do |format|
      if @potentiel_equipement.save
        format.html { redirect_to @potentiel_equipement, notice: 'Potentiel équipement a été créé.' }
        format.json { render action: 'show', status: :created, location: @potentiel_equipement }
      else
        format.html { render action: 'new' }
        format.json { render json: @potentiel_equipement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /potentiel_equipements/1
  # PATCH/PUT /potentiel_equipements/1.json
  def update
    respond_to do |format|
      if @potentiel_equipement.update(potentiel_equipement_params.permit(:idtype_equipement,:idtype_potentiel,:valeur_potentiel))
        format.html { redirect_to @potentiel_equipement, notice: 'Potentiel equipement a été mis à jour.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @potentiel_equipement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /potentiel_equipements/1
  # DELETE /potentiel_equipements/1.json
  def destroy
    @potentiel_equipement.destroy
    respond_to do |format|
      format.html { redirect_to potentiel_equipements_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_potentiel_equipement
      @potentiel_equipement = PotentielEquipement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def potentiel_equipement_params
      params[:potentiel_equipement]
    end
end
