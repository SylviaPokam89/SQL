/*=================================================================================================*/
/*                 CREATION D'UN SCHEMA AVEC SES TABLES                              */
/*=================================================================================================*/

CREATE SCHEMA test

/* Création des tables dans le shéma "test"*/;

CREATE TABLE test.produits
(produitID INT PRIMARY KEY,
Nom VARCHAR(255),
categorie VARCHAR(255),
stock INT);

CREATE TABLE test.ventes
(venteID INT PRIMARY KEY,
dateVente datetime,
produitID INT,
quantité INT,
montantTotal double);

/* Modification des tables*/;
-- rajout d'une colonne "prixUnitaire" dans la table produits
ALTER TABLE test.produits ADD COLUMN prixUnitaire double; 

-- suppression de la colonne prixUnitaire mise dans la table ventes par erreur
ALTER TABLE test.ventes DROP COLUMN prixUnitaire;

-- mise à jour de la clé étrangère dans la table ventes
ALTER TABLE test.ventes ADD CONSTRAINT produitID
  FOREIGN KEY (produitID) REFERENCES test.produits(produitID);
  
  -- ajouter les valeurs dans les tables
  INSERT INTO test.produits VALUES 
  (1, "banane", "fruits", 20, 2.3),
  (2, "riz", "cereales", 14, 3.1), 
  (3, "tomates", "legumes", 25, 2.9),
  (4, "concombre", "legumes", 56, 2),
  (5, "steak", "viande", 34, 5.6);
  
  INSERT INTO test.ventes VALUES
  (1, "2022-10-12", 2, 5, 15.5),
  (2, "2022-11-12", 5, 6, 25.3),
  (3, "2023-01-25", 1, 3, 21),
  (4, "2023-03-04", 3, 10, 35.6);
  
