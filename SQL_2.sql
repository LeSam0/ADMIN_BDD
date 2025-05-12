USE TD_FINAL_POMME_DONALD;

# DONNEES CATEGORIE 

INSERT INTO TD_FINAL_POMME_DONALD.categorie (categorie_nom) VALUES ('Burgers');
INSERT INTO TD_FINAL_POMME_DONALD.categorie (categorie_nom) VALUES ('Salades');
INSERT INTO TD_FINAL_POMME_DONALD.categorie (categorie_nom) VALUES ('Boissons');
INSERT INTO TD_FINAL_POMME_DONALD.categorie (categorie_nom) VALUES ('Desserts');

# DONNEES PRODUITS

INSERT INTO TD_FINAL_POMME_DONALD.produit (produit_nom, produit_categorie_id, produit_prix, produit_stock) VALUES ('Grand Pomme', 1, 11.66, 45);
INSERT INTO TD_FINAL_POMME_DONALD.produit (produit_nom, produit_categorie_id, produit_prix, produit_stock) VALUES ('Wrap', 1, 5.65, 68);
INSERT INTO TD_FINAL_POMME_DONALD.produit (produit_nom, produit_categorie_id, produit_prix, produit_stock) VALUES ('PommeNuggets', 1, 9.99, 76);
INSERT INTO TD_FINAL_POMME_DONALD.produit (produit_nom, produit_categorie_id, produit_prix, produit_stock) VALUES ('Salade', 2, 10.65, 999);
INSERT INTO TD_FINAL_POMME_DONALD.produit (produit_nom, produit_categorie_id, produit_prix, produit_stock) VALUES ('PommeFlurry', 4, 7.95, 65);
INSERT INTO TD_FINAL_POMME_DONALD.produit (produit_nom, produit_categorie_id, produit_prix, produit_stock) VALUES ('Caco Calo', 3, 5.99, 100);

# DONNEES ROLE

INSERT INTO TD_FINAL_POMME_DONALD.role (role_nom) VALUES ('Manager');
INSERT INTO TD_FINAL_POMME_DONALD.role (role_nom) VALUES ('Employe Polyvalant');

# DONNEES EMPLOYE

INSERT INTO TD_FINAL_POMME_DONALD.employe (employe_nom, employe_prenom, employe_role_id) VALUES ('PommeCartney', 'Brian', 1);
INSERT INTO TD_FINAL_POMME_DONALD.employe (employe_nom, employe_prenom, employe_role_id) VALUES ('Smith', 'Britney', 2);
INSERT INTO TD_FINAL_POMME_DONALD.employe (employe_nom, employe_prenom, employe_role_id) VALUES ('Davis', 'Leon', 2);

# DONNEES CLIENT

INSERT INTO TD_FINAL_POMME_DONALD.client (client_nom, client_prenom) VALUES ('Williams', 'Isaac');
INSERT INTO TD_FINAL_POMME_DONALD.client (client_nom, client_prenom) VALUES ('Brown', 'Tessa');
INSERT INTO TD_FINAL_POMME_DONALD.client (client_nom, client_prenom) VALUES ('Jones', 'Joyce');

# DONNEES COMMANDE

INSERT INTO TD_FINAL_POMME_DONALD.commande (cmd_client_id, cmd_employer_id, cmd_total_prix, cmd_total_nb_produit, cmd_date) VALUES ( 1, 2, 25.59, 3, "2025-05-12");
INSERT INTO TD_FINAL_POMME_DONALD.commande (cmd_client_id, cmd_employer_id, cmd_total_prix, cmd_total_nb_produit, cmd_date) VALUES ( 1, 3, 51.85, 5, "2025-01-24");
INSERT INTO TD_FINAL_POMME_DONALD.commande (cmd_client_id, cmd_employer_id, cmd_total_prix, cmd_total_nb_produit, cmd_date) VALUES ( 1, 3, 11.51, 1, "2025-04-05");
INSERT INTO TD_FINAL_POMME_DONALD.commande (cmd_client_id, cmd_employer_id, cmd_total_prix, cmd_total_nb_produit, cmd_date) VALUES ( 3, 3, 24.85, 2, "2025-05-10");
INSERT INTO TD_FINAL_POMME_DONALD.commande (cmd_client_id, cmd_employer_id, cmd_total_prix, cmd_total_nb_produit, cmd_date) VALUES ( 2, 2, 30.20, 5, "2025-05-01");
INSERT INTO TD_FINAL_POMME_DONALD.commande (cmd_client_id, cmd_employer_id, cmd_total_prix, cmd_total_nb_produit, cmd_date) VALUES ( 2, 3, 45.25, 6, "2025-01-20");
INSERT INTO TD_FINAL_POMME_DONALD.commande (cmd_client_id, cmd_employer_id, cmd_total_prix, cmd_total_nb_produit, cmd_date) VALUES ( 2, 2, 40.19, 5, "2025-02-28");
INSERT INTO TD_FINAL_POMME_DONALD.commande (cmd_client_id, cmd_employer_id, cmd_total_prix, cmd_total_nb_produit, cmd_date) VALUES ( 2, 2, 14.99, 3, "2025-03-30");