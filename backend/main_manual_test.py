import tkinter as tk
from keras.models import load_model
from keras.preprocessing import image
import numpy as np
import os
from PIL import Image, ImageTk



def load_and_predict(img_path, model):
    try:
        # Charger et préparer l'image
        img = image.load_img(img_path, target_size=(80, 80))  # Ajuste la taille selon ton modèle
        img_array = image.img_to_array(img)  # Convertir en tableau numpy
        img_array = img_array / 255.0  # Normaliser l'image (si c'était fait lors de l'entraînement)
        img_array = np.expand_dims(img_array, axis=0)  # Ajouter une dimension pour le batch

        # Prédictions
        predictions = model.predict(img_array)
        
        # Afficher les prédictions brutes pour diagnostiquer le problème
        print(f"Prédictions brutes : {predictions}")
        
        # Obtenir l'indice de la classe avec la plus haute probabilité
        class_index = np.argmax(predictions[0])

        return class_index, img
    except Exception as e:
        print(f"Erreur lors de la prédiction : {e}")
        return None, None


# Liste des classes
class_names = [ 'belts', 'shoes','topwear']
# Dossier contenant les images
image_dir = './dataset/test/topwear/'

# Charger le modèle depuis le fichier
try:
    model_loaded = load_model('mon_modele.h5')
except Exception as e:
    print(f"Erreur lors du chargement du modèle : {e}")
    exit(1)


# Liste des images dans le dossier
if not os.path.exists(image_dir):
    print("Le répertoire spécifié n'existe pas.")
    exit(1)

image_list = os.listdir(image_dir)
if not image_list:
    print("Aucun fichier d'image trouvé dans le répertoire spécifié.")
    exit(1)

current_image_index = 0

# Créer la fenêtre principale
root = tk.Tk()
root.title("Prédiction d'Images")

# Créer un label pour afficher l'image
label_image = tk.Label(root)
label_image.pack()

# Créer un label pour afficher la prédiction
label_prediction = tk.Label(root, text="", font=("Arial", 16))
label_prediction.pack()

def show_next_image():
    global current_image_index
    if current_image_index < len(image_list):
        img_path = os.path.join(image_dir, image_list[current_image_index])  # Construire le chemin complet
        class_index, img = load_and_predict(img_path, model_loaded)

        # Vérification que l'indice prédit est valide
        if class_index is not None and 0 <= class_index < len(class_names):
            predicted_class_name = class_names[class_index]  # Obtenir le nom de la classe
        else:
            predicted_class_name = "Classe inconnue"

        # Mise à jour de l'image dans l'interface
        img_pil = Image.open(img_path)
        img_pil = img_pil.resize((300, 300))  # Redimensionner pour mieux s'adapter à la fenêtre
        img_tk = ImageTk.PhotoImage(img_pil)

        label_image.config(image=img_tk)
        label_image.image = img_tk  # Nécessaire pour garder une référence à l'image
        
        # Mettre à jour l'étiquette avec la prédiction
        label_prediction.config(text=f'Classe prédite : {predicted_class_name}')

        # Passer à l'image suivante
        current_image_index += 1
    else:
        label_prediction.config(text="Plus d'images à afficher.")
        button_next.config(state=tk.DISABLED)

# Créer le bouton "Suivant"
button_next = tk.Button(root, text="Suivant", command=show_next_image)
button_next.pack()

# Lancer l'affichage de la première image
show_next_image()

# Lancer la boucle principale de la fenêtre
root.mainloop()
