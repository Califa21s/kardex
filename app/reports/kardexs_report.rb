﻿class KardexsReport < Prawn::Document 
	#impression des kardex par machines
	def to_pdf(id_machine)
		require "prawn/measurement_extensions"
		######################################################################
		# récupération des données
		@machine = Machine.find(id_machine)
		#récupération des relevés
		@releve=Carnet.liste_machine_carnet(id_machine)
		 #répétion des visites
		@visite_machines=VisiteMachine.dernieres_visites(id_machine)
		#récupération des équipements montés sur la machine 
		@equipement=EstMonteSur.find(:all,:conditions=>["idmachine=? and date_retrait is null",id_machine])
		#viste et tri sur moteur et hélice
		@visites_equipement=VisiteEquipement.dernieres_visites(id_machine)
		@visites_equipement=@visites_equipement.sort_by {|visite_equipement| visite_equipement[1]["moteur_helice"]}
		@cn_machine=ExecCnMachine.etat_cn(id_machine)
		#recup CN Machine et tri sur moteur et Hélice
		@cn_equipement_machine=ExecCnEquipement.etat_cn(id_machine)
		@cn_equipement_machine=@cn_equipement_machine.sort_by{|cn_ex| cn_ex[1]["moteur_helice"]} 
		#reparation 
		@modif_repars=@machine.modif_repar
		@pots_machs=PotentielMachine.potentiel_machine(id_machine)
		#calcul de l'age
		@age_annee = ((Date.today- @machine.date_construct).to_i/365).to_s
		@age_mois= ((((Date.today- @machine.date_construct).to_i)-(365 *@age_annee.to_i))/30).to_s
		#récupération utilisation moyenne
		@util=Carnet.utilisation_moyenne(id_machine)
		#a calculer couleur d'onglet 
		#couleur visite protocolaire (machine + équipement)
		@couleur_visite = Machine.couleur_visite(id_machine)
		#couleur CN machine 
		@couleur_cn_machine=Machine.couleur_cn_machine(id_machine)
		#couleur CN equipement
		@couleur_cn_equipement=Machine.couleur_cn_equipement(id_machine)
		#couleur durée de vie
		@couleur_potentiel_machine=Machine.couleur_potentiel_machine(id_machine)
		#récupération potentiel équipement
		@pot_equipement=Equipement.potentiel_restant_machine(id_machine)
		@pot_equipement=@pot_equipement.sort_by{|pot| pot[1]["moteur_helice"]}
		#################################################################################
		# entête de page
		repeat :all do
			#mise en place entête
			 font "Times-Roman", :size => 12
			bounding_box [0, 274.mm], {:width => 47.mm, :height => 25.mm} do
				transparent(1){ stroke_bounds }
				move_down(1.mm)
				image "#{Rails.root}/app/reports/cab_bloc.jpg",{:scale => 0.6,:position => :center}
				text "Centre aéronautique de Beynes" , {:align=>:center,:min_font_size => 10}
			end
			bounding_box [47.mm, 274.mm], {:width => 85.mm, :height => 25.mm }do
				transparent(1) { stroke_bounds }
				move_down 5.mm
				text " Etat de la navigabilité de machine", {:align=>:center}
				text @machine.type_machine.type_machine+" "+@machine.Immatriculation, {:align=>:center, :valign=>:center}
			end
			bounding_box [132.mm, 274.mm], :width => 54.mm, :height => 25.mm do
				data=[["",""], ["",""], ["Date",Time.now.strftime('%d/%m/%Y')], ["",""], ["Agrément","FR.MG 249"]]
				transparent(1) { stroke_bounds }
				table(data, :cell_style => { :align=>:center,:overflow => :shrink_to_fit, :min_font_size => 10, :height =>5.mm ,:padding => [0, 0, 0, 0], :width => 27.mm,:borders =>[:left, :right]}) 
			end
			stroke_horizontal_rule
		end
		#####################################################################################################"
		#données générales
		move_down 10.mm
		font "Times-Roman", :size => 18
		text("Données Générales",{:align=>:center})
		font "Times-Roman", :size => 8
		move_down 18.mm
		data= Array.new(3) {Array.new(4)}
		data[0] =["constructeur",@machine.type_machine.Nom_constructeur,"type",@machine.type_machine.type_machine]
		data[1]=["Immatriculation",@machine.Immatriculation,"numéro de série",@machine.num_serie]
		data[2]=["Date de constrution",@machine.date_construct.strftime('%d/%m/%Y'),"Age de la machine", @age_annee +" années et "+ @age_mois + " mois"]
		table(data, :cell_style => { :align=>:left,:overflow => :shrink_to_fit, :min_font_size => 8, :height =>5.mm ,:padding => [0, 0, 0, 0], :width => 37.mm,:borders =>[]}) 
		move_down 10.mm
		#relevé d'huere
		data= Array.new(4) {Array.new(3)}
		font "Times-Roman", :size => 12
		text 'Relevé'
		font "Times-Roman", :size => 8
		text('dernier relevé : '+@releve["date_releve"].strftime('%d/%m/%Y'))
		
		data[0]=["",'valeur relevé' ,'utilisation annuelle']
		data[1]=["heure de vol",@releve["heure_de_vol"], sprintf("%.0f",@util["heure_de_vol"])]
		data[2]=["nombre de cycle",@releve["nombre_cycle"],sprintf("%.0f",@util["nombre_cycle"])]
		data[3]=["heure moteur",@releve["heure_moteur"],sprintf("%.0f",@util["heure_moteur"])]
		table(data, :cell_style => { :align=>:center,:overflow => :shrink_to_fit, :min_font_size => 8, :height =>5.mm ,:padding => [0, 0, 0, 0], :width => 37.mm}) 
		#liste des équipements montés sur la machine
		move_down 10.mm
		data= Array.new(@equipement.length+1) {Array.new(4)}
		font "Times-Roman", :size => 12
		text "Equipements montés sur la machine"
		font "Times-Roman", :size => 8
		data[0]=["Constructeur","Type","Numéro de série","date montage"]
		i=1
		@equipement.each do |equipement1| 
			data[i]=[Prawn::Table::Cell::Text.new( self, [0,0], :content =>equipement1.equipement.type_equipement.nom_constructeur),
			equipement1.equipement.type_equipement.type_equipement,
				equipement1.equipement.num_serie,equipement1.date_montage.strftime('%d/%m/%Y')]
			i=i+1
		end
		table(data, :cell_style => { :align=>:center,:overflow => :shrink_to_fit, :min_font_size => 8, :height =>5.mm ,:padding => [0, 0, 0, 0], :width => 37.mm}) 
		move_down 10.mm
		start_new_page
		###################################################################################################
		#gestion des visites machine
		font "Times-Roman", :size => 16
		text "Visites d'entretien machine et équipements",:align=>:center
		font "Times-Roman", :size => 8
		move_down 16.mm
		#visites machines
		data= Array.new(@visite_machines.size+1) {Array.new(11)}
		font "Times-Roman", :size => 12
		text "Visites entretien machine"
		move_down 10.mm
		font "Times-Roman", :size => 8
		data[0]=[ "Visite","Périodicité","Tolérance","dernière visite","Date visite","valeur potentiel",
			"butée","butée avec tol","Dernière valeur connue","potentiel restant hors tolérance","potentiel restant avec tolérance"]
		i=1
		@visite_machines.each do |visite|
			if( visite[1]["visite_protocolaire"].type_potentiel.type_potentiel=="Calendaire") then 
				val_pot=visite[1]["val_potentiel"].strftime('%d/%m/%Y') 
				butee=visite[1]["butee"].strftime('%d/%m/%Y') 
				butee_tol=visite[1]["butee_tol"].strftime('%d/%m/%Y') 
				val_releve=visite[1]["val_dernier_releve"].strftime('%d/%m/%Y') 
				reste=visite[1]["reste"].to_s+" jours" 
				reste_tol=visite[1]["reste_tol"].to_s+" jours" 
			else
				val_pot=visite[1]["val_potentiel"] 
				butee=visite[1]["butee"] 
				butee_tol=visite[1]["butee_tol"] 
				val_releve=visite[1]["val_dernier_releve"] 
				reste=visite[1]["reste"] 
				reste_tol=visite[1]["reste_tol"] 
			end
			
			if (visite[1]["couleur"]==2) then couleur="FF0000" elsif  (visite[1]["couleur"]==1) then couleur = "FFA500"  else couleur="00FF00"  end 
			data[i]=[ Prawn::Table::Cell::Text.new( self, [0,0], :content =>visite[1]["visite_protocolaire"].Nom,:background_color=>couleur),
				visite[1]["visite_protocolaire"].valeur_potentiel.to_s+ visite[1]["visite_protocolaire"].type_potentiel.unitee, 
				visite[1]["visite_protocolaire"].tolerance.to_s + visite[1]["visite_protocolaire"].type_potentiel.unitee, visite[1]["nom"] ,
				visite[1]["date_visite"].strftime('%d/%m/%Y') ,val_pot,butee,butee_tol,val_releve,
				Prawn::Table::Cell::Text.new( self, [0,0], :content =>reste.to_s,:background_color=>couleur) ,reste_tol]
			 i=i+1
		end
		table(data, :cell_style => { :align=>:center,:overflow => :shrink_to_fit, :min_font_size => 6, :height =>7.mm ,:padding => [0, 0, 0, 0], :width => 16.mm}) 
		move_down 10.mm
		###################################################################################
		#visites equipement
		data= Array.new 
		font "Times-Roman", :size => 12
		text "Visites entretien équipement"
		font "Times-Roman", :size => 8
		i=1
		type_equip=0
		@visites_equipement.each do |vis|
			if( vis[1]["visite_protocolaire"].type_potentiel.type_potentiel=="Calendaire")
				val_potentiel=vis[1]["val_potentiel"].strftime('%d/%m/%Y')
				butee=vis[1]["butee"].strftime('%d/%m/%Y') 
				butee_tol=vis[1]["butee_tol"].strftime('%d/%m/%Y') 
				val_dernier_releve=vis[1]["val_dernier_releve"].strftime('%d/%m/%Y')
				reste=vis[1]["reste"].to_s+" jours" 
				reste_tol= vis[1]["reste_tol"].to_s+" jours" 
			else
				val_potentiel= vis[1]["val_potentiel"] 
				butee=vis[1]["butee"] 
				butee_tol=vis[1]["butee_tol"] 
				val_dernier_releve=vis[1]["val_dernier_releve"] 
				reste= vis[1]["reste"] 
				reste_tol= vis[1]["reste_tol"] 
			end
			if (vis[1]["couleur"]==2) then couleur="FF0000" elsif  (vis[1]["couleur"]==1) then couleur = "FFA500"  else couleur="00FF00"  end 
			#on change de tableau à chaque changement de type d'équipement
			if (type_equip!=vis[1]["moteur_helice"]) then
				if (type_equip!=0) then 
					com_equip (type_equip)
					table(data, :cell_style => { :align=>:center,:overflow => :shrink_to_fit, :min_font_size => 6, :height =>10.mm ,:padding => [0, 0, 0, 0], :width => 15.mm}) 
				end 
				type_equip=vis[1]["moteur_helice"]
				data=Array.new
				data[0]=[ "Equipement","Nom visite equipement","Potentiel","Tolérance","dernière visite","Date visite","valeur potentiel",
				"butée","butée avec tol","Dernière valeur connue","potentiel restant hors tolérance","potentiel restant avec tolérance"]
				i=1
			end
			data[i]=[Prawn::Table::Cell::Text.new( self, [0,0], :content =>vis[1]["type_equipement"],:background_color=>couleur) ,
				vis[1]["visite_protocolaire"].Nom,vis[1]["visite_protocolaire"].valeur_potentiel.to_s+vis[1]["visite_protocolaire"].type_potentiel.unitee,
				vis[1]["visite_protocolaire"].tolerance.to_s+vis[1]["visite_protocolaire"].type_potentiel.unitee,vis[1]["nom"] ,vis[1]["date_visite"].strftime('%d/%m/%Y'),
				val_potentiel,butee,butee_tol,val_dernier_releve,
				Prawn::Table::Cell::Text.new( self, [0,0], :content =>reste.to_s,:background_color=>couleur),reste_tol]
			i=i+1
		end
		com_equip (type_equip)
		table(data, :cell_style => { :align=>:center,:overflow => :shrink_to_fit, :min_font_size => 6, :height =>10.mm ,:padding => [0, 0, 0, 0], :width => 15.mm}) 
		start_new_page
		
		#######################################################################################################
		#CN machine
		font "Times-Roman", :size => 16
		text "Consignes de navigabilité Machine",:align=>:center
		font "Times-Roman", :size => 8
		move_down 16.mm
		#cn machines
		data= Array.new(@cn_machine.size+1) {Array.new(10)}
		font "Times-Roman", :size => 8
		data[0]= ["Référence","Nom Cn","Num BS","valeur potentiel","date application","CN Applicable","valeur potentiel","butée","Dernière valeur connue",
			"potentiel restant hors tolérance"]
		i=1
		
		@cn_machine.each do |cn_ex|
			cn_mach=cn_ex[1]["visite_protocolaire"]
			if( cn_mach.type_potentiel.type_potentiel=="Calendaire") then 
				val_pot=cn_ex[1]["val_potentiel"].strftime('%d/%m/%Y')
				butee=cn_ex[1]["butee"].strftime('%d/%m/%Y')
				val_releve=cn_ex[1]["val_dernier_releve"].strftime('%d/%m/%Y') 
				reste= cn_ex[1]["reste"].to_s+" jours" 
			else
				val_pot=cn_ex[1]["val_potentiel"] 
				butee=cn_ex[1]["butee"]
				val_releve=cn_ex[1]["val_dernier_releve"]
				reste=cn_ex[1]["reste"]
			end
			if (cn_ex[1]["couleur"]==2) then couleur="FF0000" elsif  (cn_ex[1]["couleur"]==1) then couleur = "FFA500"  else couleur="00FF00"  end 
			if (!cn_ex[1]["NA"]) then applicable="X" else applicable="" end 
			data[i]=[Prawn::Table::Cell::Text.new( self, [0,0], :content =>cn_mach.reference,:background_color=>couleur),
				cn_ex[1]["visite_protocolaire"].nom,cn_mach.service_bulletin,cn_mach.val_potentiel.to_s+" "+cn_mach.type_potentiel.unitee,
				cn_ex[1]["date_visite"],applicable ,val_pot,butee,val_releve,
				Prawn::Table::Cell::Text.new( self, [0,0], :content =>reste.to_s,:background_color=>couleur)]				
			 i=i+1
		 end
		table(data, :cell_style => { :align=>:center,:overflow => :shrink_to_fit, :min_font_size => 6, :height =>10.mm ,:padding => [0, 0, 0, 0], :width => 18.mm},:header => true) 
		move_down 10.mm
		start_new_page
		#######################################################################################################
		# CN équipement
		font "Times-Roman", :size => 16
		text "Consignes de navigabilité équipement",:align=>:center
		font "Times-Roman", :size => 8
		i=1
		type_equip=0
		@cn_equipement_machine.each do |cn_ex|
			cn_mach=cn_ex[1]["visite_protocolaire"] 
			if cn_ex[1]["date_visite"]=="pas_applique" then date_1=cn_ex[1]["date_visite"] else date_1=cn_ex[1]["date_visite"].strftime('%d/%m/%Y') end
			if (!cn_ex[1]["NA"]) then applicable="X" else applicable="" end
			if (cn_ex[1]["couleur"]==2) then couleur="FF0000" elsif  (cn_ex[1]["couleur"]==1) then couleur = "FFA500"  else couleur="00FF00"  end 
			if(  cn_mach.type_potentiel.type_potentiel=="Calendaire") then 
				val_potentiel=cn_ex[1]["val_potentiel"].strftime('%d/%m/%Y') 
				butee=cn_ex[1]["butee"].strftime('%d/%m/%Y')
				val_dernier_releve=cn_ex[1]["val_dernier_releve"].strftime('%d/%m/%Y')
				reste=cn_ex[1]["reste"].to_s+" jours"
			else
				val_potentiel=cn_ex[1]["val_potentiel"]
				butee=cn_ex[1]["butee"] 
				val_dernier_releve=cn_ex[1]["val_dernier_releve"]
				reste=cn_ex[1]["reste"]
			end
			
			if (type_equip!=cn_ex[1]["moteur_helice"]) then
				if (type_equip!=0) then 
					com_equip (type_equip)
					table(data, :cell_style => { :align=>:center,:overflow => :shrink_to_fit, :min_font_size => 6, :height =>10.mm ,:padding => [0, 0, 0, 0], :width => 16.mm}) 
				end 
				type_equip=cn_ex[1]["moteur_helice"]
				data=Array.new
				data[0]= ["ref CN","Equipement","Nom Cn","Num BS","valeur potentiel","date application","valeur potentiel","butée","Derniere valeur connue",
				"potentiel restant hors tolérance","CN Applicable"]
				i=1
			end
			
			data[i]=[ Prawn::Table::Cell::Text.new( self, [0,0], :content =>cn_mach.reference, :background_color=>couleur),
				cn_ex[1]["equipement_type"] ,cn_ex[1]["visite_protocolaire"].nom, cn_mach.service_bulletin,
				cn_mach.val_potentiel.to_s+" "+cn_mach.type_potentiel.unitee,date_1, val_potentiel,butee,val_dernier_releve,
				Prawn::Table::Cell::Text.new( self, [0,0], :content =>reste.to_s,:background_color=>couleur),applicable]
			i=i+1
		end
		com_equip (type_equip)
		table(data, :cell_style => { :align=>:center,:overflow => :shrink_to_fit, :min_font_size => 6, :height =>10.mm ,:padding => [0, 0, 0, 0], :width => 16.mm},:header => true) 
		
		##############################################################################################
		# duréee de vie
		start_new_page
		font "Times-Roman", :size => 16
		text "Durée de vie",:align=>:center
		move_down 16.mm
		#machine
		font "Times-Roman", :size => 12
		text "durée de vie machine"
		move_down 10.mm
		font "Times-Roman", :size => 8
		font "Times-Roman", :size => 8
		data=Array.new
		data[0]= ["nom","type de durée de vie","durée de vie","durée de vie restante","Butée"]
		i=1
		@pots_machs.each do |pot_mach|
			if (pot_mach["couleur"]==2) then couleur="FF0000" elsif  (pot_mach["couleur"]==1) then couleur = "FFA500"  else couleur="00FF00"  end 
			data[i]=[Prawn::Table::Cell::Text.new( self, [0,0], :content =>pot_mach["nom"],:background_color=>couleur) ,
			pot_mach["type_potentiel"] , pot_mach["val_potentiel"] ,Prawn::Table::Cell::Text.new( self, [0,0], :content =>pot_mach["reste"].to_s+" "+pot_mach["unitee"],:background_color=>couleur),pot_mach["butee"] ]
			i=i+1
		end	
		table(data, :cell_style => { :align=>:center,:overflow => :shrink_to_fit, :min_font_size => 6, :height =>10.mm ,:padding => [0, 0, 0, 0], :width => 18.mm},:header => true) 
		#équipement
		move_down 12.mm
		font "Times-Roman", :size => 12
		text "durée de vie équipement"
		font "Times-Roman", :size => 8
		type_equip=0
		@pot_equipement.each do |pot|
			if (pot[1]["couleur"]==2) then couleur="FF0000" elsif  (pot[1]["couleur"]==1) then couleur = "FFA500"  else couleur="00FF00"  end 
			if (type_equip!=pot[1]["moteur_helice"]) then
				if (type_equip!=0) then 
					com_equip (type_equip)
					table(data, :cell_style => { :align=>:center,:overflow => :shrink_to_fit, :min_font_size => 6, :height =>10.mm ,:padding => [0, 0, 0, 0], :width => 18.mm}) 
				end 
				type_equip=pot[1]["moteur_helice"]
				data=Array.new
				data[0]= ["équipement","Numéro de série","type de durée de vie","durée de vie","durée de vie restante","Butée"]
				i=1
			end
			data[i]=[Prawn::Table::Cell::Text.new( self, [0,0], :content =>pot[1]["equipement"].type_equipement.nom_constructeur+ " "+pot[1]["equipement"].type_equipement.type_equipement,:background_color=>couleur),
				pot[1]["equipement"].num_serie,
				pot[1]["type_pot"],
				pot[1]["val_pot"],
				Prawn::Table::Cell::Text.new( self, [0,0], :content =>pot[1]["reste"].to_s,:background_color=>couleur),
				pot[1]["butee"]]
			i=i+1
		end
		com_equip (type_equip)
		table(data, :cell_style => { :align=>:center,:overflow => :shrink_to_fit, :min_font_size => 6, :height =>10.mm ,:padding => [0, 0, 0, 0], :width => 18.mm},:header => true) 
		####################################################################################################
		# modification réparation
		start_new_page
		font "Times-Roman", :size => 16
		text "Réparations-Modifications",:align=>:center
		move_down 16.mm
		data= Array.new( @modif_repars.size+1) {Array.new(5)}
		font "Times-Roman", :size => 8
		data[0]= ["Service Bull","Objet","référence","date réalisation","Fait par"]
		i=1
		@modif_repars.each do |modif_repar|
			data[i]=[modif_repar.sb,modif_repar.Objet,modif_repar.ref ,modif_repar.date_rel.strftime('%d/%m/%Y'),
				modif_repar.fait_par]
		end
		table(data, :cell_style => { :align=>:center,:overflow => :shrink_to_fit, :min_font_size => 6, :height =>10.mm ,:padding => [0, 0, 0, 0], :width => 28.mm},:header => true) 
		number_pages "<page> / <total>", 
                                {:start_count_at => 1,
                                :at => [bounds.right - 50, 0],
                                :align => :right,
				:size => 8}	
		#number_pages "<page> in a total of <total>", [bounds.right - 50, 0]
		 render
		 
	 end
	 def com_equip (type_equipement)
		 move_down 10.mm
		font "Times-Roman", :size => 12
		 result = case type_equipement
			when 1 then "Moteur"
			when 2 then "Hélice"
			when 3 then "Divers"
			else "PB"
		end
		text  result
		move_down 10.mm
		font "Times-Roman", :size => 8
	 end
	 
	 def start_new_page(options={})
		 require "prawn/measurement_extensions"
		 #surcharge de la fonction new page 
		super(options)
		move_down 26.mm
	end
	
end
