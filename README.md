================================================================================
                                RÉINSTALLER UN MACINTOSH PERFORMA 460 AVEC LINUX
================================================================================

Date: Février 2026
Système cible: Macintosh Performa 460
OS hôte: Linux (Debian/Ubuntu/Kaisen Linux)

================================================================================
TABLE DES MATIÈRES
================================================================================

1. INFORMATIONS SUR LE PERFORMA 460
2. MATÉRIEL ET LOGICIELS NÉCESSAIRES
3. PRÉPARATION DU SYSTÈME LINUX
4. TÉLÉCHARGEMENT DES IMAGES SYSTÈME
5. EXTRACTION DES FICHIERS .part
6. CRÉATION DES DISQUETTES D'INSTALLATION
7. PRÉPARATION DU MACINTOSH
8. INSTALLATION DU SYSTÈME
9. DÉPANNAGE
10. RESSOURCES ET LIENS

================================================================================
1. INFORMATIONS SUR LE PERFORMA 460
================================================================================

SPÉCIFICATIONS TECHNIQUES:
- Processeur: Motorola 68030 à 33 MHz
- RAM: 4 Mo (extensible à 36 Mo)
- Disque dur: 80 Mo SCSI
- Lecteur: SuperDrive 1.44 Mo (2HD, double face)
- Ports: SCSI, ADB, série, audio
- Date de sortie: Octobre 1993
- Date d'arrêt: Février 1994
- Équivalent éducation: LC III+

SYSTÈME D'ORIGINE:
- System 7.1P3 (oct-déc 1993)
- System 7.1P5 (après déc 1993)
- System Enabler 308 v1.0 REQUIS pour System 7.1

COMPATIBILITÉ SYSTÈME:
✓ System 7.0.1 à 7.1 (avec System Enabler 308)
✓ System 7.5 à 7.6.1 (PAS de System Enabler requis)
✓ Mac OS 8.0 à 8.1
✗ Mac OS 8.5+ (non supporté)



================================================================================
2. MATÉRIEL ET LOGICIELS NÉCESSAIRES
================================================================================

MATÉRIEL:
□ 19-20 disquettes 2HD (1.44 Mo) NEUVES ou en excellent état
□ Lecteur de disquettes USB ou interne compatible Linux
□ Macintosh Performa 460 fonctionnel
□ Clavier et souris ADB
□ Moniteur compatible (VGA ou Apple)
□ Câble d'alimentation

LOGICIELS LINUX:
□ hfsutils et hfsprogs (pour formater HFS)
□ unar ou HFSExplorer (pour extraire archives Mac)
□ dd (normalement préinstallé)
□ Java 11+ (pour HFSExplorer)

FICHIERS À TÉLÉCHARGER:
□ System 7.5.3 (19 images de disquettes)
□ Disk Tools / Utilities (disquette de boot)
□ (Optionnel) SuperBooter75 (utilitaires)
□ (Optionnel) System Enabler 308 (si System 7.1)



================================================================================
3. PRÉPARATION DU SYSTÈME LINUX
================================================================================

ÉTAPE 3.1 : Installation des outils nécessaires
------------------------------------------------

# Mise à jour du système
sudo apt-get update

# Installation des outils HFS
sudo apt-get install hfsutils hfsprogs

# Installation de unar (pour extraire archives Mac)
sudo apt-get install unar

# Installation de Java (pour HFSExplorer si nécessaire)
sudo apt-get install openjdk-11-jre

# Vérification du module floppy
lsmod | grep floppy

# Si absent, charger le module
sudo modprobe floppy

# Vérifier les permissions du lecteur
ls -l /dev/fd0

# Si nécessaire, ajuster les permissions
sudo chmod 666 /dev/fd0



ÉTAPE 3.2 : Création du dossier de travail
-------------------------------------------

mkdir -p ~/performa460/system753
mkdir -p ~/performa460/images_extracted
cd ~/performa460/system753



ÉTAPE 3.3 : Test du lecteur de disquettes
------------------------------------------

# Insérer une disquette test
# Vérifier la détection
dmesg | tail -20

# Devrait afficher quelque chose comme:
# floppy0: detected floppy disk change

# Vérifier avec lsblk
lsblk | grep fd0



================================================================================
4. TÉLÉCHARGEMENT DES IMAGES SYSTÈME
================================================================================

OPTION A : Macintosh Garden (Archive complète)
-----------------------------------------------

URL: https://macintoshgarden.org/apps/system-7-floppy-sets
Fichier: "7_5_3.sit" (86.12 MB)

# Télécharger manuellement via navigateur
# ou avec wget (si lien direct disponible)

cd ~/performa460/system753
# Placer le fichier 7_5_3.sit ici



OPTION B : Internet Archive (Images individuelles)
---------------------------------------------------

URL: https://archive.org/details/system7.5.3d

# Méthode 1: Téléchargement manuel via navigateur

# Méthode 2: wget pour télécharger toutes les images
cd ~/performa460/images_extracted

wget "https://archive.org/download/system7.5.3d/Install 1.image"
wget "https://archive.org/download/system7.5.3d/Install 2.image"
wget "https://archive.org/download/system7.5.3d/Install 3.image"
wget "https://archive.org/download/system7.5.3d/Install 4.image"
wget "https://archive.org/download/system7.5.3d/Install 5.image"
wget "https://archive.org/download/system7.5.3d/Install 6.image"
wget "https://archive.org/download/system7.5.3d/Install 7.image"
wget "https://archive.org/download/system7.5.3d/Install 8.image"
wget "https://archive.org/download/system7.5.3d/Install 9.image"
wget "https://archive.org/download/system7.5.3d/Install 10.image"
wget "https://archive.org/download/system7.5.3d/Install 11.image"
wget "https://archive.org/download/system7.5.3d/Install 12.image"
wget "https://archive.org/download/system7.5.3d/Install 13.image"
wget "https://archive.org/download/system7.5.3d/Install 14.image"
wget "https://archive.org/download/system7.5.3d/Install 15.image"
wget "https://archive.org/download/system7.5.3d/Install 16.image"
wget "https://archive.org/download/system7.5.3d/Install 17.image"
wget "https://archive.org/download/system7.5.3d/Install 18.image"
wget "https://archive.org/download/system7.5.3d/Install 19.image"
wget "https://archive.org/download/system7.5.3d/Disk Tools.image"

# Méthode 3: Téléchargement automatique complet
wget -r -np -nd -A "*.image" "https://archive.org/download/system7.5.3d/"

# Méthode 4: Avec Internet Archive CLI
pip3 install internetarchive
ia download system7.5.3d



OPTION C : Téléchargement SuperBooter75 (Utilitaires)
------------------------------------------------------

URL: https://vintageapple.org/gamba2/superbooter75.html

cd ~/performa460
wget https://vintageapple.org/gamba2/files/SuperBooter75.dsk



================================================================================
5. EXTRACTION DES FICHIERS .part
================================================================================

Si vous avez des fichiers .part et .part.rsrc (archives StuffIt segmentées)

PROBLÈME:
- 19 fichiers .part (1.2 Mo chacun)
- 19 fichiers .part.rsrc (743 octets chacun)

Ces fichiers doivent être EXTRAITS pour obtenir les vraies images .image



MÉTHODE 1 : Avec unar (Simple)
-------------------------------

cd ~/performa460/system753

# Tenter l'extraction du premier fichier
unar "Install 1.part"

# Si ça fonctionne, extraire tous les fichiers
for file in *.part; do
    echo ""
    echo "Extraction de $file..."
    echo ""
    unar "$file"
done

# Déplacer les images extraites
mv *.image ../images_extracted/
mv *.img ../images_extracted/
mv *.dsk ../images_extracted/



MÉTHODE 2 : Avec HFSExplorer (Si unar échoue)
----------------------------------------------

# Télécharger HFSExplorer
cd ~/Downloads
wget https://sourceforge.net/projects/catacombae/files/HFSExplorer/0.23.1/hfsexplorer-0_23_1-bin.zip

# Extraire
unzip hfsexplorer-0_23_1-bin.zip
cd hfsexplorer-0_23_1

# Rendre exécutable
chmod +x bin/hfsexplorer

# Lancer HFSExplorer
./bin/hfsexplorer

DANS HFSEXPLORER (Interface graphique):
1. File → Load file system from file
2. Naviguer vers ~/performa460/system753
3. Sélectionner "Install 1.part"
4. Clic droit sur le contenu → Extract
5. Choisir ~/performa460/images_extracted comme destination
6. Répéter pour tous les fichiers .part



MÉTHODE 3 : Avec macunpack (Alternative)
-----------------------------------------

# Installer macutils
sudo apt-get install macutils

cd ~/performa460/system753

# Essayer de décoder
for file in *.part; do
    macunpack "$file"
done



VÉRIFICATION DES FICHIERS EXTRAITS:
-----------------------------------

cd ~/performa460/images_extracted

# Lister les fichiers obtenus
ls -lh

# Vérifier la taille (doivent faire 1 474 560 octets)
stat -c "%n: %s bytes" *.image

# Vérifier le type de fichier
file "Install 1.image"
# Devrait afficher: "Macintosh HFS data" ou "DOS/MBR boot sector"

# Compter les fichiers
ls *.image | wc -l
# Devrait afficher: 19 (ou 20 avec Disk Tools)



RÉSULTAT ATTENDU:
-----------------
Install 1.image 1 474 560 octets
Install 2.image 1 474 560 octets
Install 3.image 1 474 560 octets
...
Install 19.image 1 474 560 octets
Disk Tools.image 1 474 560 octets (optionnel)



================================================================================
6. CRÉATION DES DISQUETTES D'INSTALLATION
================================================================================

PRÉPARATION DES DISQUETTES:
---------------------------

Vous aurez besoin de 19 disquettes 2HD neuves ou effacées.

IMPORTANT:
- Utiliser des disquettes 2HD (1.44 Mo, haute densité)
- Vérifier qu'elles sont en bon état
- Les étiqueter AVANT de les utiliser



ÉTAPE 6.1 : Formater une disquette en HFS (Optionnel)
------------------------------------------------------

Note: dd écrase tout, donc le formatage préalable n'est pas obligatoire,
mais peut être utile pour tester la disquette.

# Insérer une disquette
# Démonter si montée
sudo umount /dev/fd0 2>/dev/null

# Formater en HFS (Macintosh)
sudo hformat -f -l "Install1" /dev/fd0

# Vérifier
sudo file -s /dev/fd0
# Devrait afficher: "Macintosh HFS data"



ÉTAPE 6.2 : Copier les images sur les disquettes (MÉTHODE MANUELLE)
--------------------------------------------------------------------

cd ~/performa460/images_extracted

Pour chaque disquette:

1. INSÉRER la disquette vierge dans le lecteur

2. DÉMONTER si nécessaire:
   sudo umount /dev/fd0 2>/dev/null

3. COPIER l'image (exemple avec Install 1):
   sudo dd if="Install 1.image" of=/dev/fd0 bs=1440k status=progress

4. SYNCHRONISER (force l'écriture):
   sudo sync

5. ÉJECTER proprement:
   sudo eject /dev/fd0

6. ÉTIQUETER la disquette: "Install 1" ou "7.5.3 - Disk 1"

7. RÉPÉTER pour les 19 disquettes



EXEMPLE COMPLET POUR UNE DISQUETTE:
-----------------------------------

# Disquette Install 1
echo "Insérez la disquette Install 1 et appuyez sur Entrée..."
read
sudo umount /dev/fd0 2>/dev/null
sudo dd if="Install 1.image" of=/dev/fd0 bs=1440k status=progress
sudo sync
echo "Disquette Install 1 terminée!"
sudo eject /dev/fd0



ÉTAPE 6.3 : Script automatisé pour toutes les disquettes
---------------------------------------------------------

Créer un fichier: ~/performa460/copy_all_disks.sh

#!/bin/bash
# Script de copie automatique de toutes les disquettes

IMAGES_DIR=~/performa460/images_extracted

cd "$IMAGES_DIR"

for i in {1..19}; do
    echo ""
    echo "Préparation de Install Disk $i"
    echo ""
    echo "Insérez la disquette $i et appuyez sur Entrée..."
    read

    # Chercher le fichier image correspondant
    IMAGE=$(find . -iname "*install*$i*.image" -o -iname "*install*$i*.img" | head -1)

    if [ -z "$IMAGE" ]; then
        echo "ERREUR: Image $i non trouvée!"
        echo "Recherche de: *install*$i*.image ou *install*$i*.img"
        continue
    fi

    echo "Fichier trouvé: $IMAGE"
    echo "Copie vers /dev/fd0..."

    # Démonter
    sudo umount /dev/fd0 2>/dev/null

    # Copier avec dd
    sudo dd if="$IMAGE" of=/dev/fd0 bs=1440k status=progress

    if [ $? -ne 0 ]; then
        echo "ERREUR lors de la copie!"
        continue
    fi

    # Synchroniser
    sudo sync

    echo "✓ Disquette $i terminée avec succès!"
    echo ""

    # Optionnel: éjecter
    # sudo eject /dev/fd0
done

echo ""
echo "✓ Toutes les disquettes sont prêtes!"
echo ""

# FIN DU SCRIPT

Rendre le script exécutable:
chmod +x ~/performa460/copy_all_disks.sh

Lancer le script:
~/performa460/copy_all_disks.sh



ÉTAPE 6.4 : Disquette Disk Tools (Disquette de boot)
-----------------------------------------------------

La disquette "Disk Tools" est importante car elle permet de:
- Booter le Mac sans disque dur
- Formater le disque dur
- Réparer les erreurs
- Lancer l'installation

# Copier Disk Tools
sudo umount /dev/fd0 2>/dev/null
sudo dd if="Disk Tools.image" of=/dev/fd0 bs=1440k status=progress
sudo sync
sudo eject /dev/fd0

# Étiqueter: "Disk Tools" ou "7.5.3 - Boot"



VÉRIFICATION D'UNE DISQUETTE CRÉÉE:
-----------------------------------

# Insérer la disquette créée
# Vérifier le contenu sans la monter
sudo file -s /dev/fd0

# Devrait afficher:
# /dev/fd0: Macintosh HFS data block size: 512, number of blocks: 2880

# Pour voir le contenu (optionnel)
sudo mkdir -p /mnt/floppy
sudo mount -t hfs /dev/fd0 /mnt/floppy
ls -la /mnt/floppy
sudo umount /mnt/floppy



LISTE DES DISQUETTES À CRÉER:
------------------------------
□ Install 1 (Disk Tools inclus généralement)
□ Install 2
□ Install 3
□ Install 4
□ Install 5
□ Install 6
□ Install 7
□ Install 8
□ Install 9
□ Install 10
□ Install 11
□ Install 12
□ Install 13
□ Install 14
□ Install 15
□ Install 16
□ Install 17
□ Install 18
□ Install 19
□ Disk Tools (si séparé)



================================================================================
7. PRÉPARATION DU MACINTOSH
================================================================================

ÉTAPE 7.1 : Vérification matérielle
------------------------------------

□ Brancher l'alimentation
□ Connecter le clavier ADB
□ Connecter la souris ADB
□ Connecter le moniteur
□ Vérifier que le lecteur de disquette fonctionne



ÉTAPE 7.2 : Test de démarrage
------------------------------

1. Allumer le Mac
2. Écouter le "bong" de démarrage
3. Observer l'écran:
   - Si disque dur OK: Mac démarre normalement
   - Si disque dur vide/défectueux: Icône disquette clignotante avec ?



ÉTAPE 7.3 : Formatage du disque dur (si nécessaire)
----------------------------------------------------

Si le disque dur doit être reformaté:

1. Insérer la disquette "Disk Tools" ou "SuperBooter75"
2. Démarrer le Mac (il devrait booter depuis la disquette)
3. Attendre que le bureau apparaisse
4. Double-cliquer sur "HD SC Setup" ou équivalent
5. Sélectionner le disque dur interne
6. Cliquer "Initialize" (EFFACE TOUT!)
7. Confirmer
8. Attendre la fin du formatage
9. Quitter HD SC Setup



ÉTAPE 7.4 : Vérification du disque
-----------------------------------

Utiliser "Disk First Aid" sur la disquette Disk Tools:

1. Double-cliquer sur "Disk First Aid"
2. Sélectionner le disque dur
3. Cliquer "Verify"
4. Si erreurs: cliquer "Repair"
5. Quitter



================================================================================
8. INSTALLATION DU SYSTÈME
================================================================================

ÉTAPE 8.1 : Démarrage de l'installation
----------------------------------------

1. INSÉRER la disquette "Install 1" (ou "Disk Tools" si séparé)
2. REDÉMARRER le Mac
3. ATTENDRE que le Mac démarre depuis la disquette
   - Vous verrez l'icône de la disquette à l'écran
   - Le bureau Mac devrait apparaître après 30-60 secondes



ÉTAPE 8.2 : Lancer l'installeur
--------------------------------

1. Sur le bureau, double-cliquer sur "Install" ou "Installer"
2. Une fenêtre d'accueil apparaît
3. Lire les informations
4. Cliquer "Continue" ou "OK"



ÉTAPE 8.3 : Configuration de l'installation
--------------------------------------------

1. Sélectionner le disque de destination:
   - Choisir le disque dur interne
   - Cliquer "Select" ou double-cliquer

2. Type d'installation:
   - Choisir "Easy Install" (installation complète)
   - Ou "Custom Install" pour personnaliser

3. Cliquer "Install" ou "Start"



ÉTAPE 8.4 : Insertion des disquettes (Processus)
-------------------------------------------------

L'installeur vous demandera les disquettes dans l'ordre:

Installation Disk 1 → OK
"Please insert Install 2" → Insérer Install 2
"Please insert Install 3" → Insérer Install 3
...
"Please insert Install 19" → Insérer Install 19

IMPORTANT:
- Attendre que la disquette soit éjectée automatiquement
- Ne PAS retirer la disquette de force
- Insérer la disquette suivante quand demandée
- Si erreur de lecture: nettoyer la disquette et réessayer



ÉTAPE 8.5 : Fin de l'installation
----------------------------------

1. Après Install 19, l'installation est terminée
2. Message: "Installation successful" ou similaire
3. Cliquer "Restart" ou "Quit"
4. Le Mac redémarre automatiquement



ÉTAPE 8.6 : Premier démarrage
------------------------------

1. Le Mac démarre depuis le disque dur
2. Configuration initiale:
   - Langue
   - Clavier
   - Date et heure
   - Nom d'utilisateur (optionnel selon version)

3. Le bureau Mac OS 7.5.3 apparaît!



DURÉE TOTALE DE L'INSTALLATION:
--------------------------------
Environ 30 à 60 minutes selon:
- Vitesse du Mac
- État des disquettes
- Nombre d'erreurs de lecture



================================================================================
9. DÉPANNAGE
================================================================================

PROBLÈME 1 : "This disk is unreadable by this Macintosh"
---------------------------------------------------------

CAUSE: Disquette mal formatée ou corrompue

SOLUTION:
1. Vérifier que la disquette a été créée correctement
2. Recréer la disquette avec dd
3. Essayer une autre disquette vierge
4. Vérifier l'image source avec: file fichier.image



PROBLÈME 2 : "Please insert Install X" mais rien ne se passe
-------------------------------------------------------------

CAUSE: Mauvaise disquette insérée ou erreur de lecture

SOLUTION:
1. Vérifier le numéro de la disquette demandée
2. Éjecter et réinsérer la bonne disquette
3. Nettoyer la tête de lecture du Mac avec une disquette de nettoyage
4. Recréer la disquette défectueuse



PROBLÈME 3 : Le Mac ne démarre pas depuis la disquette
-------------------------------------------------------

CAUSE: Disquette non bootable ou lecteur défectueux

SOLUTION:
1. Vérifier que vous utilisez "Disk Tools" ou "Install 1"
2. Recréer la disquette de boot
3. Essayer de démarrer en maintenant la touche "C"
4. Tester avec une autre disquette bootable connue



PROBLÈME 4 : Installation se bloque à X%
-----------------------------------------

CAUSE: Disquette défectueuse ou disque dur avec erreurs

SOLUTION:
1. Attendre 2-3 minutes (parfois juste lent)
2. Si vraiment bloqué: redémarrer et réessayer
3. Vérifier le disque dur avec Disk First Aid
4. Recréer la disquette qui pose problème



PROBLÈME 5 : "Not enough memory to run this application"
---------------------------------------------------------

CAUSE: RAM insuffisante (très rare avec 4 Mo pour System 7.5.3)

SOLUTION:
1. Redémarrer le Mac
2. Ne pas lancer d'autres applications pendant l'installation
3. Si récurrent: ajouter de la RAM



PROBLÈME 6 : Erreur "dd: writing to '/dev/fd0': No space left on device"
------------------------------------------------------------------------

CAUSE: Image trop grande pour la disquette

SOLUTION:
1. Vérifier la taille de l'image:
   ls -lh fichier.image
   # Doit faire exactement 1 474 560 octets

2. Si trop grande: image corrompue ou mauvaise
3. Télécharger à nouveau l'image



PROBLÈME 7 : Le disque dur n'apparaît pas dans l'installeur
------------------------------------------------------------

CAUSE: Disque non formaté ou non reconnu

SOLUTION:
1. Booter depuis Disk Tools
2. Lancer HD SC Setup
3. Si le disque n'apparaît pas: problème matériel
4. Vérifier les câbles SCSI
5. Essayer avec un autre disque dur



PROBLÈME 8 : Fichiers .part ne s'extraient pas
-----------------------------------------------

CAUSE: Archive corrompue ou outil incorrect

SOLUTION:
1. Télécharger directement les images depuis Internet Archive
2. Essayer HFSExplorer au lieu de unar
3. Télécharger à nouveau l'archive



PROBLÈME 9 : "System Error" ou crash pendant l'installation
------------------------------------------------------------

CAUSE: RAM défectueuse, disquette corrompue, ou conflit matériel

SOLUTION:
1. Redémarrer et réessayer
2. Tester la RAM (remplacer si possible)
3. Recréer toutes les disquettes
4. Retirer toutes extensions/périphériques externes



PROBLÈME 10 : Le Mac démarre mais affiche un "X" ou un "?"
-----------------------------------------------------------

CAUSE: Système incomplet ou System Folder non "blessed"

SOLUTION:
1. Redémarrer depuis Disk Tools
2. Ouvrir le System Folder sur le disque dur
3. Double-cliquer sur "System" (le "bénit")
4. Redémarrer



================================================================================
10. RESSOURCES ET LIENS
================================================================================

TÉLÉCHARGEMENT D'IMAGES SYSTÈME:
---------------------------------
- Macintosh Garden (Principal)
  https://macintoshgarden.org/apps/system-7-floppy-sets

- Internet Archive - System 7.5.3
  https://archive.org/details/system7.5.3d

- Macintosh Repository
  https://www.macintoshrepository.org/598-mac-os-7-floppy-install-sets-system-7-x-

- WinWorld
  https://winworldpc.com/product/mac-os-7/75



OUTILS ET UTILITAIRES:
----------------------
- HFSExplorer (Lire disques Mac sous Linux/Windows)
  https://sourceforge.net/projects/catacombae/

- System Enablers (Collection complète)
  https://macintoshgarden.org/apps/apple-system-enablers

- SuperBooter75 (Disquette utilitaires universelle)
  https://vintageapple.org/gamba2/superbooter75.html

- Disk Copy 6.3.3 (Créer images disquettes)
  Inclus dans les archives System 7.5.3



DOCUMENTATION TECHNIQUE:
------------------------
- Everymac - Performa 460 Specs
  https://everymac.com/systems/apple/mac_performa/specs/mac_performa_460.html

- Apple Support - Performa 460
  https://support.apple.com/en-us/112332

- 68kMLA - Forum Mac vintage
  https://68kmla.org

- Macintosh Garden - Forum
  https://macintoshgarden.org/forum



GUIDES ET TUTORIELS:
--------------------
- Guide System 7 - Low End Mac
  https://lowendmac.com/2013/classic-mac-os-downloads-and-updates/

- System Selection Guide
  https://www.savagetaylor.com/2015/11/17/setting-up-your-vintage-classic-68k-macintosh-selecting-your-system-software/

- E-Maculation (Émulation Mac)
  https://www.emaculation.com



COMMUNAUTÉS ET FORUMS:
----------------------
- 68k Macintosh Liberation Army
  https://68kmla.org/bb/

- Vintage Computer Forum
  https://forum.vcfed.org/

- r/VintageApple (Reddit)
  https://www.reddit.com/r/VintageApple/

- Compact Mac Community
  https://www.facebook.com/groups/compactmacs



INFORMATIONS SYSTEM ENABLER:
-----------------------------
- System Enabler 308 v1.0 - REQUIS pour System 7.1 sur Performa 460
- System Enabler 003 v1.1 - Fonctionne aussi (LC III+)
- PAS de System Enabler requis pour System 7.5+



VERSIONS DE SYSTÈME RECOMMANDÉES POUR PERFORMA 460:
---------------------------------------------------
1. System 7.5.3 ★★★★★ (RECOMMANDÉ)
   - Stable
   - Gratuit
   - Pas de System Enabler requis
   - Bonnes performances

2. System 7.5.5 ★★★★☆
   - Plus stable que 7.5.3
   - Nécessite 7.5.3 installé d'abord + update

3. System 7.6.1 ★★★☆☆
   - Dernière version 68k
   - Plus gourmand en RAM
   - Bonnes fonctionnalités

4. System 7.1 ★★★☆☆
   - Version d'origine
   - Nécessite System Enabler 308
   - Léger et rapide



ALTERNATIVES À DD POUR WINDOWS:
-------------------------------
- WinImage - Écrire images sur disquettes
- TransMac - Formater et écrire disquettes Mac
- HFVExplorer - Manipuler fichiers Mac



COMMANDES LINUX RÉCAPITULATIVES:
---------------------------------

# Vérifier module floppy
lsmod | grep floppy
sudo modprobe floppy

# Identifier disquette
lsblk
dmesg | tail

# Formater HFS
sudo hformat -f -l "NomDisk" /dev/fd0

# Copier image sur disquette
sudo umount /dev/fd0 2>/dev/null
sudo dd if=fichier.image of=/dev/fd0 bs=1440k status=progress
sudo sync
sudo eject /dev/fd0

# Vérifier contenu
sudo file -s /dev/fd0
sudo mount -t hfs /dev/fd0 /mnt/floppy
ls -la /mnt/floppy
sudo umount /mnt/floppy

# Extraire archives Mac
unar fichier.sit
unar fichier.part



TAILLES DE FICHIERS STANDARD:
------------------------------
Image disquette 1.44 Mo: 1 474 560 octets
Image disquette 800K: 819 200 octets
System 7.5.3 complet: ~86 Mo (archive)
System 7.5.3 installé: ~15-20 Mo sur disque



NOTES IMPORTANTES:
------------------
1. System 7.5.3 est la version la plus facile à trouver et installer
2. Toujours utiliser des disquettes de bonne qualité
3. Les disquettes ont une durée de vie limitée (10-30 ans)
4. Prévoir quelques disquettes de spare
5. Ne jamais forcer l'éjection d'une disquette
6. Nettoyer les têtes de lecture régulièrement
7. Conserver les disquettes à l'abri de l'humidité et des aimants



CHECKLIST AVANT INSTALLATION:
------------------------------
□ Linux opérationnel avec lecteur disquette
□ 20 disquettes 2HD vierges/testées
□ Images System 7.5.3 téléchargées et vérifiées
□ Toutes les 19 disquettes créées et étiquetées
□ Performa 460 testé et fonctionnel
□ Disque dur formaté et vérifié
□ Sauvegarde des données importantes (si applicable)



================================================================================
FIN DU GUIDE
================================================================================

Ce guide a été compilé à partir de sources communautaires incluant:
- Macintosh Garden
- Internet Archive
- 68kMLA Forums
- Vintage Apple resources
- E-Maculation documentation

Version: 1.0 - Février 2026

Pour toute question ou aide supplémentaire, consultez les forums communautaires
listés dans la section Ressources.

Bonne restauration de votre Performa 460! 🖥️

================================================================================
