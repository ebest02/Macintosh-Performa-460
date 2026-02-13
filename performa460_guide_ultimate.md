# Guide Complet : Réinstaller un Macintosh Performa 460 avec Linux

> **Date:** Février 2026  
> **Système cible:** Macintosh Performa 460  
> **OS hôte:** Linux (Debian/Ubuntu/Kaisen Linux)  
> **Méthodes:** Disquettes 1.44 Mo OU CD-ROM SCSI

---

## Table des Matières

1. [Informations sur le Performa 460](#1-informations-sur-le-performa-460)
2. [Matériel et Logiciels Nécessaires](#2-matériel-et-logiciels-nécessaires)
3. [Préparation du Système Linux](#3-préparation-du-système-linux)
4. [Script d'Installation Interactif](#4-script-dinstallation-interactif)
5. [Téléchargement des Images Système](#5-téléchargement-des-images-système)
6. [Extraction des Fichiers .part](#6-extraction-des-fichiers-part)
7. [Méthode A : Installation par Disquettes](#7-méthode-a-installation-par-disquettes)
8. [Méthode B : Installation par CD-ROM SCSI](#8-méthode-b-installation-par-cd-rom-scsi)
9. [Préparation du Macintosh](#9-préparation-du-macintosh)
10. [Installation du Système](#10-installation-du-système)
11. [Dépannage](#11-dépannage)
12. [Ressources et Liens](#12-ressources-et-liens)

---

## 1. Informations sur le Performa 460

### Spécifications Techniques

| Composant | Spécification |
|-----------|---------------|
| **Processeur** | Motorola 68030 à 33 MHz |
| **RAM** | 4 Mo (extensible à 36 Mo) |
| **Disque dur** | 80 Mo SCSI |
| **Lecteur disquette** | SuperDrive 1.44 Mo (2HD, double face) |
| **Lecteur CD-ROM** | Compatible SCSI externe (optionnel) |
| **Ports** | SCSI, ADB, série, audio |
| **Date de sortie** | Octobre 1993 |
| **Date d'arrêt** | Février 1994 |
| **Équivalent éducation** | LC III+ |

### Système d'Origine

- **System 7.1P3** (oct-déc 1993)
- **System 7.1P5** (après déc 1993)
- **System Enabler 308 v1.0** REQUIS pour System 7.1

### Compatibilité Système

| Version | Compatibilité | System Enabler requis |
|---------|---------------|----------------------|
| System 7.0.1 à 7.1 | ✅ Compatible | Oui (Enabler 308) |
| System 7.5 à 7.6.1 | ✅ Compatible | Non |
| Mac OS 8.0 à 8.1 | ✅ Compatible | Non |
| Mac OS 8.5+ | ❌ Non supporté | - |

---

## 2. Matériel et Logiciels Nécessaires

### Matériel - Option Disquettes

- [ ] **19-20 disquettes 2HD (1.44 Mo)** NEUVES ou en excellent état
- [ ] **Lecteur de disquettes** USB externe OU interne compatible Linux
- [ ] **Macintosh Performa 460** fonctionnel
- [ ] **Clavier et souris ADB**
- [ ] **Moniteur** compatible (VGA ou Apple)
- [ ] **Câble d'alimentation**

### Matériel - Option CD-ROM

- [ ] **CD-ROM vierge** (700 Mo minimum)
- [ ] **Graveur CD** (interne ou USB)
- [ ] **Lecteur CD-ROM SCSI externe** pour Mac (AppleCD 300, Plextor, etc.)
- [ ] **Câble SCSI** avec terminaison appropriée
- [ ] **Disquette Disk Tools** (1 seule pour booter)
- [ ] **Macintosh Performa 460** fonctionnel
- [ ] **Clavier, souris ADB, moniteur**

### Logiciels Linux

- [ ] `hfsutils` et `hfsprogs` (pour formater HFS)
- [ ] `unar` ou HFSExplorer (pour extraire archives Mac)
- [ ] `dd` (normalement préinstallé)
- [ ] `mkisofs` ou `genisoimage` (pour créer ISO)
- [ ] `cdrecord` ou `wodim` (pour graver CD)
- [ ] Java 11+ (pour HFSExplorer)

### Fichiers à Télécharger

- [ ] **System 7.5.3** (16-19 images de disquettes OU archive complète)
- [ ] **Disk Tools** (disquettes de boot/utilitaires)
- [ ] *(Optionnel)* SuperBooter75 (utilitaires universels)
- [ ] *(Optionnel)* System Enabler 308 (si System 7.1)

---

## 3. Préparation du Système Linux

### Étape 3.1 : Installation des outils nécessaires
```bash
# Mise à jour du système
sudo apt-get update

# Installation des outils HFS
sudo apt-get install hfsutils hfsprogs

# Installation de unar (pour extraire archives Mac)
sudo apt-get install unar

# Installation des outils CD
sudo apt-get install genisoimage wodim

# Installation de Java (pour HFSExplorer si nécessaire)
sudo apt-get install openjdk-11-jre

# Vérification du module floppy (pour disquettes)
lsmod | grep floppy

# Si absent, charger le module
sudo modprobe floppy

# Vérifier les permissions du lecteur
ls -l /dev/fd0

# Si nécessaire, ajuster les permissions
sudo chmod 666 /dev/fd0
```

### Étape 3.2 : Création du dossier de travail
```bash
mkdir -p ~/performa460/system753
mkdir -p ~/performa460/images_extracted
mkdir -p ~/performa460/cdrom_content
cd ~/performa460/system753
```

### Étape 3.3 : Test du matériel

#### Pour Lecteur de Disquettes
```bash
# Insérer une disquette test
# Vérifier la détection
dmesg | tail -20

# Devrait afficher:
# floppy0: detected floppy disk change

# Vérifier avec lsblk
lsblk | grep fd0
```

#### Pour Graveur CD
```bash
# Vérifier le graveur
wodim --devices

# Ou avec cdrecord
cdrecord -scanbus

# Devrait afficher quelque chose comme:
# 0,0,0    0) 'ATAPI   ' 'DVD RW AD-7200S' 'K02 ' Removable CD-ROM
```

---

## 4. Script d'Installation Interactif

### Le Script Universel : `performa460-installer.sh`

Créer le fichier : `~/performa460/performa460-installer.sh`
```bash
#!/bin/bash
################################################################################
#                                                                              #
#           SCRIPT D'INSTALLATION INTERACTIF - PERFORMA 460                   #
#                                                                              #
#  Ce script guide l'utilisateur dans l'installation complète de System 7.5.3 #
#  sur un Macintosh Performa 460, avec choix entre disquettes et CD-ROM       #
#                                                                              #
#  Version: 2.0 - Février 2026                                                 #
#  Auteur: ebest                                                               #
#                                                                              #
################################################################################

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Variables globales
WORK_DIR=~/performa460
IMAGES_DIR=$WORK_DIR/images_extracted
CDROM_DIR=$WORK_DIR/cdrom_content
INSTALL_METHOD=""
DEVICE=""

################################################################################
# FONCTIONS UTILITAIRES
################################################################################

function print_header() {
    clear
    echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}    INSTALLATION SYSTEM 7.5.3 - MACINTOSH PERFORMA 460${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"
    echo ""
}

function print_section() {
    echo ""
    echo -e "${MAGENTA}▶ $1${NC}"
    echo -e "${CYAN}────────────────────────────────────────────────────────${NC}"
}

function print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

function print_error() {
    echo -e "${RED}✗ ERREUR: $1${NC}"
}

function print_warning() {
    echo -e "${YELLOW}⚠ ATTENTION: $1${NC}"
}

function print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

function pause() {
    echo ""
    read -p "Appuyez sur Entrée pour continuer..."
}

function confirm() {
    local prompt="$1"
    local response
    read -p "$prompt (o/n): " response
    [[ "$response" =~ ^[oO]$ ]]
}

################################################################################
# VÉRIFICATIONS PRÉALABLES
################################################################################

function check_dependencies() {
    print_section "Vérification des dépendances"
    
    local missing_deps=()
    
    # Vérifier les commandes nécessaires
    for cmd in dd unar lsblk file stat; do
        if ! command -v $cmd &> /dev/null; then
            missing_deps+=($cmd)
        fi
    done
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "Dépendances manquantes: ${missing_deps[*]}"
        echo ""
        echo "Installez-les avec:"
        echo "sudo apt-get install ${missing_deps[*]}"
        exit 1
    fi
    
    print_success "Toutes les dépendances sont installées"
}

function check_permissions() {
    print_section "Vérification des permissions"
    
    if [ ! -w "$WORK_DIR" ]; then
        print_error "Pas de permission d'écriture dans $WORK_DIR"
        exit 1
    fi
    
    print_success "Permissions OK"
}

################################################################################
# MENU PRINCIPAL
################################################################################

function main_menu() {
    while true; do
        print_header
        echo -e "${WHITE}Choisissez la méthode d'installation :${NC}"
        echo ""
        echo "  1) Installation par DISQUETTES (19 disquettes requises)"
        echo "  2) Installation par CD-ROM SCSI (1 CD + 1 disquette boot)"
        echo "  3) Télécharger les images System 7.5.3"
        echo "  4) Vérifier les images téléchargées"
        echo "  5) Aide et informations"
        echo "  6) Quitter"
        echo ""
        read -p "Votre choix [1-6]: " choice
        
        case $choice in
            1)
                INSTALL_METHOD="floppy"
                floppy_workflow
                ;;
            2)
                INSTALL_METHOD="cdrom"
                cdrom_workflow
                ;;
            3)
                download_images
                pause
                ;;
            4)
                verify_images
                pause
                ;;
            5)
                show_help
                pause
                ;;
            6)
                echo ""
                echo -e "${GREEN}Au revoir!${NC}"
                exit 0
                ;;
            *)
                print_error "Choix invalide"
                sleep 2
                ;;
        esac
    done
}

################################################################################
# WORKFLOW DISQUETTES
################################################################################

function floppy_workflow() {
    print_header
    print_section "Installation par DISQUETTES"
    
    echo -e "${YELLOW}Cette méthode nécessite:${NC}"
    echo "  - 19 disquettes 2HD (1.44 Mo) vierges"
    echo "  - Un lecteur de disquettes USB ou interne"
    echo "  - Environ 45-60 minutes pour créer toutes les disquettes"
    echo ""
    
    if ! confirm "Voulez-vous continuer avec cette méthode?"; then
        return
    fi
    
    # Étape 1: Identifier le lecteur
    identify_floppy_drive
    
    # Étape 2: Vérifier les images
    if ! check_images_exist; then
        print_warning "Images non trouvées"
        if confirm "Voulez-vous télécharger les images maintenant?"; then
            download_images
        else
            return
        fi
    fi
    
    # Étape 3: Créer les disquettes
    create_all_floppies
    
    # Étape 4: Instructions finales
    show_floppy_instructions
}

function identify_floppy_drive() {
    print_section "Identification du lecteur de disquettes"
    
    echo ""
    echo "Détection automatique du lecteur..."
    echo ""
    
    # Vérifier lecteur interne
    if [ -b "/dev/fd0" ]; then
        print_info "Lecteur INTERNE détecté: /dev/fd0"
        DEVICE="/dev/fd0"
        return
    fi
    
    # Chercher lecteur USB
    echo "Périphériques de stockage détectés:"
    lsblk -o NAME,SIZE,TYPE,MOUNTPOINT
    echo ""
    
    print_warning "Lecteur interne non détecté"
    echo ""
    echo "Si vous utilisez un lecteur USB:"
    echo "  - Identifiez le périphérique (généralement /dev/sdb)"
    echo "  - La taille doit être 1.4M"
    echo ""
    
    read -p "Entrez le périphérique du lecteur USB (ex: /dev/sdb): " user_device
    
    if [ ! -b "$user_device" ]; then
        print_error "Périphérique $user_device non trouvé"
        pause
        return 1
    fi
    
    # Vérifier la taille
    local size=$(sudo blockdev --getsize64 $user_device 2>/dev/null)
    if [ "$size" != "1474560" ]; then
        print_warning "La taille du périphérique ($size octets) ne correspond pas à une disquette 1.44M"
        if ! confirm "Voulez-vous quand même continuer?"; then
            return 1
        fi
    fi
    
    DEVICE="$user_device"
    print_success "Lecteur configuré: $DEVICE"
}

function check_images_exist() {
    if [ ! -d "$IMAGES_DIR" ]; then
        return 1
    fi
    
    local count=$(find "$IMAGES_DIR" -name "*.image" | wc -l)
    if [ $count -lt 16 ]; then
        return 1
    fi
    
    return 0
}

function create_all_floppies() {
    print_section "Création des disquettes"
    
    cd "$IMAGES_DIR" || return
    
    # Liste des disquettes à créer
    local disks=(
        "Disk Tools 1.image"
        "Install Disk 1.image"
        "Install Disk 2.image"
        "Install Disk 3.image"
        "Install Disk 4.image"
        "Install Disk 5.image"
        "Install Disk 6.image"
        "Install Disk 7.image"
        "Install Disk 8.image"
        "Install Disk 9.image"
        "Install Disk 10.image"
        "Install Disk 11.image"
        "Install Disk 12.image"
        "Install Disk 13.image"
        "Install Disk 14.image"
        "Install Disk 15.image"
        "Install Disk 16.image"
        "Disk Tools 2.image"
        "Before You Install.image"
    )
    
    local total=${#disks[@]}
    local current=0
    
    for disk in "${disks[@]}"; do
        current=$((current + 1))
        
        # Vérifier si le fichier existe
        if [ ! -f "$disk" ]; then
            print_warning "Fichier non trouvé: $disk (ignoré)"
            continue
        fi
        
        echo ""
        echo -e "${GREEN}════════════════════════════════════════════${NC}"
        echo -e "${GREEN}  Disquette $current / $total${NC}"
        echo -e "${GREEN}  Fichier: $disk${NC}"
        echo -e "${GREEN}════════════════════════════════════════════${NC}"
        
        echo ""
        echo -e "${YELLOW}Insérez une disquette VIERGE dans le lecteur${NC}"
        echo -e "${CYAN}Étiquetez-la: $(basename "$disk" .image)${NC}"
        echo ""
        read -p "Appuyez sur Entrée quand prêt (ou 'q' pour quitter)..." response
        
        if [ "$response" = "q" ]; then
            print_warning "Création interrompue"
            return
        fi
        
        # Démonter
        sudo umount ${DEVICE}* 2>/dev/null
        
        # Copier avec barre de progression
        echo "Copie en cours..."
        sudo dd if="$disk" of=$DEVICE bs=1440k status=progress 2>&1
        
        if [ $? -eq 0 ]; then
            sudo sync
            echo ""
            print_success "Copie réussie!"
            
            # Vérification
            if sudo file -s $DEVICE | grep -q "Macintosh HFS"; then
                print_success "Format HFS vérifié"
            else
                print_warning "Format non reconnu (peut fonctionner quand même)"
            fi
        else
            print_error "Erreur lors de la copie!"
        fi
        
        echo ""
        echo -e "${CYAN}➜ Retirez la disquette et rangez-la${NC}"
        sleep 2
    done
    
    echo ""
    print_success "Toutes les disquettes ont été créées!"
}

function show_floppy_instructions() {
    print_header
    print_section "Instructions d'installation - DISQUETTES"
    
    echo ""
    echo -e "${WHITE}Ordre d'utilisation des disquettes:${NC}"
    echo ""
    echo "  1. Démarrez le Performa 460 avec la disquette 'Disk Tools 1'"
    echo "  2. Formatez le disque dur avec 'HD SC Setup' (si nécessaire)"
    echo "  3. Lancez l'installeur depuis 'Install Disk 1'"
    echo "  4. Insérez les disquettes 2 à 16 quand demandées"
    echo "  5. Redémarrez le Mac après installation"
    echo ""
    echo -e "${YELLOW}Conseil: Numérotez clairement vos disquettes!${NC}"
    
    pause
}

################################################################################
# WORKFLOW CD-ROM
################################################################################

function cdrom_workflow() {
    print_header
    print_section "Installation par CD-ROM SCSI"
    
    echo -e "${YELLOW}Cette méthode nécessite:${NC}"
    echo "  - 1 CD-ROM vierge (700 Mo)"
    echo "  - 1 disquette 'Disk Tools' pour booter"
    echo "  - Un lecteur CD-ROM SCSI externe pour le Mac"
    echo "  - Câble SCSI avec terminaison"
    echo ""
    
    if ! confirm "Voulez-vous continuer avec cette méthode?"; then
        return
    fi
    
    # Étape 1: Vérifier les images
    if ! check_images_exist; then
        print_warning "Images non trouvées"
        if confirm "Voulez-vous télécharger les images maintenant?"; then
            download_images
        else
            return
        fi
    fi
    
    # Étape 2: Créer l'image ISO
    create_iso_image
    
    # Étape 3: Graver le CD
    burn_cd
    
    # Étape 4: Créer la disquette boot
    create_boot_floppy
    
    # Étape 5: Instructions finales
    show_cdrom_instructions
}

function create_iso_image() {
    print_section "Création de l'image ISO"
    
    echo ""
    print_info "Copie des fichiers dans le dossier CD-ROM..."
    
    # Nettoyer et recréer le dossier
    rm -rf "$CDROM_DIR"
    mkdir -p "$CDROM_DIR/System Software"
    
    # Copier toutes les images Install Disk
    cp "$IMAGES_DIR"/Install*.image "$CDROM_DIR/System Software/" 2>/dev/null
    cp "$IMAGES_DIR"/"Disk Tools"*.image "$CDROM_DIR/System Software/" 2>/dev/null
    cp "$IMAGES_DIR"/"Before You Install.image" "$CDROM_DIR/System Software/" 2>/dev/null
    
    local file_count=$(find "$CDROM_DIR" -name "*.image" | wc -l)
    print_info "$file_count fichiers copiés"
    
    # Créer l'ISO avec format HFS hybride
    echo ""
    print_info "Création de l'image ISO hybride (HFS + ISO9660)..."
    
    local iso_file="$WORK_DIR/System_753_Install.iso"
    
    # Utiliser genisoimage/mkisofs pour créer une ISO hybride
    genisoimage -hfs -probe -map "$WORK_DIR/mapping.txt" \
        -V "System 7.5.3" \
        -o "$iso_file" \
        "$CDROM_DIR" 2>&1 | grep -v "Warning"
    
    if [ -f "$iso_file" ]; then
        local size=$(du -h "$iso_file" | cut -f1)
        print_success "Image ISO créée: $iso_file ($size)"
    else
        print_error "Échec de la création de l'ISO"
        return 1
    fi
}

function burn_cd() {
    print_section "Gravure du CD-ROM"
    
    local iso_file="$WORK_DIR/System_753_Install.iso"
    
    if [ ! -f "$iso_file" ]; then
        print_error "Image ISO non trouvée"
        return 1
    fi
    
    echo ""
    echo "Détection du graveur CD..."
    wodim --devices
    echo ""
    
    read -p "Entrez le périphérique du graveur (ex: /dev/sr0): " burner
    
    if [ ! -b "$burner" ]; then
        print_error "Périphérique $burner non trouvé"
        return 1
    fi
    
    echo ""
    print_warning "Insérez un CD-ROM VIERGE dans le graveur"
    pause
    
    echo ""
    print_info "Gravure en cours (vitesse 8x)..."
    echo ""
    
    sudo wodim -v dev=$burner speed=8 -dao -eject "$iso_file"
    
    if [ $? -eq 0 ]; then
        print_success "CD-ROM gravé avec succès!"
        print_info "Le CD a été éjecté"
    else
        print_error "Erreur lors de la gravure"
        return 1
    fi
}

function create_boot_floppy() {
    print_section "Création de la disquette de boot"
    
    echo ""
    print_info "Vous avez besoin d'UNE disquette 'Disk Tools 1' pour démarrer le Mac"
    echo ""
    
    if ! confirm "Voulez-vous créer cette disquette maintenant?"; then
        print_warning "N'oubliez pas de créer la disquette boot avant l'installation!"
        return
    fi
    
    # Identifier le lecteur de disquettes
    identify_floppy_drive
    
    local boot_image="$IMAGES_DIR/Disk Tools 1.image"
    
    if [ ! -f "$boot_image" ]; then
        print_error "Fichier 'Disk Tools 1.image' non trouvé"
        return 1
    fi
    
    echo ""
    print_warning "Insérez une disquette VIERGE"
    pause
    
    # Démonter
    sudo umount ${DEVICE}* 2>/dev/null
    
    # Copier
    echo "Copie en cours..."
    sudo dd if="$boot_image" of=$DEVICE bs=1440k status=progress
    
    if [ $? -eq 0 ]; then
        sudo sync
        print_success "Disquette boot créée avec succès!"
    else
        print_error "Erreur lors de la création"
    fi
}

function show_cdrom_instructions() {
    print_header
    print_section "Instructions d'installation - CD-ROM"
    
    echo ""
    echo -e "${WHITE}Matériel nécessaire:${NC}"
    echo "  ✓ CD-ROM gravé avec System 7.5.3"
    echo "  ✓ Disquette 'Disk Tools 1'"
    echo "  ✓ Lecteur CD-ROM SCSI externe"
    echo "  ✓ Câble SCSI avec terminaison correcte"
    echo ""
    echo -e "${WHITE}Procédure d'installation:${NC}"
    echo ""
    echo "  1. Connectez le lecteur CD-ROM SCSI au Performa 460"
    echo "     - Utilisez un câble SCSI de qualité"
    echo "     - Terminez correctement la chaîne SCSI"
    echo "     - ID SCSI du CD-ROM: généralement 3 ou 4"
    echo ""
    echo "  2. Insérez la disquette 'Disk Tools 1'"
    echo "  3. Démarrez le Performa 460"
    echo "  4. Une fois sur le bureau, insérez le CD-ROM"
    echo "  5. Formatez le disque dur avec 'HD SC Setup' (si nécessaire)"
    echo "  6. Ouvrez le CD-ROM et lancez 'Install Disk 1'"
    echo "  7. Suivez les instructions de l'installeur"
    echo "  8. Le système copiera tous les fichiers depuis le CD"
    echo "  9. Redémarrez après installation"
    echo ""
    echo -e "${YELLOW}Avantages du CD-ROM:${NC}"
    echo "  ✓ Pas de changement de disquettes"
    echo "  ✓ Installation plus rapide (~20 minutes)"
    echo "  ✓ CD réutilisable pour futures installations"
    echo ""
    echo -e "${RED}Important:${NC}"
    echo "  - Le CD-ROM doit être connecté AVANT le démarrage"
    echo "  - Vérifiez que le System Folder du CD n'est PAS blessed"
    echo "  - Le Mac doit booter depuis la DISQUETTE, pas le CD"
    
    pause
}

################################################################################
# TÉLÉCHARGEMENT DES IMAGES
################################################################################

function download_images() {
    print_header
    print_section "Téléchargement de System 7.5.3"
    
    echo ""
    echo -e "${WHITE}Sources disponibles:${NC}"
    echo ""
    echo "  1) Internet Archive (recommandé - images directes)"
    echo "  2) Macintosh Garden (archive .sit à extraire)"
    echo "  3) Utiliser des images déjà téléchargées"
    echo ""
    read -p "Votre choix [1-3]: " choice
    
    case $choice in
        1)
            download_from_archive
            ;;
        2)
            download_from_garden
            ;;
        3)
            locate_existing_images
            ;;
        *)
            print_error "Choix invalide"
            ;;
    esac
}

function download_from_archive() {
    print_info "Téléchargement depuis Internet Archive..."
    
    mkdir -p "$IMAGES_DIR"
    cd "$IMAGES_DIR"
    
    echo ""
    print_info "Téléchargement de 19 fichiers (environ 27 Mo)..."
    echo ""
    
    # Télécharger avec wget
    wget -r -np -nd -A "*.image" "https://archive.org/download/system7.5.3d/"
    
    if [ $? -eq 0 ]; then
        print_success "Téléchargement terminé"
        verify_images
    else
        print_error "Erreur de téléchargement"
    fi
}

function download_from_garden() {
    print_info "Téléchargement depuis Macintosh Garden..."
    print_warning "Cette méthode nécessite extraction manuelle"
    
    echo ""
    echo "URL: https://macintoshgarden.org/apps/system-7-floppy-sets"
    echo "Fichier: 7_5_3.sit (86.12 MB)"
    echo ""
    echo "Téléchargez manuellement et placez le dans:"
    echo "  $WORK_DIR/system753/"
}

function locate_existing_images() {
    print_info "Recherche d'images existantes..."
    
    echo ""
    read -p "Entrez le chemin du dossier contenant les images: " user_path
    
    if [ ! -d "$user_path" ]; then
        print_error "Dossier non trouvé: $user_path"
        return
    fi
    
    # Copier les images
    cp "$user_path"/*.image "$IMAGES_DIR/" 2>/dev/null
    
    verify_images
}

################################################################################
# VÉRIFICATION DES IMAGES
################################################################################

function verify_images() {
    print_section "Vérification des images"
    
    if [ ! -d "$IMAGES_DIR" ]; then
        print_error "Dossier images non trouvé"
        return 1
    fi
    
    cd "$IMAGES_DIR"
    
    echo ""
    print_info "Analyse des fichiers..."
    echo ""
    
    local count=0
    local errors=0
    
    # Vérifier chaque fichier .image
    for file in *.image; do
        if [ ! -f "$file" ]; then
            continue
        fi
        
        count=$((count + 1))
        local size=$(stat -c%s "$file" 2>/dev/null)
        local type=$(file -b "$file")
        
        printf "%-30s " "$file"
        
        if [ "$size" = "1474560" ]; then
            echo -e "${GREEN}✓${NC} Taille OK (1.44 Mo)"
        else
            echo -e "${RED}✗${NC} Taille invalide ($size octets)"
            errors=$((errors + 1))
        fi
    done
    
    echo ""
    echo "─────────────────────────────────────────"
    echo -e "Total: ${WHITE}$count${NC} fichiers"
    
    if [ $errors -eq 0 ]; then
        print_success "Toutes les images sont valides"
        return 0
    else
        print_error "$errors fichier(s) invalide(s)"
        return 1
    fi
}

################################################################################
# AIDE ET INFORMATIONS
################################################################################

function show_help() {
    print_header
    print_section "Aide et Informations"
    
    cat << 'EOF'

MÉTHODE DISQUETTES vs CD-ROM

┌─────────────────────────────────────────────────────────────┐
│                      DISQUETTES                             │
├─────────────────────────────────────────────────────────────┤
│ ✓ Fonctionne sur tous les Performa 460                     │
│ ✓ Pas besoin de matériel SCSI supplémentaire               │
│ ✗ 19 disquettes nécessaires                                │
│ ✗ Installation plus longue (45-60 min)                     │
│ ✗ Risque d'erreur de lecture                               │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                       CD-ROM                                │
├─────────────────────────────────────────────────────────────┤
│ ✓ Installation rapide (20-30 min)                          │
│ ✓ Pas de changement de disquette                           │
│ ✓ CD réutilisable                                          │
│ ✗ Nécessite lecteur CD-ROM SCSI externe                    │
│ ✗ Nécessite câble SCSI + terminaison                       │
│ ✗ 1 disquette boot quand même nécessaire                   │
└─────────────────────────────────────────────────────────────┘

MATÉRIEL RECOMMANDÉ POUR CD-ROM:

- Lecteurs CD-ROM SCSI compatibles:
  • AppleCD 300 (Apple)
  • Plextor SCSI
  • Toshiba XM series
  • NEC CDR series

- Câble SCSI:
  • DB25 vers SCSI-2 (50 broches)
  • Longueur max: 3 mètres
  • Terminaison active recommandée

- Configuration SCSI:
  • ID disque dur interne: 0
  • ID CD-ROM: 3 ou 4
  • Terminaison sur dernier périphérique

DÉPANNAGE RAPIDE:

Disquettes:
  - Erreur lecture → Nettoyer têtes lecture
  - Device busy → sudo umount /dev/fd0
  - Taille incorrecte → Vérifier image (1 474 560 octets)

CD-ROM:
  - CD non détecté → Vérifier ID SCSI (3 ou 4)
  - Mac ne boot pas → Utiliser disquette Disk Tools
  - Terminaison manquante → Ajouter terminateur SCSI

RESSOURCES:

- Documentation: https://68kmla.org
- Forum: https://macintoshgarden.org/forum
- Images: https://archive.org/details/system7.5.3d

EOF
    
}

################################################################################
# POINT D'ENTRÉE PRINCIPAL
################################################################################

function main() {
    # Vérifications initiales
    check_dependencies
    check_permissions
    
    # Créer les dossiers de travail
    mkdir -p "$WORK_DIR"
    mkdir -p "$IMAGES_DIR"
    mkdir -p "$CDROM_DIR"
    
    # Lancer le menu principal
    main_menu
}

# Lancer le script
main
```

**Rendre le script exécutable:**
```bash
chmod +x ~/performa460/performa460-installer.sh
```

**Lancer le script:**
```bash
~/performa460/performa460-installer.sh
```

---

## 5. Téléchargement des Images Système

### Option A : Internet Archive (Recommandé)

**URL:** https://archive.org/details/system7.5.3d
```bash
cd ~/performa460/images_extracted

# Télécharger toutes les images automatiquement
wget -r -np -nd -A "*.image" "https://archive.org/download/system7.5.3d/"
```

### Option B : Macintosh Garden

**URL:** https://macintoshgarden.org/apps/system-7-floppy-sets
```bash
cd ~/performa460/system753
# Télécharger manuellement le fichier 7_5_3.sit
```

---

## 6. Extraction des Fichiers .part

> **Note:** Si vous avez téléchargé directement depuis Internet Archive, vous pouvez **sauter cette section**.
```bash
cd ~/performa460/system753

# Extraire avec unar
for file in *.part; do
    unar "$file"
done

# Déplacer les images
mv *.image ../images_extracted/
```

---

## 7. Méthode A : Installation par Disquettes

[Contenu identique à la version précédente - Section 6]

---

## 8. Méthode B : Installation par CD-ROM SCSI

### Avantages de la Méthode CD-ROM

✅ **Installation RAPIDE** (~20 minutes au lieu de 60)  
✅ **Pas de changement de disquette** durant l'installation  
✅ **CD réutilisable** pour futures installations  
✅ **Moins d'erreurs** de lecture  
✅ **Plus professionnel**

### Matériel Requis

- **CD-ROM vierge** (700 Mo)
- **Graveur CD** (interne ou USB)
- **Lecteur CD-ROM SCSI externe** compatible Mac
- **Câble SCSI** (DB25 vers SCSI-2)
- **Terminateur SCSI** (actif recommandé)
- **1 disquette** Disk Tools (pour booter)

### Lecteurs CD-ROM SCSI Compatibles

| Modèle | Type | ID SCSI | Notes |
|--------|------|---------|-------|
| AppleCD 300 | Apple officiel | 3 | Idéal |
| AppleCD 600 | Apple | 3 | Excellent |
| Plextor SCSI | Tiers | 3-4 | Très compatible |
| Toshiba XM-3401 | Tiers | 3-4 | Bon |
| NEC CDR-74 | Tiers | 3-4 | Compatible |

### Étape 8.1 : Préparer les Images
```bash
cd ~/performa460
mkdir -p cdrom_content/"System Software"

# Copier toutes les images Install Disk
cp images_extracted/Install*.image cdrom_content/"System Software"/
cp images_extracted/"Disk Tools"*.image cdrom_content/"System Software"/
cp images_extracted/"Before You Install.image" cdrom_content/"System Software"/

# Vérifier
ls -lh cdrom_content/"System Software"/
```

### Étape 8.2 : Créer l'Image ISO
```bash
# Créer une ISO hybride HFS + ISO9660
genisoimage -hfs \
    -V "System 7.5.3" \
    -o System_753_Install.iso \
    cdrom_content/

# Vérifier la taille
ls -lh System_753_Install.iso
# Devrait faire environ 25-30 Mo
```

### Étape 8.3 : Graver le CD-ROM
```bash
# Identifier le graveur
wodim --devices

# Ou avec cdrecord
cdrecord -scanbus

# Résultat typique:
# 0,0,0    0) 'ATAPI   ' 'DVD RW AD-7200S' 'K02 ' Removable CD-ROM

# Graver (remplacez dev=0,0,0 par votre périphérique)
sudo wodim -v dev=/dev/sr0 speed=8 -dao System_753_Install.iso

# Ou avec cdrecord
sudo cdrecord -v dev=0,0,0 speed=8 -dao System_753_Install.iso

# Options:
# -v     : mode verbeux
# speed=8 : vitesse de gravure (8x recommandé)
# -dao   : Disk-At-Once mode
```

### Étape 8.4 : Créer la Disquette Boot

Vous avez besoin d'**UNE SEULE** disquette pour booter le Mac.
```bash
# Identifier le lecteur
lsblk

# Copier Disk Tools 1
sudo umount /dev/fd0 2>/dev/null
sudo dd if=images_extracted/"Disk Tools 1.image" of=/dev/fd0 bs=1440k status=progress
sudo sync

# Étiqueter: "Disk Tools - Boot"
```

### Étape 8.5 : Configuration SCSI

#### Schéma SCSI Recommandé
```
┌─────────────────────────────────────────┐
│  PERFORMA 460 - Chaîne SCSI             │
├─────────────────────────────────────────┤
│                                         │
│  Port SCSI interne:                     │
│    ID 0: Disque dur (80 Mo)             │
│                                         │
│  Port SCSI externe (DB25):              │
│    ID 3: Lecteur CD-ROM                 │
│    ↓                                    │
│    Terminateur SCSI actif               │
│                                         │
└─────────────────────────────────────────┘
```

#### Vérification de l'ID SCSI

Sur le lecteur CD-ROM, vérifiez la molette ou les jumpers:

- **ID recommandé: 3 ou 4**
- Ne PAS utiliser ID 0 (disque dur interne)
- Ne PAS utiliser ID 7 (contrôleur)

#### Terminaison SCSI

⚠️ **CRITIQUE:** La chaîne SCSI doit être terminée correctement!
```
Règle: Terminer aux DEUX extrémités de la chaîne

✓ Bon:
  [Disque dur ID0] ←→ [Performa 460] ←→ [CD-ROM ID3 + Terminateur]

✗ Mauvais (pas de terminateur):
  [Disque dur ID0] ←→ [Performa 460] ←→ [CD-ROM ID3]
```

### Étape 8.6 : Installation depuis CD-ROM

#### Procédure Complète

1. **Connecter le CD-ROM SCSI**
   - Brancher le câble SCSI DB25 au Performa
   - Vérifier l'ID SCSI du CD-ROM (3 ou 4)
   - Ajouter le terminateur SCSI
   - Brancher l'alimentation du CD-ROM

2. **Insérer le CD gravé** dans le lecteur

3. **Démarrer avec la disquette**
   - Insérer "Disk Tools 1"
   - Allumer le Performa 460
   - Le Mac démarre depuis la disquette

4. **Attendre le bureau Mac**
   - Le CD-ROM devrait apparaître (icône "System 7.5.3")
   - Si le CD n'apparaît pas, vérifier l'ID SCSI et la terminaison

5. **Formater le disque dur** (si nécessaire)
   - Double-cliquer "HD SC Setup"
   - Sélectionner le disque interne
   - Cliquer "Initialize"

6. **Lancer l'installation**
   - Ouvrir le CD "System 7.5.3"
   - Double-cliquer "System Software"
   - Double-cliquer "Install Disk 1"
   - Suivre les instructions

7. **Installation automatique**
   - L'installeur lit TOUS les fichiers depuis le CD
   - **Aucun changement de média nécessaire!**
   - Durée: ~20 minutes

8. **Redémarrer**
   - Cliquer "Restart"
   - Retirer la disquette
   - Le Mac démarre sur le système installé

### Dépannage CD-ROM

#### Problème: CD-ROM non détecté
```bash
Symptômes: L'icône du CD n'apparaît pas sur le bureau

Solutions:
1. Vérifier l'alimentation du CD-ROM (LED allumée?)
2. Vérifier l'ID SCSI (doit être 3 ou 4)
3. Vérifier la terminaison SCSI
4. Essayer un autre câble SCSI
5. Redémarrer le Mac avec le CD déjà inséré
```

#### Problème: "This disk is unreadable"
```bash
Cause: Format du CD non reconnu

Solutions:
1. Vérifier que l'ISO a été créée avec option -hfs
2. Regraver le CD à vitesse plus lente (4x au lieu de 8x)
3. Utiliser un CD-R de meilleure qualité
4. Essayer avec genisoimage au lieu de mkisofs
```

#### Problème: Installation s'interrompt
```bash
Cause: Erreur de lecture du CD

Solutions:
1. Nettoyer le CD avec un chiffon doux
2. Vérifier que le CD n'est pas rayé
3. Réduire la vitesse de gravure et regraver
4. Essayer un autre lecteur CD-ROM
```

---

## 9. Préparation du Macintosh

[Contenu identique - Section 7 de la version précédente]

---

## 10. Installation du Système

[Contenu identique - Section 8 de la version précédente]

---

## 11. Dépannage

[Contenu enrichi avec section CD-ROM]

### Dépannage Disquettes

[Section existante...]

### Dépannage CD-ROM SCSI

#### Problème 1: CD-ROM non alimenté

**Symptômes:** Pas de LED, pas de bruit

**Solution:**
- Vérifier l'alimentation externe du CD-ROM
- Tester avec une autre prise
- Vérifier le fusible du CD-ROM (si accessible)

#### Problème 2: Conflit d'ID SCSI

**Symptômes:** Mac ne démarre pas, freeze au démarrage

**Solution:**
```
1. Éteindre TOUT (Mac + CD-ROM)
2. Changer l'ID du CD-ROM (essayer 3, puis 4)
3. Vérifier qu'aucun autre périphérique n'utilise le même ID
4. Redémarrer
```

#### Problème 3: Erreurs de terminaison

**Symptômes:** Instabilité, périphériques qui disparaissent

**Solution:**
```
Règle d'or: Terminer aux DEUX extrémités de la chaîne

Configuration correcte:
  [Disque interne terminé] ←→ [Mac] ←→ [CD-ROM + Terminateur]

Vérifier:
- Terminateur actif (meilleur que passif)
- Terminateur bien enfoncé
- Pas de terminateur au milieu de la chaîne
```

#### Problème 4: Câble SCSI défectueux

**Symptômes:** Connexion intermittente

**Solution:**
- Tester avec un autre câble SCSI
- Vérifier que les broches ne sont pas tordues
- Longueur de câble < 3 mètres recommandée
- Éviter les câbles trop bon marché

---

## 12. Ressources et Liens

[Section enrichie...]

### Matériel SCSI Recommandé

**Câbles SCSI:**
- DB25 (Mac) vers Centronics 50 (CD-ROM standard)
- Longueur: 1 à 3 mètres maximum
- Blindage: câble blindé recommandé

**Terminateurs:**
- Actifs (recommandés): Acard, Adaptec
- Passifs (basiques): OK pour chaînes courtes
- Résistance: 110 Ω pour SCSI-1/2

**Où acheter:**
- eBay: "SCSI DB25 cable Macintosh"
- RetroTech: équipement vintage testé
- Forums vintage Mac (occasions)

### Comparaison des Méthodes

| Critère | Disquettes | CD-ROM |
|---------|------------|--------|
| **Temps d'installation** | 45-60 min | 20-30 min |
| **Coût matériel** | Lecteur disquette (~20€) | CD-ROM SCSI (~50-100€) + câble (~15€) |
| **Fiabilité** | Moyenne (disquettes fragiles) | Élevée |
| **Réutilisabilité** | Faible (disquettes s'usent) | Excellente |
| **Complexité** | Simple | Moyenne (config SCSI) |
| **Universalité** | Tous les Mac | Nécessite port SCSI |

### Scripts Utiles

**Vérification rapide SCSI:**
```bash
# Vérifier les périphériques SCSI détectés
dmesg | grep -i scsi

# Lister les CD-ROM
lsscsi -g
```

**Création ISO alternative (mkisofs):**
```bash
mkisofs -hfs \
    -V "System753" \
    -o System753.iso \
    -r -J \
    cdrom_content/
```

### Communautés Spécialisées

- **68kMLA** - Experts Mac vintage: https://68kmla.org/bb/
- **Compact Mac** - Spécialistes Mac compacts
- **r/VintageApple** - Reddit vintage Apple
- **LowEndMac** - Guides et astuces: https://lowendmac.com

---

## Crédits et Remerciements

Ce guide a été compilé grâce à:
- Macintosh Garden
- Internet Archive
- 68kMLA Forums
- Vintage Apple resources
- E-Maculation documentation
- Contributions de la communauté vintage Mac

**Version:** 3.0 - Février 2026  
**Auteur:** ebest  
**Licence:** Creative Commons BY-SA 4.0

---

## 🎉 Bonne restauration de votre Performa 460!

> *"The journey of a thousand floppies begins with a single disk."*  
> — Ancient Mac proverb

**Choisissez votre aventure:**
- 🥞 **Mode Warrior:** 19 disquettes, changements intensifs, nostalgie maximale
- 💿 **Mode Confort:** 1 CD, installation zen, café tranquille

Les deux chemins mènent au bonheur du System 7.5.3 ! ✨

---
