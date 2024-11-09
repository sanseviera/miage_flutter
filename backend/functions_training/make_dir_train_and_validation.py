import os
import shutil
from pathlib import Path
from random import shuffle  # Importer la fonction shuffle

def makeDirTrainAndValidation(data_dir, separator_1=0.6, separator_2=0.9):
    """
    Pour comprendre les séparateurs, voici un exemple : [train, test, validation] = [0.6, 0.2, 0.2]

    """
    # Utiliser pathlib pour gérer les chemins
    data_dir_all = Path(data_dir+'all')
    data_dir = Path(data_dir)
    
    

    # Supprimer les répertoires 'train', 'validation' et 'test' s'ils existent
    # pour éviter de mélanger les anciennes données avec les nouvelles
    if (data_dir / 'train').exists():
        shutil.rmtree(data_dir / 'train')
    if (data_dir / 'validation').exists():
        shutil.rmtree(data_dir / 'validation')
    if (data_dir / 'test').exists():
        shutil.rmtree(data_dir / 'test')
            

    # Parcourir chaque sous-dossier dans le répertoire de données
    for dir in data_dir_all.iterdir():
        if dir.is_dir():
            # Lister les fichiers
            files = list(dir.iterdir())  # Utilisation de Path.iterdir() pour obtenir des objets Path
            shuffle(files)
            total_files = len(files)
            
            # Calcul des index de séparation
            split_index_1 = int(total_files * separator_1)  # Validation jusqu'à cet index
            split_index_2 = int(total_files * separator_2)  # Test jusqu'à cet index
            

            val_dir = data_dir / 'validation' / dir.name
            train_dir = data_dir / 'train' / dir.name
            test_dir = data_dir / 'test' / dir.name


            # Créer les répertoires 'validation', 'train' et 'test'
            val_dir.mkdir(parents=True, exist_ok=True)
            train_dir.mkdir(parents=True, exist_ok=True)
            test_dir.mkdir(parents=True, exist_ok=True)

            # Parcourir les fichiers et les copier dans les dossiers appropriés
            for i, file_path in enumerate(files):
                if file_path.is_file():  # Vérifie si c'est bien un fichier
                    if i < split_index_1 : # Si l'index est inférieur à l'index de séparation 1, on copie dans le dossier de validation
                          shutil.copy(file_path, train_dir / file_path.name)
                    elif i < split_index_2: # Si l'index est inférieur à l'index de séparation 2, on copie dans le dossier de test
                        shutil.copy(file_path, val_dir / file_path.name)
                    else:
                        shutil.copy(file_path, test_dir / file_path.name)
                else:
                    print(f"Le chemin {file_path} n'est pas un fichier, il sera ignoré.")
