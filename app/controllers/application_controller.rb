class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper:all
  def current_user
	session[:personne]
  end
  def redirect_to_stored
	 if return_to = session[:return_to]
		session[:return_to]=nil
	else
		redirect_to :controller=>'appli', :action=>'welcome'
	end
  end
   def page_acc
	   #vérifie que la personne est logué
	   #raise (request.fullpath)
	if !session[:personne]
		flash[:warning]='Please login to continue'
		session[:return_to]=request.url
		redirect_to :controller => "appli", :action => "login"
		return (false)
	end
	#vérifie que la personne est autorisée à consulter la page 
	est_acce=EstAcce.find(:all,:include => [:page_acce] ,:conditions => ['fonction_idfonction = ? AND page_acces.adresse = ?',session[:personne].id_fonction,'/'.concat(params[:controller])]) 
	#si le résultat est null la page n'est pas consultable
	if (est_acce[0].nil?) then return (false) end
	#si non on regarde en fontion de la commande
	case params[:action]
		when "index","show" then
			#cas de la consultation
			if (est_acce[0].page_consult) then 
				return ( true) 
			else 
				redirect_to({:controller=>'machines', :action=>'index'},:notice => "vous n'avez pas les droits d'acces") 
				return (false)
			end
		when "new","create" then
			#cas de la  création
			if (!est_acce[0].page_new) then 
				redirect_to({:controller=>'machines', :action=>'index'},:notice => "vous n'avez pas les droits d'acces")
				return (false)
			else 
				return ( true) 
			end
		when "edit","update" then
			#cas de la modification
			if (!est_acce[0].page_modif) then 
				redirect_to({:controller=>'machines', :action=>'index'},:notice => "vous n'avez pas les droits d'acces")
				return (false)
			else 
				return ( true) 
			end
		when "destroy" then
			if (!est_acce[0].page_suppr)  then 
				redirect_to({:controller=>'machines', :action=>'index'},:notice => "vous n'avez pas les droits d'acces")
				return (false)
			else 
				return ( true) 
			end
		else 
			#destiné à couvrir les échanges "java" par ex
			return (true)
	end	
	#si on n'est pas sortie la page n'est pas accessible pour l'utilisateur inutile par ailleurs ...
	redirect_to({:controller=>'appli', :action=>'welcome'},:notice => "vous n'avez pas les droits d'acces")
	return(false)
end
  
  def styling(couleur)
	  if (couleur==2) then @styling='KO' elsif  (couleur==1) then @styling='half_ko'  else @styling='OK'  end
  end
  def pres_pot(pot,type_pot)
	 if(type_pot=="Calendaire") then 
		 toto=sprintf('%.0f', pot.to_f)+" jours" 
	else
		toto=sprintf('%.0f', pot.to_f)
	end 
	if(toto=="0") then toto="" end
	@pres_pot=toto
end
def pres_val(val,type_pot)
   if( type_pot=="Calendaire") then toto=val.strftime('%d/%m/%Y') else toto= sprintf('%.0f',val.to_f) end 
   #toto=@pres_val
   if (toto=="0") then toto="" end
   @pres_val=toto
end
end