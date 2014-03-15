﻿class CnMachine < ActiveRecord::Base
	belongs_to:type_potentiel, :foreign_key =>:idtype_potentiel
	belongs_to:type_machine, :foreign_key =>:idtype_machine
	has_many:exec_cn_machine,:foreign_key=>:id_cn_machine
	validates_presence_of :val_potentiel ,:message => "le potentiel doit etre défini"
	validates_presence_of :idtype_potentiel, :message => "le type de potentiel doit etre défini"
	validates_presence_of :idtype_machine, :message => "le type de machine  doit etre défini"
end
