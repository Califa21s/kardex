class EstAcce < ActiveRecord::Base
belongs_to :fonction, :foreign_key =>:fonction_idfonction
belongs_to :page_acce
def self.page_acc (page,action,fonction)
	#determine si une page est accessible
	est_acce=EstAcce.joins(:page_acce).where('fonction_idfonction = ? AND page_acces.adresse = ?',fonction,'/'.concat(page)) 
	if (est_acce[0].nil?) then return (false) end
	case action
		when "index","show" then
			#cas de la consultation
			return ( est_acce[0].page_consult) 
		when "new","create" then
			#cas de la  création
			return ( est_acce[0].page_new) 
		when "edit","update" then
			#cas de la modification
			return ( est_acce[0].page_modif) 
		when "destroy" then
			return ( est_acce[0].page_suppr)
		else 
			return (true)
		end
	return(false)
end
end
