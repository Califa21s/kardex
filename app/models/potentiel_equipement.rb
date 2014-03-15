class PotentielEquipement < ActiveRecord::Base
	belongs_to:type_potentiel, :foreign_key =>:idtype_potentiel
	belongs_to:type_equipement, :foreign_key =>:idtype_equipement
end
