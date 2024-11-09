from keras.models import load_model
from keras.preprocessing import image

def load_and_predict(img_path, model):
    # Charger et redimensionner l'image
    img = image.load_img(img_path, target_size=(150, 150))  # Ajuste la taille selon ton modèle
    img_array = image.img_to_array(img)  # Convertir en tableau numpy
    img_array = img_array / 255.0  # Normaliser l'image (si c'était fait lors de l'entraînement)
    img_array = np.expand_dims(img_array, axis=0)  # Ajouter une dimension pour le batch

    # Faire une prédiction
    predictions = model.predict(img_array)
    class_index = np.argmax(predictions[0])  # Obtenir l'indice de la classe avec la probabilité la plus élevée

    return class_index

# ------------------------------------
# Charger le modèle depuis le fichier
# ------------------------------------
model_loaded = load_model('mon_modele.h5')

# ------------------------------------
# Exemple d'utilisation
# ------------------------------------
img_path = 'chemin/vers/ton/image_test.jpg'  # Remplace par le chemin de ton image
predicted_class = load_and_predict(img_path, model_loaded)
print(f'Classe prédite : {predicted_class}')