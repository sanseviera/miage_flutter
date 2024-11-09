# Présentation des fichiers Main

# Lancer le projet (Méthode 1 - conseillé)
1. créer l'environnement ```python -m venv venv```
1. connection à l'environnement virtuel : ```source venv/bin/activate``` (mac os) ou ```venv\Scripts\activate`` (windows)
1. ```pip install -r requirements.txt```
1. Ajouter le ```mon_modele.h5``` qui a était envoyé par mail dans backend
1. Lancer les commandes suivante :
    * ```fastapi dev main_api_rest.py```  

# Lancer le projet (Méthode 2)
1. installation de python
1. installation de nos bibliothèques
    * ```pip install numpy```
    * ```pip install keras --upgrade```
    * ```pip install tensorflow```
    * ```pip install Pillow```
    * ```pip install -U matplotlib```
    * ```pip install -U scikit-learn```
    * ```pip install seaborn```
    * ```pip install "fastapi[standard]"```
1. Lancer les commandes suivante :
    * ```fastapi dev main_api_rest.py```  



# Lien 
* **dataset :** https://www.kaggle.com/datasets/paramaggarwal/fashion-product-images-dataset

# Autres
Des scripts inutilisés sont présents dans le code ; ils ont pour unique but de laisser des traces des différents traitements que j'ai dû effectuer pour obtenir le réseau de neurones fonctionnel (traitement du dataset, entraînement, etc.).