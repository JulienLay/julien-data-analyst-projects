# Mini Test Data Analyst - Analyse Ventes Brutes

## Description
Ce projet est un mini test de Data Analyst réalisé sur Excel.  
L’objectif est d’analyser un fichier de ventes brutes, en appliquant des techniques courantes de nettoyage, d’enrichissement, de synthèse et de visualisation de données.  
Il illustre la méthodologie d’un Data Analyst pour passer de données brutes à un reporting exploitable.

## Objectifs du projet
- Nettoyer les données brutes (formats, doublons, valeurs manquantes)
- Ajouter des colonnes calculées :
  - Chiffre d’affaires (`Quantité * Prix_unitaire`)
  - Mois/Année à partir de la date
  - Segment client via jointure avec un onglet de référence
- Créer des tableaux croisés dynamiques pour analyser :
  - Le chiffre d’affaires par client
  - Le chiffre d’affaires par pays et par mois
- Identifier le client avec le plus gros chiffre d’affaires
- Visualiser l’évolution mensuelle du chiffre d’affaires via un graphique Excel

## Workflow Data Analyst
1. **Import et inspection des données brutes**
   - Vérification des types de données (date, texte, nombres)
   - Recherche et suppression des doublons
2. **Nettoyage et préparation**
   - Conversion des dates au format correct
   - Suppression des valeurs incorrectes ou vides
3. **Enrichissement des données**
   - Calcul du chiffre d’affaires par ligne
   - Extraction du mois et année
   - Ajout du segment client depuis une table de référence (RECHERCHEX / INDEX-EQUIV)
4. **Analyse**
   - Création de tableaux croisés dynamiques
   - Filtrage par segment, pays, ou période
   - Tri pour identifier le top client
5. **Visualisation**
   - Graphique d’évolution du chiffre d’affaires par mois
   - Optionnel : filtrage par client ou segment pour comparaisons
6. **Reporting / vérification**
   - Contrôle de cohérence des calculs
   - Vérification des résultats du TCD et du graphique

## Technologies et outils
- Excel (Tableaux croisés dynamiques, Formules, Graphiques)
- Power Query (optionnel pour nettoyage et transformation)
- Méthodologie Data Analyst

## Résultat attendu
Un fichier Excel propre et structuré avec :
- Données brutes et enrichies
- Tableau croisé dynamique interactif
- Graphique clair montrant l’évolution du CA par mois
- Possibilité de filtrer par client ou segment