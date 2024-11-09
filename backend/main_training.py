import os
import shutil
import matplotlib.pyplot as plt
from keras.models import Sequential
from keras.layers import Conv2D, MaxPooling2D, Flatten, Dense, Dropout, Input
from sklearn.metrics import confusion_matrix
import numpy as np
import seaborn as sns
from PIL import Image
import tensorflow as tf
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from pathlib import Path
from functions_training.check_files_is_good import checkFileIsGood
from functions_training.make_dir_train_and_validation import makeDirTrainAndValidation
from sklearn.utils import class_weight

def afficher_images(data_generator, n_images=5):
    """
    Affiche quelques images à partir du générateur de données.
    
    :param data_generator: Un générateur d'images (ImageDataGenerator)
    :param n_images: Nombre d'images à afficher
    """
    # Récupérer un lot d'images et leurs étiquettes
    images, labels = next(data_generator)

    # Configuration de la taille de la figure
    plt.figure(figsize=(15, 10))
    
    # Affichage des images
    for i in range(n_images):
        plt.subplot(1, n_images, i + 1)  # 1 ligne, n_images colonnes
        # Vérifie la forme des images et ajuste l'affichage
        if images[i].shape[-1] == 1:  # Cas des images en niveaux de gris
            plt.imshow(images[i].reshape(300, 300), cmap='gray')  # Ajuste la forme pour les images en niveaux de gris
        else:  # Cas des images couleur
            plt.imshow(images[i])  # Affiche directement les images couleur
        plt.title(f"Label: {np.argmax(labels[i])}")  # Afficher l'étiquette (classe)
        plt.axis('off')  # Masquer les axes
    
    plt.tight_layout()
    plt.show()

data_dir = "./dataset/"
checkFileIsGood(data_dir)
makeDirTrainAndValidation(data_dir)

# ------------------------------------
# Charger les données des dataset de training et de validation, les normaliser et les augmenter
# ------------------------------------
# Normalisation et augmentation des données
datagen = ImageDataGenerator(
    rescale=1./255,
    rotation_range=20,
    width_shift_range=0.2,
    height_shift_range=0.2,
    shear_range=0.2,
    zoom_range=0.2,
    horizontal_flip=True,
    fill_mode='nearest'
)

# Chargement des données d'entraînement avec augmentation
train_data = datagen.flow_from_directory(
    os.path.join(data_dir, 'train'),
    target_size=(80, 80),
    batch_size=100,
    class_mode='categorical',
)
train_data.color_mode = 'grayscale'

# Chargement des données de validation (sans augmentation)
validation_data = datagen.flow_from_directory(
    os.path.join(data_dir, 'validation'),
    target_size=(80, 80),
    batch_size=100,
    class_mode='categorical',
)
validation_data.color_mode = 'grayscale'

# Chargement des données de test (sans augmentation)
test_data = datagen.flow_from_directory(
    os.path.join(data_dir, 'test'),
    target_size=(80, 80),
    batch_size=100,
    class_mode='categorical',
)
test_data.color_mode = 'grayscale'


# Vérifiez la cohérence des classes
print("Classes d'entraînement:", train_data.class_indices)
print("Classes de validation:", validation_data.class_indices)

# ------------------------------------
# Affichage de quelques images
# ------------------------------------
afficher_images(train_data, n_images=5)
afficher_images(validation_data, n_images=5)
afficher_images(test_data, n_images=5)


# ------------------------------------
# Construction du modèle
# ------------------------------------

model = Sequential([
    Input(shape=(80, 80, 3)),  # Utiliser Input pour définir la forme
    Conv2D(32, (3, 3), activation='relu'),
    MaxPooling2D(pool_size=(2, 2)),
    Conv2D(64, (3, 3), activation='relu'),
    MaxPooling2D(pool_size=(2, 2)),
    Conv2D(128, (3, 3), activation='relu'),
    MaxPooling2D(pool_size=(2, 2)),
    Flatten(),
    Dense(2048, activation='relu'),
    Dropout(0.1),
    Dense(1024, activation='relu'),
    Dense(512, activation='relu'),
    Dense(256, activation='relu'),
    Dense(128, activation='relu'),
    Dense(len(train_data.class_indices), activation='softmax')  # Ajustement pour le nombre de classes
])

model.compile(optimizer='adam', loss='categorical_crossentropy', metrics=['accuracy'])

# ------------------------------------
# Entraîner le modèle
# ------------------------------------

history = model.fit(train_data, validation_data=validation_data, epochs=15,)

# ------------------------------------
# Affichage des performances du modèle
# ------------------------------------
loss, accuracy = model.evaluate(test_data)
print(f'Loss: {loss}, Accuracy: {accuracy}')

# ------------------------------------
# Sauvegarder le modèle dans un fichier HDF5
# ------------------------------------
model.save('mon_modele.h5')

# ------------------------------------
# Afficher les courbes 
# ------------------------------------

plt.figure(figsize=(12, 4))

# Courbe de la perte
plt.subplot(1, 2, 1)
plt.plot(history.history['loss'], label='Train Loss')
plt.plot(history.history['val_loss'], label='Validation Loss')
plt.title('Courbe de la perte')
plt.xlabel('Époques')
plt.ylabel('Perte')
plt.legend()

# Courbe de la précision
plt.subplot(1, 2, 2)
plt.plot(history.history['accuracy'], label='Train Accuracy')
plt.plot(history.history['val_accuracy'], label='Validation Accuracy')
plt.title('Courbe de la précision')
plt.xlabel('Époques')
plt.ylabel('Précision')
plt.legend()

plt.tight_layout()
plt.savefig('./plots_and_data/courbes.png')
plt.show()

# ------------------------------------
# Afficher la matrice de confusion
# ------------------------------------

# Initialiser des listes pour stocker les labels et les prédictions
y_true = []
y_pred = []

# Itérer sur le générateur de test pour récupérer toutes les prédictions et les étiquettes
for batch in test_data:
    images, labels = batch
    y_true.extend(np.argmax(labels, axis=1))  # Ajouter les labels vrais
    predictions = model.predict(images)  # Prédire sur le batch
    y_pred.extend(np.argmax(predictions, axis=1))  # Ajouter les prédictions

# Convertir les listes en tableaux numpy
y_true = np.array(y_true)
y_pred = np.array(y_pred)

# Calculer la matrice de confusion
cm = confusion_matrix(y_true, y_pred)

