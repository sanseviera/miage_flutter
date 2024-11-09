import imghdr
from pathlib import Path

def checkFileIsGood(path_dir):
    """
    """
    is_good = True
    image_extensions = [".png", ".jpg"] # les extentions à tester
    img_type_accepted_by_tf = ["bmp", "gif", "jpeg", "png"] # les extentions acceptées par TensorFlow
    for filepath in Path(path_dir).rglob("*"): # permet de parcourir tous les fichiers et sous-dossiers dans le dossier spécifié par path_dir, ainsi que tous les fichiers contenus dans ces sous-dossiers.
        if filepath.suffix.lower() in image_extensions: # si l'extention est dans la liste des extentions à tester
            img_type = imghdr.what(filepath) # on test le type de l'image
            if img_type is None: 
                print(f"{filepath} is not an image") 
                is_good = False
            elif img_type not in img_type_accepted_by_tf: # si le type de l'image n'est pas accepté par TensorFlow
                print(f"{filepath} is a {img_type}, not accepted by TensorFlow")
                is_good = False
    return is_good

