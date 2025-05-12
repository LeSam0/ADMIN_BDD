# CREATION DE LA DATABASE
CREATE DATABASE TD_FINAL_POMME_DONALD
    DEFAULT CHARACTER SET = 'utf8mb4';

USE TD_FINAL_POMME_DONALD;

# CREATION DES TABLES

DROP TABLE IF EXISTS TD_FINAL_POMME_DONALD.categorie;
CREATE TABLE categorie(  
    categorie_id MEDIUMINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    categorie_nom VARCHAR(255) NOT NULL
) 
ENCRYPTION = 'N'
ENGINE = INNODB;

DROP TABLE IF EXISTS TD_FINAL_POMME_DONALD.produit;
CREATE TABLE produit (
    produit_id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    produit_nom VARCHAR(255) NOT NULL,
    produit_categorie_id MEDIUMINT NOT NULL,
    produit_prix NUMERIC(8,2) NOT NULL,
    produit_stock NUMERIC(8) NULL,
    FOREIGN KEY (produit_categorie_id) REFERENCES categorie (categorie_id)
)
ENCRYPTION = 'N'
ENGINE = INNODB;     

DROP TABLE IF EXISTS TD_FINAL_POMME_DONALD.role;
CREATE TABLE role(  
    role_id MEDIUMINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    role_nom VARCHAR(255) NOT NULL
) 
ENCRYPTION = 'N'
-- ENCRYPTION = 'Y'
ENGINE = INNODB;

DROP TABLE IF EXISTS TD_FINAL_POMME_DONALD.employe;
CREATE TABLE employe (
    employe_id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    employe_nom VARCHAR(255) NOT NULL,
    employe_prenom VARCHAR(255) NOT NULL,
    employe_role_id MEDIUMINT NOT NULL,
    FOREIGN KEY (employe_role_id) REFERENCES role (role_id)
)
ENCRYPTION = 'N'
-- ENCRYPTION = 'Y'
ENGINE = INNODB;     

DROP TABLE IF EXISTS TD_FINAL_POMME_DONALD.client;
CREATE TABLE client
  (
  client_id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
  client_nom VARCHAR(255) NOT NULL,
  client_prenom VARCHAR(255) NOT NULL
)
ENCRYPTION = 'N'
-- ENCRYPTION = 'Y'
ENGINE = INNODB; 

DROP TABLE IF EXISTS TD_FINAL_POMME_DONALD.commande;
CREATE TABLE commande(  
    cmd_id INTEGER AUTO_INCREMENT PRIMARY KEY NOT NULL,
    cmd_client_id INTEGER NOT NULL,
    cmd_employer_id INTEGER NOT NULL,
    cmd_total_prix NUMERIC(8,2) NOT NULL,
    cmd_total_nb_produit NUMERIC(8) NOT NULL,
    cmd_date DATE NOT NULL,
    FOREIGN KEY (cmd_client_id) REFERENCES client (client_id),
    FOREIGN KEY (cmd_employer_id) REFERENCES employe (employe_id)
) 
ENCRYPTION = 'N'
ENGINE = INNODB;

# CREATION DES TABLESPACES

CREATE TABLESPACE POMME_DONALD_TABLESPACE
ADD DATAFILE "pomme_donald_tablespace.ibd"
MAX_SIZE 300M
ENCRYPTION = "N"
ENGINE = INNODB;

ALTER TABLE TD_FINAL_POMME_DONALD.categorie TABLESPACE POMME_DONALD_TABLESPACE;
ALTER TABLE TD_FINAL_POMME_DONALD.produit TABLESPACE POMME_DONALD_TABLESPACE;
ALTER TABLE TD_FINAL_POMME_DONALD.commande TABLESPACE POMME_DONALD_TABLESPACE;


CREATE TABLESPACE POMME_DONALD_CLIENT_TBS
ADD DATAFILE "pomme_donald_client_tbs.ibd"
AUTOEXTEND_SIZE 100M
ENCRYPTION = "N"
-- ENCRYPTION = "Y"
ENGINE = INNODB;

ALTER TABLE TD_FINAL_POMME_DONALD.client TABLESPACE POMME_DONALD_CLIENT_TBS;

CREATE TABLESPACE POMME_DONALD_EMPLOYE_TBS
ADD DATAFILE "pomme_donald_employe_tbs.ibd"
AUTOEXTEND_SIZE 100M
ENCRYPTION = "N"
-- ENCRYPTION = "Y"
ENGINE = INNODB;

ALTER TABLE TD_FINAL_POMME_DONALD.employe TABLESPACE POMME_DONALD_EMPLOYE_TBS;
ALTER TABLE TD_FINAL_POMME_DONALD.role TABLESPACE POMME_DONALD_EMPLOYE_TBS;


# CREATION DES UNDO TABLESPACES

CREATE UNDO TABLESPACE undo_tbs
ADD DATEFILE 'undo_tbs.ibu';

# CREATION DE TABLE TEMPORAIRE

ALTER TABLE client ADD client_total_cmd NUMERIC(8) NULL;
CREATE TEMPORARY TABLE temp_table AS
SELECT client_id, SUM(cmd_total_nb_produit) as total FROM client 
INNER JOIN commande ON cmd_client_id = client_id 
GROUP BY cmd_client_id; 
SELECT * FROM temp_table;

UPDATE client 
SET client_total_cmd = (SELECT total
FROM temp_table 
WHERE client.client_id = temp_table.client_id) ;

DROP TEMPORARY TABLE temp_table;

# CREATION DES SELECTIONS

SELECT CONCAT("L'employer avec l'ID n°", CONVERT(employe_id, CHAR(20)), " ( ", employe_nom, " ", employe_prenom, " ) a rapporter ", CONVERT(SUM(cmd_total_prix), CHAR(20)), " € et a vendu ", CONVERT(SUM(cmd_total_nb_produit), CHAR(20)) ," produits.") AS STATISTIQUES
FROM TD_FINAL_POMME_DONALD.employe INNER JOIN TD_FINAL_POMME_DONALD.commande ON commande.cmd_employer_id=employe.employe_id GROUP BY employe_id;

SELECT CONCAT('La plus grande commande de ', client_nom, ' ', client_prenom, ', client n°', client_id, ', est de ', max(cmd_total_prix), ' €')
FROM TD_FINAL_POMME_DONALD.client INNER JOIN TD_FINAL_POMME_DONALD.commande ON commande.cmd_client_id=client.client_id GROUP BY client_id;

SELECT CONCAT('Le produit ', produit_nom ) AS NOM, CONCAT('ID n°', produit_id) AS ID, CONCAT('de type ',categorie_nom) AS Categorie, CONCAT('a un stock de ', produit_stock, ' produits')
FROM TD_FINAL_POMME_DONALD.produit INNER JOIN TD_FINAL_POMME_DONALD.categorie ON categorie.categorie_id = produit.produit_categorie_id

# CREATION DES VUES

CREATE OR REPLACE VIEW v_Top_Commande_Client AS
SELECT client_id, client_nom, client_prenom, cmd_id, cmd_total_prix FROM TD_FINAL_POMME_DONALD.client
INNER JOIN TD_FINAL_POMME_DONALD.commande ON (cmd_client_id = client_id )
ORDER BY cmd_total_prix DESC 
LIMIT 3

CREATE OR REPLACE VIEW v_Top_Employe AS
SELECT employe_id, employe_nom, employe_prenom, role_nom FROM TD_FINAL_POMME_DONALD.commande
INNER JOIN TD_FINAL_POMME_DONALD.employe ON (employe_id = cmd_employer_id)
INNER JOIN TD_FINAL_POMME_DONALD.role ON (role_id = employe_role_id )
GROUP BY cmd_employer_id
ORDER BY cmd_total_prix DESC;
# CREATION DES INDEX

ALTER TABLE TD_FINAL_POMME_DONALD.client ADD INDEX Client_pnom (client_nom, client_prenom);
ALTER TABLE TD_FINAL_POMME_DONALD.employe ADD INDEX Employe_pnom (employe_nom, employe_prenom);
ALTER TABLE TD_FINAL_POMME_DONALD.produit ADD INDEX Produit_stat (produit_nom, produit_prix, produit_stock ASC);

# CREATION DES FUNCTIONS

DELIMITER //

DROP FUNCTION Stat_Employe//
CREATE FUNCTION `Stat_Employe`(id_employe INT) RETURNS varchar(255) NOT DETERMINISTIC
BEGIN
        DECLARE var_concat VARCHAR(255);
        SELECT CONCAT("L'employer avec l'ID n°", CONVERT(employe_id, CHAR(20)), " ( ", employe_nom, " ", employe_prenom, " ) a rapporter ", CONVERT(SUM(cmd_total_prix), CHAR(20)), " € et a vendu ", CONVERT(SUM(cmd_total_nb_produit), CHAR(20)) ," produits.")
        INTO var_concat 
        FROM TD_FINAL_POMME_DONALD.employe 
        INNER JOIN TD_FINAL_POMME_DONALD.commande ON commande.cmd_employer_id=employe.employe_id 
        WHERE employe_id = id_employe
        GROUP BY employe_id;
        RETURN var_concat;
END//
SELECT Stat_Employe(3)//

DROP FUNCTION Get_Commande//
CREATE FUNCTION `Get_Commande`(id_commande INT) RETURNS varchar(255) NOT DETERMINISTIC
BEGIN
        DECLARE var_concat VARCHAR(255);
        SELECT CONCAT("La commande avec l'ID n°", CONVERT(cmd_id, CHAR(20)), " vendu par ", employe_nom , " ", employe_prenom, " a ", client_nom , " " , client_prenom , " d'une valeur de ", CONVERT(cmd_total_prix, CHAR(20)), "€ contenait ", CONVERT(cmd_total_nb_produit, CHAR(20)) ," produits.")
        INTO var_concat 
        FROM TD_FINAL_POMME_DONALD.commande 
        INNER JOIN TD_FINAL_POMME_DONALD.client ON client.client_id=commande.cmd_client_id 
        INNER JOIN TD_FINAL_POMME_DONALD.employe ON employe.employe_id=commande.cmd_employer_id 
        WHERE cmd_id = id_commande;
        RETURN var_concat;
END//
SELECT Get_Commande(2)//

# CREATION DES PROCEDURE

DROP PROCEDURE Gerer_Stock//
CREATE PROCEDURE `Gerer_Stock`(IN id_produit INTEGER, IN stock_to_remove INTEGER, IN type_of_modif VARCHAR(1))
BEGIN
    SET @old_stock = 0;
    
    SELECT produit_stock INTO @old_stock FROM produit WHERE produit_id = id_produit;
    
    UPDATE produit
    SET produit_stock = CASE
        WHEN type_of_modif = "+" THEN (@old_stock + stock_to_remove)
        WHEN type_of_modif = "-" THEN (@old_stock - stock_to_remove)
    END
    WHERE produit_id = id_produit;
END//
CALL `Gerer_Stock`(2, 120, "-")//

DROP PROCEDURE Add_commande//
CREATE PROCEDURE `Add_commande`(IN nom_client VARCHAR(255), IN prenom_client VARCHAR(255), IN id_employe INTEGER, IN all_produits VARCHAR(255)) 
BEGIN
    DECLARE PRODUIT_EXIST BOOLEAN DEFAULT FALSE;
    DECLARE CLIENT_EXIST BOOLEAN DEFAULT FALSE;

    SET @nombre_produit := 0;
    SET @prix_total := 0;
    SET @produits = all_produits;
    produit_loop: LOOP 
        SET @produit = SUBSTRING_INDEX( @produits, "-", -1 );
        SET @produits = SUBSTRING(@produits, 1 , LENGTH(@produits) - (LENGTH(@produit)+1));
        IF LENGTH(@produits) > 0 THEN
            SELECT NOT NULL produit_nom
            INTO PRODUIT_EXIST
            FROM TD_FINAL_POMME_DONALD.produit WHERE UPPER(produit_nom) = UPPER(@produit);
        
            IF PRODUIT_EXIST = TRUE THEN
                SET @prix_total := @prix_total + (SELECT produit_prix FROM TD_FINAL_POMME_DONALD.produit WHERE UPPER(produit_nom) = UPPER(@produit));
                SET @nombre_produit := @nombre_produit + 1;
                CALL `Gerer_Stock`(produit_id, 1, "-");
            ELSE SELECT "Erreur dans la commande un produit qui n'existe pas !" as "ERROR";
            END IF;
        ELSE LEAVE produit_loop;    
        END IF;    
    END LOOP produit_loop;

    SELECT NOT NULL client_nom
    INTO CLIENT_EXIST
    FROM TD_FINAL_POMME_DONALD.client WHERE UPPER(client_nom) = UPPER(nom_client) AND UPPER(client_prenom) = UPPER(prenom_client);
    
    IF CLIENT_EXIST = FALSE THEN
        INSERT INTO TD_FINAL_POMME_DONALD.client (client_nom, client_prenom) VALUES ( nom_client, prenom_client );
        SET @id_client := (SELECT max(client_id) FROM TD_FINAL_POMME_DONALD.client);      
    ELSE SET @id_client := (SELECT client_id  FROM TD_FINAL_POMME_DONALD.client WHERE UPPER(client_nom) = UPPER(nom_client) AND UPPER(client_prenom) = UPPER(prenom_client));     
    END IF;

    SET @date := (SELECT NOW()); 
    
    INSERT INTO TD_FINAL_POMME_DONALD.commande (cmd_client_id, cmd_employer_id, cmd_total_prix, cmd_total_nb_produit, cmd_date) VALUES ( @id_client, id_employe, @prix_total, @nombre_produit, @date );
END//
CALL `Add_commande`('Doe', 'John', 2, 'Grand Pomme-Wrap-PommeNuggets-Salade-PommeFlurry-Caco Calo')//

DROP PROCEDURE Update_total//
CREATE PROCEDURE `Update_total`()
BEGIN
    SET @index := (SELECT max(client_id) FROM TD_FINAL_POMME_DONALD.client);
    WHILE @index > 0 DO
        UPDATE TD_FINAL_POMME_DONALD.client
        SET client_total_cmd = ( 
            SELECT SUM(cmd_total_nb_produit) FROM TD_FINAL_POMME_DONALD.commande  
            WHERE cmd_client_id = @index
        )
        WHERE client_id = @index;
        SET @index := @index - 1;
    END WHILE;
END//
CALL `Update_total`()//

DELIMITER ;

# CREATION UTILISATEUR

CREATE USER 'usr_employe'@'localhost' IDENTIFIED BY 'usr_employe';

CREATE USER 'usr_manager'@'localhost' IDENTIFIED BY 'usr_manager';

# CREATION DES PRIVILEGES

GRANT ALL ON *.* TO 'MANAGER';

GRANT SELECT, UPDATE, INSERT, DELETE ON YNOV.CLIENT TO 'EMPLOYE';

# CREATION DES ROLES 

CREATE ROLE EMPLOYE;
CREATE ROLE MANAGER;

GRANT 'EMPLOYE' TO 'usr_employe'@'localhost';
GRANT 'MANAGER' TO 'usr_manager'@'localhost';

# CREATION DES MOTS DE PASSE

ALTER USER 'usr_manager'@'localhost' 
WITH MAX_QUERIES_PER_HOUR 600
PASSWORD EXPIRE INTERVAL 120 DAY
PASSWORD HISTORY 5
FAILED_LOGIN_ATTEMPTS 4
PASSWORD_LOCK_TIME 2
ACCOUNT UNLOCK;

ALTER USER 'usr_employe'@'localhost' 