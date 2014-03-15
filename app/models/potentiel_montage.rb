class PotentielMontage < ActiveRecord::Base
	belongs_to:est_monte_sur, :foreign_key =>:idest_monte_sur
	belongs_to:potentiel_equipement, :foreign_key =>:idpotentiel_equipement
end
