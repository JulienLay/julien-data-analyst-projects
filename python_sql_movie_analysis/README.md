# Python + SQL Movie Analysis

Ce projet est un mini-projet de **Data Analysis** sur le dataset [MovieLens](https://grouplens.org/datasets/movielens/) pour illustrer mes compétences en Python, SQL et analyse de données.  

---

## Objectifs du projet

- Explorer et analyser les données utilisateurs, films et notes.  
- Calculer des métriques :  
  - Moyenne des notes par genre  
  - Moyenne des notes par tranche d'âge du film  
  - Corrélation nombre de votes vs note moyenne  
- Visualiser les résultats avec **Matplotlib** et **Seaborn**.  
- Réaliser une **prédiction simple** (Linear Regression) pour estimer la note d’un film à partir des genres et de son âge.  

---

## Étapes principales du notebook

1. **Import des données** avec `pandas`.  
2. **Prétraitement** :
   - Conversion des dates en datetime
   - Calcul de l'année de sortie et de l'âge des films
   - Gestion des valeurs manquantes
3. **Chargement des données dans SQLite** pour démontrer les compétences SQL.  
4. **Analyse exploratoire** :
   - Moyenne des notes par genre et par tranche d’âge
   - Corrélation votes vs note moyenne
5. **Visualisations** :
   - Heatmap des notes par genre
   - Boxplot par tranche d’âge
   - Scatter plot votes vs note
6. **Mini-prédiction** :
   - Linear Regression pour prédire la note d’un film
   - Gestion des valeurs manquantes avec `SimpleImputer`
   - Séparation train/test et calcul du R²

---

## Compétences démontrées

- Python (Pandas, Matplotlib, Seaborn, scikit-learn)  
- SQL (via SQLite)  
- Data Cleaning / Prétraitement  
- Visualisation et storytelling de données  
- Mini-modélisation prédictive  

---

## Comment utiliser

1. Cloner le projet :  

```
git clone https://github.com/JulienLay/julien-data-analyst-projects/tree/main/python_sql_movie_analysis
```

2. Installer les dépendances :

```
pip install pandas matplotlib seaborn scikit-learn
```

3. Ouvrir le notebook `notebooks/movie_analysis.ipynb` et exécuter les cellules.