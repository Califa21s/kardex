SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;

SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;

SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

ALTER TABLE `kardex`.`personne` 
RENAME TO  `kardex`.`personnes` ;
ALTER TABLE `kardex`.`personnes` 
CHANGE COLUMN `id_personne` `id` INT(11) NOT NULL AUTO_INCREMENT ;

ALTER TABLE `kardex`.`personnes` 
DROP FOREIGN KEY `fk_personne_fonction1`;


ALTER TABLE `kardex`.`fonction` 
CHANGE COLUMN `idfonction` `id` INT(11) NOT NULL AUTO_INCREMENT , RENAME TO  `kardex`.`fonctions` ;


ALTER TABLE `kardex`.`personnes` 
ADD CONSTRAINT `fk_personne_fonction1`
  FOREIGN KEY (`id_fonction`)
  REFERENCES `kardex`.`fonctions` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
ALTER TABLE `kardex`.`est_acces` 
CHANGE COLUMN `idest_acces` `id` INT(11) NOT NULL AUTO_INCREMENT ;


ALTER TABLE `kardex`.`est_acces` 
DROP FOREIGN KEY `fk_est_acces_page_php1`;

ALTER TABLE `kardex`.`est_acces` 
CHANGE COLUMN `page_php_id` `page_acce_id` INT(11) NOT NULL ;


ALTER TABLE `kardex`.`page_php` 
RENAME TO  `kardex`.`page_acces` ;

ALTER TABLE `kardex`.`est_acces` 
ADD CONSTRAINT `fk_est_acces_page_acces`
  FOREIGN KEY (`page_acce_id`)
  REFERENCES `kardex`.`page_acces` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

UPDATE `kardex`.`page_acces` SET `adresse`='/personnes' WHERE `id`='1';

ALTER TABLE `kardex`.`page_acces` 
DROP FOREIGN KEY `fk1_page_php_menu_item`;

ALTER TABLE `kardex`.`menu_item` 
CHARACTER SET = utf8 , RENAME TO  `kardex`.`menu_items` ;

ALTER TABLE `kardex`.`page_acces` 
ADD CONSTRAINT `fk1_page_php_menu_item`
  FOREIGN KEY (`menu_item_id`)
  REFERENCES `kardex`.`menu_items` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
  ALTER TABLE `kardex`.`carnet` 
CHARACTER SET = utf8 , RENAME TO  `kardex`.`carnets` ;

ALTER TABLE `kardex`.`carnets` 
CHANGE COLUMN `idcarnet` `id` INT(11) NOT NULL AUTO_INCREMENT ;


ALTER TABLE `kardex`.`carnets` 
DROP FOREIGN KEY `fk_carnet_machine1`;

ALTER TABLE `kardex`.`est_monte_sur` 
DROP FOREIGN KEY `fk_est_monte_sur_machine1`;

ALTER TABLE `kardex`.`exec_cn_machine` 
DROP FOREIGN KEY `exec_cn_machine`;

ALTER TABLE `kardex`.`modif_repar` 
DROP FOREIGN KEY `id_machine_rep`;

ALTER TABLE `kardex`.`visite_machine` 
DROP FOREIGN KEY `machine_visite_machine`;

ALTER TABLE `kardex`.`machine` 
CHARACTER SET = utf8 ,
CHANGE COLUMN `idmachine` `id` INT(11) NOT NULL AUTO_INCREMENT , RENAME TO  `kardex`.`machines` ;

ALTER TABLE `kardex`.`machines` 
DROP PRIMARY KEY,
ADD PRIMARY KEY (`id`);

ALTER TABLE `kardex`.`carnets` 
ADD CONSTRAINT `fk_carnet_machine1`
  FOREIGN KEY (`machine_idmachine`)
  REFERENCES `kardex`.`machines` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `kardex`.`est_monte_sur` 
ADD CONSTRAINT `fk_est_monte_sur_machine1`
  FOREIGN KEY (`idmachine`)
  REFERENCES `kardex`.`machines` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `kardex`.`exec_cn_machine` 
ADD CONSTRAINT `exec_cn_machine`
  FOREIGN KEY (`id_machine`)
  REFERENCES `kardex`.`machines` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `kardex`.`modif_repar` 
ADD CONSTRAINT `id_machine_rep`
  FOREIGN KEY (`id_machine`)
  REFERENCES `kardex`.`machines` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `kardex`.`visite_machine` 
ADD CONSTRAINT `machine_visite_machine`
  FOREIGN KEY (`idmachine`)
  REFERENCES `kardex`.`machines` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
  
  
  
  
  
  
  ALTER TABLE `kardex`.`cn_machine` 
DROP FOREIGN KEY `cn_machine_type_machine`;

ALTER TABLE `kardex`.`machines` 
DROP FOREIGN KEY `fk_machine_type_machine1`;

ALTER TABLE `kardex`.`potentiel_machine` 
DROP FOREIGN KEY `potentiel_machine_type_machine`;

ALTER TABLE `kardex`.`visite_protocolaire` 
DROP FOREIGN KEY `visite_protocolaire_type_machine`;

ALTER TABLE `kardex`.`machines` 
CHANGE COLUMN `Immatriculation` `Immatriculation` VARCHAR(8) NULL DEFAULT NULL ,
CHANGE COLUMN `num_serie` `num_serie` VARCHAR(45) NULL DEFAULT NULL ;

ALTER TABLE `kardex`.`type_machine` 
 RENAME TO  `kardex`.`type_machines` ;

ALTER TABLE `kardex`.`type_machines` 
CHANGE COLUMN `idtype_machine` `id` INT(11) NOT NULL AUTO_INCREMENT ;

ALTER TABLE `kardex`.`cn_machine` 
ADD CONSTRAINT `cn_machine_type_machine`
  FOREIGN KEY (`idtype_machine`)
  REFERENCES `kardex`.`type_machines` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `kardex`.`machines` 
ADD CONSTRAINT `fk_machine_type_machine1`
  FOREIGN KEY (`type_machine_idtype_machine`)
  REFERENCES `kardex`.`type_machines` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `kardex`.`potentiel_machine` 
ADD CONSTRAINT `potentiel_machine_type_machine`
  FOREIGN KEY (`idtype_machine`)
  REFERENCES `kardex`.`type_machines` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `kardex`.`visite_protocolaire` 
ADD CONSTRAINT `visite_protocolaire_type_machine`
  FOREIGN KEY (`idtype_machine`)
  REFERENCES `kardex`.`type_machines` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `kardex`.`cn_equipement` 
DROP FOREIGN KEY `cn_equipement_type_potentiel`;

ALTER TABLE `kardex`.`exec_cn_equipement` 
DROP FOREIGN KEY `exec_cn_type_potentiel`;

ALTER TABLE `kardex`.`potentiel_equipement` 
DROP FOREIGN KEY `fk_potentiel_equipement_type_potentiel1`;

ALTER TABLE `kardex`.`potentiel_montage` 
DROP FOREIGN KEY `potentiel_montage_type`;

ALTER TABLE `kardex`.`visite_equipement` 
DROP FOREIGN KEY `type_potentiel_visite_machine0`;

ALTER TABLE `kardex`.`visite_machine` 
DROP FOREIGN KEY `type_potentiel_visite_machine`;

ALTER TABLE `kardex`.`visite_protocolaire_equipements` 
DROP FOREIGN KEY `visite_protocolaire_type_potentiel0`;

ALTER TABLE `kardex`.`type_potentiel` 
 RENAME TO  `kardex`.`type_potentiels` ;

ALTER TABLE `kardex`.`type_potentiels` 
CHANGE COLUMN `idtype_potentiel` `id` INT(11) NOT NULL ;

ALTER TABLE `kardex`.`cn_equipement` 
ADD CONSTRAINT `cn_equipement_type_potentiel`
  FOREIGN KEY (`idtype_potentiel`)
  REFERENCES `kardex`.`type_potentiels` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `kardex`.`cn_machine` 
DROP FOREIGN KEY `cn_machine_type_potentiel`;

ALTER TABLE `kardex`.`cn_machine` ADD CONSTRAINT `cn_machine_type_potentiel`
  FOREIGN KEY (`idtype_potentiel`)
  REFERENCES `kardex`.`type_potentiels` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `kardex`.`exec_cn_equipement` 
ADD CONSTRAINT `exec_cn_type_potentiel`
  FOREIGN KEY (`idtype_potentiel`)
  REFERENCES `kardex`.`type_potentiels` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `kardex`.`exec_cn_machine` 
DROP FOREIGN KEY `exec_cn_type_potentiels`;

ALTER TABLE `kardex`.`exec_cn_machine` ADD CONSTRAINT `exec_cn_type_potentiels`
  FOREIGN KEY (`idtype_potentiel`)
  REFERENCES `kardex`.`type_potentiels` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `kardex`.`potentiel_equipement` 
ADD CONSTRAINT `fk_potentiel_equipement_type_potentiel1`
  FOREIGN KEY (`idtype_potentiel`)
  REFERENCES `kardex`.`type_potentiels` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `kardex`.`potentiel_machine` 
DROP FOREIGN KEY `type_potentiel_potentiel_machine`;

ALTER TABLE `kardex`.`potentiel_machine` ADD CONSTRAINT `type_potentiel_potentiel_machine`
  FOREIGN KEY (`idtype_potentiel`)
  REFERENCES `kardex`.`type_potentiels` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `kardex`.`potentiel_montage` 
ADD CONSTRAINT `potentiel_montage_type`
  FOREIGN KEY (`idtype_potentiel`)
  REFERENCES `kardex`.`type_potentiels` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `kardex`.`visite_equipement` 
ADD CONSTRAINT `type_potentiel_visite_machine0`
  FOREIGN KEY (`idtype_potentiel`)
  REFERENCES `kardex`.`type_potentiels` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `kardex`.`visite_machine` 
ADD CONSTRAINT `type_potentiel_visite_machine`
  FOREIGN KEY (`idtype_potentiel`)
  REFERENCES `kardex`.`type_potentiels` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;


ALTER TABLE `kardex`.`visite_protocolaire` 
DROP FOREIGN KEY `visite_protocolaire_type_potentiel`;

ALTER TABLE `kardex`.`visite_protocolaire` ADD CONSTRAINT `visite_protocolaire_type_potentiel`
  FOREIGN KEY (`idtype_potentiel`)
  REFERENCES `kardex`.`type_potentiels` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `kardex`.`visite_protocolaire_equipements` 
ADD CONSTRAINT `visite_protocolaire_type_potentiel0`
  FOREIGN KEY (`idtype_potentiel`)
  REFERENCES `kardex`.`type_potentiels` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

#mise au pluriel visite protocolaires + changement ID

ALTER TABLE `kardex`.`visite_machine` 
DROP FOREIGN KEY `_protocolaire_visite_machine`;




ALTER TABLE `kardex`.`visite_protocolaire` 
RENAME TO  `kardex`.`visite_protocolaires` ;

ALTER TABLE `kardex`.`visite_protocolaires`
CHANGE COLUMN `id_visite_protocolaire` `id` INT(11) NOT NULL AUTO_INCREMENT ; 

ALTER TABLE `kardex`.`visite_machine` 
ADD CONSTRAINT `_protocolaire_visite_machine`
  FOREIGN KEY (`id_visite_protocolaire`)
  REFERENCES `kardex`.`visite_protocolaires` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

#mise au pluriel cn_machine + changement id

ALTER TABLE `kardex`.`exec_cn_machine` 
DROP FOREIGN KEY `exec_cn_cn_machine`;

ALTER TABLE `kardex`.`cn_machine` 
CHARACTER SET = utf8 ,
CHANGE COLUMN `idcn_machine` `id` INT(11) NOT NULL AUTO_INCREMENT , RENAME TO  `kardex`.`cn_machines` ;

ALTER TABLE `kardex`.`visite_protocolaires` 
CHANGE COLUMN `Nom` `Nom` VARCHAR(45) NULL DEFAULT NULL ,
CHANGE COLUMN `commentaire` `commentaire` TEXT NULL DEFAULT NULL ;

ALTER TABLE `kardex`.`exec_cn_machine` 
ADD CONSTRAINT `exec_cn_cn_machine`
  FOREIGN KEY (`idcn_machine`)
  REFERENCES `kardex`.`cn_machines` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
  # modification exec_cn_machine
  ALTER TABLE `kardex`.`exec_cn_machine` 
CHANGE COLUMN `idexec_cn_machine` `id` INT(11) NOT NULL AUTO_INCREMENT , RENAME TO  `kardex`.`exec_cn_machines` ;


ALTER TABLE `kardex`.`modif_repar` 
CHANGE COLUMN `idmodif_repar` `id` INT(11) NOT NULL AUTO_INCREMENT , RENAME TO  `kardex`.`modif_repars` ;

ALTER TABLE `kardex`.`visite_machine` 
CHANGE COLUMN `idvisite_machine` `id` INT(11) NOT NULL AUTO_INCREMENT , RENAME TO  `kardex`.`visite_machines` ;

ALTER TABLE `kardex`.`potentiel_machine` 
CHANGE COLUMN `idpotentiel_machine` `id` INT(11) NOT NULL AUTO_INCREMENT , RENAME TO  `kardex`.`potentiel_machines` ;

ALTER TABLE `kardex`.`doc_divers` 
DROP FOREIGN KEY `fk_doc_divers_doc_type`;

ALTER TABLE `kardex`.`type_doc`  RENAME TO  `kardex`.`type_docs` ;

ALTER TABLE `kardex`.`doc_divers` 
ADD CONSTRAINT `fk_doc_divers_doc_type`
  FOREIGN KEY (`type_doc_id`)
  REFERENCES `kardex`.`type_docs` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `kardex`.`cn_equipement` 
DROP FOREIGN KEY `cn_equipement_type_equipement`;

ALTER TABLE `kardex`.`equipement` 
DROP FOREIGN KEY `equipement_type_equipement`;

ALTER TABLE `kardex`.`potentiel_equipement` 
DROP FOREIGN KEY `fk_potentiel_equipement_type_equipement`;

ALTER TABLE `kardex`.`visite_protocolaire_equipements` 
DROP FOREIGN KEY `visite_protocolaire_type_machine0`;

ALTER TABLE `kardex`.`type_equipement` 
CHARACTER SET = utf8 ,
CHANGE COLUMN `idtype_equipement` `id` INT(11) NOT NULL AUTO_INCREMENT , RENAME TO  `kardex`.`type_equipements` ;

ALTER TABLE `kardex`.`cn_equipement` 
ADD CONSTRAINT `cn_equipement_type_equipement`
  FOREIGN KEY (`idtype_equipement`)
  REFERENCES `kardex`.`type_equipements` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `kardex`.`equipement` 
ADD CONSTRAINT `equipement_type_equipement`
  FOREIGN KEY (`idtypeequipement`)
  REFERENCES `kardex`.`type_equipements` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `kardex`.`potentiel_equipement` 
ADD CONSTRAINT `fk_potentiel_equipement_type_equipement`
  FOREIGN KEY (`idtype_equipement`)
  REFERENCES `kardex`.`type_equipements` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `kardex`.`visite_protocolaire_equipements` 
ADD CONSTRAINT `visite_protocolaire_type_machine0`
  FOREIGN KEY (`idtype_equipement`)
  REFERENCES `kardex`.`type_equipements` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
  ALTER TABLE `kardex`.`visite_equipement` 
CHARACTER SET = utf8 ,
CHANGE COLUMN `idvisite_equipement` `id` INT(11) NOT NULL AUTO_INCREMENT , RENAME TO  `kardex`.`visite_equipements` ;


ALTER TABLE `kardex`.`exec_cn_equipement` 
DROP FOREIGN KEY `exec_cn_equipement`;

ALTER TABLE `kardex`.`cn_equipement` 
CHARACTER SET = utf8 ,
CHANGE COLUMN `idcn_equipement` `id` INT(11) NOT NULL AUTO_INCREMENT , RENAME TO  `kardex`.`cn_equipements` ;


ALTER TABLE `kardex`.`exec_cn_equipement` 
ADD CONSTRAINT `exec_cn_equipement`
  FOREIGN KEY (`idcn_equipement`)
  REFERENCES `kardex`.`cn_equipements` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `kardex`.`est_monte_sur` 
DROP FOREIGN KEY `fk_est_monte_sur_equipement1`;

ALTER TABLE `kardex`.`exec_cn_equipement` 
DROP FOREIGN KEY `exec_cn_equipement _equipement`;

ALTER TABLE `kardex`.`visite_equipements` 
DROP FOREIGN KEY `machine_visite_equipement`;

ALTER TABLE `kardex`.`equipement` 
CHARACTER SET = utf8 ,
CHANGE COLUMN `idequipement` `id` INT(11) NOT NULL AUTO_INCREMENT , RENAME TO  `kardex`.`equipements` ;

ALTER TABLE `kardex`.`est_monte_sur` 
ADD CONSTRAINT `fk_est_monte_sur_equipement1`
  FOREIGN KEY (`idequipement`)
  REFERENCES `kardex`.`equipements` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `kardex`.`exec_cn_equipement` 
ADD CONSTRAINT `exec_cn_equipement _equipement`
  FOREIGN KEY (`id_equipement`)
  REFERENCES `kardex`.`equipements` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `kardex`.`visite_equipements` 
ADD CONSTRAINT `machine_visite_equipement`
  FOREIGN KEY (`idequipement`)
  REFERENCES `kardex`.`equipements` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
  ALTER TABLE `kardex`.`equipements` 
CHANGE COLUMN `num_serie` `num_serie` VARCHAR(45) NULL DEFAULT NULL ;

ALTER TABLE `kardex`.`exec_cn_equipement` 
CHARACTER SET = utf8 ,
CHANGE COLUMN `idexec_cn_equipement` `id` INT(11) NOT NULL AUTO_INCREMENT , RENAME TO  `kardex`.`exec_cn_equipements` ;

ALTER TABLE `kardex`.`potentiel_montage` 
DROP FOREIGN KEY `pontentiel_montage_equipement`;

ALTER TABLE `kardex`.`exec_cn_equipements` 
CHANGE COLUMN `commentaire` `commentaire` TEXT NULL DEFAULT NULL ;

ALTER TABLE `kardex`.`potentiel_equipement` 
CHARACTER SET = utf8 ,
CHANGE COLUMN `idpotentiel_equipement` `id` INT(11) NOT NULL AUTO_INCREMENT , RENAME TO  `kardex`.`potentiel_equipements` ;

ALTER TABLE `kardex`.`potentiel_montage` 
ADD CONSTRAINT `pontentiel_montage_equipement`
  FOREIGN KEY (`idpotentiel_equipement`)
  REFERENCES `kardex`.`potentiel_equipements` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
  

ALTER TABLE `kardex`.`visite_equipements` 
DROP FOREIGN KEY `visite_visite_equi`;

ALTER TABLE `kardex`.`visite_protocolaire_equipements` 
CHARACTER SET = utf8 ,
CHANGE COLUMN `id_visite_protocolaire_equipement` `id` INT(11) NOT NULL AUTO_INCREMENT ;

ALTER TABLE `kardex`.`visite_equipements` 
ADD CONSTRAINT `visite_visite_equi`
  FOREIGN KEY (`id_visite_protocolaire_equipement`)
  REFERENCES `kardex`.`visite_protocolaire_equipements` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
  
  ALTER TABLE `kardex`.`potentiel_montage` 
CHARACTER SET = utf8 ,
CHANGE COLUMN `idpotentiel_montage` `id` INT(11) NOT NULL AUTO_INCREMENT , RENAME TO  `kardex`.`potentiel_montages` ;

ALTER TABLE `kardex`.`potentiel_montages` 
DROP FOREIGN KEY `potentiel_montage_est_monte_sur`;

ALTER TABLE `kardex`.`est_monte_sur` 
CHARACTER SET = utf8 ,
CHANGE COLUMN `idest_monte_sur` `id` INT(11) NOT NULL AUTO_INCREMENT , RENAME TO  `kardex`.`est_monte_surs` ;

ALTER TABLE `kardex`.`potentiel_montages` 
ADD CONSTRAINT `potentiel_montage_est_monte_sur`
  FOREIGN KEY (`idest_monte_sur`)
  REFERENCES `kardex`.`est_monte_surs` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

UPDATE `kardex`.`page_acces` SET `adresse`='/est_monte_surs' WHERE `id`='10';


CREATE TABLE IF NOT EXISTS `kardex`.`vaut_pours` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `id_vis_maitre` INT(11) NULL DEFAULT NULL,
  `id_vis_induite` INT(11) NULL DEFAULT NULL,
  `commentaire` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `id_maitre_vaut_pour_idx` (`id_vis_maitre` ASC),
  INDEX `id_ind_vaut_pour_idx` (`id_vis_induite` ASC),
  CONSTRAINT `id_maitre_vaut_pour` 
    FOREIGN KEY (`id_vis_maitre`)
    REFERENCES `kardex`.`visite_protocolaires` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id_ind_vaut_pour`
    FOREIGN KEY (`id_vis_induite`)
    REFERENCES `kardex`.`visite_protocolaires` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

ALTER TABLE `kardex`.`vaut_pours` 
DROP FOREIGN KEY `id_maitre_vaut_pour`,
DROP FOREIGN KEY `id_ind_vaut_pour`;

ALTER TABLE `kardex`.`vaut_pours` 
CHANGE COLUMN `id_vis_maitre` `maitre_id` INT(11) NULL DEFAULT NULL ,
CHANGE COLUMN `id_vis_induite` `induite_id` INT(11) NULL DEFAULT NULL ;

ALTER TABLE `kardex`.`vaut_pours` 
ADD CONSTRAINT `id_maitre_vaut_pour`
  FOREIGN KEY (`maitre_id`)
  REFERENCES `kardex`.`visite_protocolaires` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `id_ind_vaut_pour`
  FOREIGN KEY (`induite_id`)
  REFERENCES `kardex`.`visite_protocolaires` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

INSERT INTO `kardex`.`page_acces` (`Nom`, `adresse`, `menu_item_id`) VALUES ('lien entre visite machine', '/vaut_pours', '6');
INSERT INTO `kardex`.`est_acces` (`fonction_idfonction`, `page_acce_id`, `page_consult`, `page_modif`, `page_new`, `page_suppr`) VALUES ('1', '21', '1', '1', '1', '1');
INSERT INTO `kardex`.`est_acces` (`fonction_idfonction`, `page_acce_id`, `page_consult`, `page_modif`, `page_new`, `page_suppr`) VALUES ('2', '21', '1', '1', '1', '1');

CREATE TABLE IF NOT EXISTS `kardex`.`equipement_vaut_pours` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `maitre_id` INT(11) NULL DEFAULT NULL,
  `induite_id` INT(11) NULL DEFAULT NULL,
  `commentaire` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `id_maitre_vaut_pour0_idx` (`maitre_id` ASC),
  INDEX `id_ind_vaut_pour0_idx` (`induite_id` ASC),
  CONSTRAINT `id_maitre_vaut_pour0`
    FOREIGN KEY (`maitre_id`)
    REFERENCES `kardex`.`visite_protocolaire_equipements` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id_ind_vaut_pour0`
    FOREIGN KEY (`induite_id`)
    REFERENCES `kardex`.`visite_protocolaire_equipements` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

INSERT INTO `kardex`.`page_acces` (`Nom`, `adresse`, `menu_item_id`) VALUES ('lien entre visite equipement', '/equipement_vaut_pours', '6');
INSERT INTO `kardex`.`est_acces` (`fonction_idfonction`, `page_acce_id`, `page_consult`, `page_modif`, `page_new`, `page_suppr`) VALUES ('1', '22', '1', '1', '1', '1');
INSERT INTO `kardex`.`est_acces` (`fonction_idfonction`, `page_acce_id`, `page_consult`, `page_modif`, `page_new`, `page_suppr`) VALUES ('2', '22', '1', '1', '1', '1');


CREATE TABLE IF NOT EXISTS `kardex`.`ligne_carnet` (
  `id` INT(11) NOT NULL,
  `L_0`VARCHAR(8) NULL DEFAULT NULL,
  `L_1`VARCHAR(8) NULL DEFAULT NULL,
  `L_2`VARCHAR(8) NULL DEFAULT NULL,
`L_3`VARCHAR(8) NULL DEFAULT NULL,
`L_4`VARCHAR(8) NULL DEFAULT NULL,
`L_5`VARCHAR(8) NULL DEFAULT NULL,
`L_6`VARCHAR(8) NULL DEFAULT NULL,
`L_7`VARCHAR(8) NULL DEFAULT NULL,
`L_8`VARCHAR(8) NULL DEFAULT NULL,
`L_9`VARCHAR(8) NULL DEFAULT NULL,
`L_10`VARCHAR(8) NULL DEFAULT NULL,
`L_11`VARCHAR(8) NULL DEFAULT NULL,
`L_12`VARCHAR(8) NULL DEFAULT NULL,
`L_13`VARCHAR(8) NULL DEFAULT NULL,
`L_14`VARCHAR(8) NULL DEFAULT NULL,
`L_15`VARCHAR(8) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


SET SQL_MODE=@OLD_SQL_MODE;

SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;

SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

