/*=================================================================================================================================*/
						-- INTERROGATION DES TABLES
/*=================================================================================================================================*/

-- Commande 'SELECT *' pour afficher les informations des tables
SELECT * FROM clients;
SELECT * FROM produits;
SELECT * FROM ventes;



-- Commande 'SELECT IDSTINCT' pour afficher les valeurs distincte d'une colonne: 
SELECT DISTINCT NomFournisseur FROM fournisseurs;



-- clause WHERE pour filtrer les données: exemple filtre sur les produits avec un prix unitaire supérieur à 200€
SELECT * FROM produits
WHERE PrixUnitaire > 200;

-- filtre des produits avec un prix unitaire compris entre 50 et 100€
SELECT NomProduit, PrixUnitaire FROM produits
WHERE PrixUnitaire BETWEEN 50 AND 100;

-- filtre des informations sur un seul produit: exemple produit 'Dyson Vacuum'
SELECT * FROM produits
WHERE NomProduit = 'Dyson Vacuum';

-- clauses LIKE et WHERE: exemple Noms des employes dont le nom commence par "a" et se termine par "s"
SELECT * FROM employes
WHERE Nom LIKE "a%s";



-- expressions régulière avec la clause REGEXP: exemple liste des produits avec le terme "TV"
SELECT * FROM produits
WHERE NomProduit REGEXP "TV";

-- Noms des produits qui commencent par la lettre D
SELECT * FROM produits
WHERE NomProduit REGEXP "^D";

-- Noms des produits qui se termniment par la lettre M
SELECT * FROM produits
WHERE NomProduit REGEXP "M$";

-- liste des produits des fournisseurs 51 ou 93
SELECT * FROM produits
WHERE FournisseurID REGEXP "51|93";



-- clause ORDER BY pour ordonner une requête: exemple ordonner les produits du plus couteux au moins couteux
SELECT * FROM produits
ORDER BY PrixUnitaire DESC;



-- clause GROUP BY pour faire des agrégations: exemple interroger les dix produits les plus vendus
SELECT ProduitID, SUM(QuantiteVendue), SUM(MontantTotal) as prix_total FROM ventes
GROUP BY ProduitID
ORDER BY prix_total DESC
LIMIT 10;



-- les fonctions d'agregation: SUM(), COUNT(), AVG(), MAX(), MIN()
-- produit le plus cher et le moins cher
SELECT MAX(PrixUnitaire), MIN(PrixUnitaire) FROM produits;

-- Liste des 5 employés qui réalisent le plus gros chiffre d'affaire
SELECT EmployeID, SUM(MontantTotal) AS CA_emp FROM ventes
GROUP BY EmployeID
ORDER BY CA_emp DESC
LIMIT 5;

-- moyenne de dépense des clients
SELECT SUM(MontantTotal)/COUNT(ClientID) AS depense_moyenne FROM ventes;

-- chiffre d'affaire des ventes
SELECT SUM(MontantTotal) AS CA FROM ventes;

-- Chiffre d'affaire des ventes par année
SELECT YEAR(DateVente) AS annee, ROUND(SUM(MontantTotal), 2) AS year_sales FROM ventes
GROUP BY annee;

-- clause HAVING pour effectuer des filtres sur les fonctions d'agregtion 
-- exemple (liste des employés qui réalisent un chiffre d'affaire supérieur à 1000€ par an)
SELECT YEAR(DateVente) AS annee, EmployeID, AVG(MontantTotal) AS moyenne
FROM ventes
GROUP BY annee, EmployeID
HAVING moyenne > 1000;



/*=================================================================================================================================*/
						-- JOINTURES DES TABLES
/*=================================================================================================================================*/
-- rajouter les informations du client dans le tableau vente
SELECT * FROM ventes AS ve
JOIN clients AS cl USING(ClientID);

-- Pour chaque produit, interroger le nom et l'adresse du fournisseur
SELECT ProduitID, NomProduit, NomFournisseur, Adresse 
FROM produits
LEFT JOIN fournisseurs USING(FournisseurID);

-- Nom et prenom des 10 employes qui ont réalisé les plus gros chiffres d'affaires
SELECT Nom, Prenom, SUM(MontantTotal) AS CA_emp FROM employes
LEFT JOIN ventes USING(EmployeID)
GROUP BY Nom, Prenom
ORDER BY CA_emp DESC
LIMIT 10;

-- Nom, Prenom, adresse et nombre d'achat réalisé par chaque client
SELECT ClientID, Nom, Prenom, Adresse, COUNT(VenteID)
FROM ventes
LEFT JOIN clients USING(ClientID)
GROUP BY ClientID, Nom, Prenom, Adresse;

-- clause COALESCE pour remplacer les valeurs manquantes par une autre valeur
SELECT Nom, Prenom, COALESCE(AVG(MontantTotal), 0) AS moy
FROM clients
LEFT JOIN Ventes USING (ClientID)
GROUP BY Nom, Prenom;



/*=================================================================================================================================*/
                                                  -- CREATION DES VUES
/*=================================================================================================================================*/
-- créer une vue des ventes réalisées en 2021
CREATE VIEW ventes_2021 AS
SELECT * FROM ventes
WHERE YEAR(DateVente) = 2021;


/*=================================================================================================================================*/
						-- SOUS-REQUÊTES
/*=================================================================================================================================*/

-- Quelques exemples avec utilisation de sous-requêtes

-- liste des produits qui n'ont pas été vendus en 2023
SELECT * FROM produits
WHERE ProduitID NOT IN (
                         SELECT ProduitID FROM ventes
                         WHERE YEAR(DateVente) = "2023");

-- liste des clients qui ont un montant total d'achat supérieur à la moyenne historique des ventes
SELECT * FROM ventes
LEFT JOIN clients USING (ClientID)
WHERE MontantTotal > (SELECT AVG(MontantTotal) FROM ventes);

-- liste des employés qui n'ont réalisé aucune vente durant le mois de décembre 2021
SELECT * FROM employes
WHERE EmployeID NOT IN (
                         SELECT EmployeID FROM ventes
						 WHERE MONTH(DateVente) = "12" AND YEAR(DateVente) = "2021");


-- Clause FROM pour générer des sous-requêtes
-- exemple: taux de croissance du chiffre d'affaire entre 2021 et 2022

SELECT (CA_2022 - CA_2021)/CA_2021 AS TauxDeCroissance
FROM 
	(SELECT SUM(MontantTotal) AS CA_2021
	FROM ventes WHERE YEAR(DateVente) = 2021) AS temp,
    (SELECT SUM(MontantTotal) AS CA_2022
    FROM ventes WHERE YEAR(DateVente) = 2022) AS temp2;
