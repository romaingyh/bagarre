from PIL import Image
import os


def crop_image(input_file, output_file):
    # Ouvrir l'image d'entrée
    image = Image.open(input_file)

    # Trouver les limites du personnage
    bbox = image.getbbox()

    # Recadrer l'image pour inclure seulement le personnage
    cropped = image.crop(bbox)

    # Enregistrer l'image recadrée et créer le ficher
    cropped.save(output_file)

    print(f"L'image a été recadrée et enregistrée sous {output_file}")


# Trouver tous les fichiers PNG dans le dossier images
input_files = []
for root, dirs, files in os.walk("sprites"):
    for file in files:
        if file.endswith(".png"):
            input_files.append(os.path.join(root, file))

print(f"Nombre d'images à recadrer: {len(input_files)}")

for input_file in input_files:
    # Créer le chemin de sortie
    output_file = input_file.replace("sprites", "images")

    # Créer le dossier de sortie
    os.makedirs(os.path.dirname(output_file), exist_ok=True)

    # Recadrer l'image
    crop_image(input_file, output_file)
