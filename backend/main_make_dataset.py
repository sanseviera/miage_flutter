import os
import json
import random 
import shutil
import tkinter as tk
from keras.models import load_model
from keras.preprocessing import image
import numpy as np
import os
from PIL import Image, ImageTk

# Chemin du dossier contenant les fichiers JSON
folder_path_styles = './dataset/all_untreated/styles/'
folder_path_images = './dataset/all_untreated/images/'
folder_path_all = './dataset/all/'

# Dictionnaire pour stocker les sous-catégories et leur nombre d'occurrences
json_categorie_vetement = {}

def netoyer_dossier(folder_path):
    """
    Fonction pour nettoyer un dossier en le supprimant s'il existe et en le recréant.
    """
    # Supprimer le dossier s'il existe
    if os.path.exists(folder_path):
        shutil.rmtree(folder_path)
    # Créer le dossier
    os.makedirs(folder_path, exist_ok=True)


def add_image_to_sub_category(filename, name_folder_etiquette):
    """
    """
     # Copie de l'image
    image_name = filename[:-5] + '.jpg'
    image_path = folder_path_images + image_name
    if os.path.exists(image_path):
    # Utiliser shutil.copy pour copier le fichier
        shutil.copy(image_path, folder_path_all + name_folder_etiquette +'/' + image_name)
    else:
        print(f"L'image {image_name} n'existe pas.")

def sub_traitement(sub_category,bool_make_fold):
    if sub_category in ['Shoes']:
        if bool_make_fold : os.makedirs(folder_path_all + 'shoes', exist_ok=True)
        add_image_to_sub_category(filename, 'shoes')
    elif sub_category in ['Topwear']:
        if bool_make_fold : os.makedirs(folder_path_all + 'topwear', exist_ok=True)
        add_image_to_sub_category(filename, 'topwear')
    elif sub_category in ['Belts']:
        if bool_make_fold : os.makedirs(folder_path_all + 'belts', exist_ok=True)
        add_image_to_sub_category(filename, 'belts')

def delete_aleatoire_file(folder):
    """
    Fonction pour supprimer une image aléatoire dans le dossier 'images'.
    """
    # Liste des fichiers dans le dossier
    file_list = os.listdir(folder)
    if file_list:
        # Choix aléatoire d'un fichier
        file_to_delete = random.choice(file_list)
        # Suppression du fichier
        os.remove(os.path.join(folder, file_to_delete))
        print(f"Fichier {file_to_delete} supprimé avec succès.")
    else:
        print("Aucun fichier à supprimer dans le dossier.")

def equilibrage_classes(folder_path):
    """
    Fonction pour équilibrer les classes en supprimant des images aléatoires.
    """
    # Dictionnaire pour stocker le nombre d'images par classe
    class_count = {}
    # Parcours de chaque sous-dossier
    for sub_folder in os.listdir(folder_path):
        sub_folder_path = os.path.join(folder_path, sub_folder)
        # Vérification si c'est un dossier
        if os.path.isdir(sub_folder_path):
            # Compter le nombre d'images dans le dossier
            num_files = len(os.listdir(sub_folder_path))
            # Stocker le nombre d'images dans le dictionnaire
            class_count[sub_folder] = num_files
    # Affichage du nombre d'images par classe
    print(f"Nombre d'images par classe : {class_count}")
    # Calcul du nombre minimum d'images par classe
    min_count = min(class_count.values())
    print(f"Nombre minimum d'images par classe : {min_count}")
    # Suppression d'images aléatoires pour équilibrer les classes
    for sub_folder in os.listdir(folder_path):
        sub_folder_path = os.path.join(folder_path, sub_folder)
        # Vérification si c'est un dossier
        if os.path.isdir(sub_folder_path):
            # Liste des fichiers dans le dossier
            file_list = os.listdir(sub_folder_path)
            # Calcul du nombre d'images à supprimer
            num_files_to_delete = len(file_list) - min_count
            # Suppression d'images aléatoires
            for _ in range(num_files_to_delete):
                delete_aleatoire_file(sub_folder_path)

# Fonction pour extraire et compter les occurrences des sous-catégories dans un fichier JSON
def traitement(json_file,filename):
    try:
        # Ouvre et charge le fichier JSON
        with open(json_file, 'r', encoding='utf-8') as f:
            data = json.load(f)
            
            # Récupération de la sous-catégorie
            sub_category = data['data']['subCategory']['typeName']
            
            # Si la sous-catégorie est déjà dans le dictionnaire, on incrémente
            # Si la sous-catégorie nous intéresse, on crée un dossier et on y met l'image
            if sub_category in json_categorie_vetement:
                json_categorie_vetement[sub_category] += 1
                sub_traitement(sub_category,False)
            # Sinon, on la crée et on l'initialise à 1
            # Si la sous-catégorie nous intéresse, on y met l'image
            else:
                # Sinon, on l'initialise à 1
                json_categorie_vetement[sub_category] = 1
                sub_traitement(sub_category,True)

    
    except Exception as e:
        print(f"Erreur avec le fichier {json_file}: {e}")


netoyer_dossier(folder_path_all)

# Parcours de tous les fichiers dans le dossier
for filename in os.listdir(folder_path_styles):
    if filename.endswith(".json"):
        # Chemin complet du fichier
        file_path = os.path.join(folder_path_styles, filename)
        
        print(f"Traitement du fichier {file_path}...")
        # Compte la sous-catégorie pour chaque fichier JSON
        traitement(file_path,filename)


equilibrage_classes(folder_path_all)

# Affichage de toutes les catégories de vêtements trouvées et de leurs occurrences
print(f"Ensemble des catégories de vêtements : {json_categorie_vetement}")