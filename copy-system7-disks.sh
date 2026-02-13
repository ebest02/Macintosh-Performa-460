#!/bin/bash

# CONFIGURATION PAR DÉFAUT (modifiable via les invites)
DEFAULT_IMAGES_DIR="/home/ebest/Documents/7.5.3/7.5.3 Disk Images/System Software"

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Liste des disquettes dans l'ordre
DISKS=(
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

#─────────────────────────────────────────────────────────────────────────────
# FONCTIONS UTILITAIRES
#─────────────────────────────────────────────────────────────────────────────

afficher_entete() {
    echo ""
    echo -e "${YELLOW}============================================${NC}"
    echo -e "${YELLOW}  Copie des disquettes System 7.5.3${NC}"
    echo -e "${YELLOW}============================================${NC}"
    echo ""
}

afficher_menu_principal() {
    echo -e "${CYAN}─── Menu principal ───${NC}"
    echo "  1) Choisir le périphérique cible (/dev/sdX)"
    echo "  2) Choisir le répertoire des images"
    echo "  3) Copier toutes les disquettes (19 images)"
    echo "  4) Copier une disquette spécifique"
    echo "  5) Afficher la configuration actuelle"
    echo "  6) Lister les périphériques disponibles (lsblk)"
    echo "  0) Quitter"
    echo ""
}

prompt_choix() {
    local msg="$1"
    local default="$2"
    local reponse
    if [ -n "$default" ]; then
        read -r -p "$(echo -e "${CYAN}$msg${NC} [${default}]: ")" reponse
        echo "${reponse:-$default}"
    else
        read -r -p "$(echo -e "${CYAN}$msg${NC}: ")" reponse
        echo "$reponse"
    fi
}

confirmer() {
    local msg="$1"
    local reponse
    read -r -p "$(echo -e "${YELLOW}$msg (o/n)${NC}: ")" reponse
    case "${reponse,,}" in
        o|oui|y|yes) return 0 ;;
        *) return 1 ;;
    esac
}

choisir_peripherique() {
    echo ""
    echo -e "${BOLD}Périphériques disponibles:${NC}"
    lsblk -d -o NAME,SIZE,MODEL,TRAN 2>/dev/null || lsblk
    echo ""
    local device
    device=$(prompt_choix "Entrez le périphérique (ex: /dev/sdb)" "$DEVICE")
    if [ -b "$device" ]; then
        DEVICE="$device"
        echo -e "${GREEN}✓ Périphérique configuré: $DEVICE${NC}"
    else
        echo -e "${RED}✗ $device n'est pas un périphérique bloc valide${NC}"
        return 1
    fi
}

choisir_repertoire() {
    echo ""
    local dir
    dir=$(prompt_choix "Répertoire des images" "$IMAGES_DIR")
    if [ -d "$dir" ]; then
        IMAGES_DIR="$dir"
        echo -e "${GREEN}✓ Répertoire configuré: $IMAGES_DIR${NC}"
    else
        echo -e "${RED}✗ Le répertoire '$dir' n'existe pas${NC}"
        return 1
    fi
}

afficher_config() {
    echo ""
    echo -e "${BOLD}Configuration actuelle:${NC}"
    echo "  Périphérique : ${DEVICE:-non défini}"
    echo "  Répertoire   : ${IMAGES_DIR:-non défini}"
    
    if [ -n "$IMAGES_DIR" ] && [ -d "$IMAGES_DIR" ]; then
        echo ""
        echo "  Images trouvées:"
        for d in "${DISKS[@]}"; do
            if [ -f "$IMAGES_DIR/$d" ]; then
                echo -e "    ${GREEN}✓${NC} $d"
            else
                echo -e "    ${RED}✗${NC} $d (manquant)"
            fi
        done
    fi
    echo ""
}

menu_action_disquette() {
    echo ""
    echo -e "${CYAN}─── Action pour cette disquette ───${NC}"
    echo "  [Entrée] Continuer la copie"
    echo "  s) Sauter cette disquette"
    echo "  r) Réessayer la copie"
    echo "  a) Annuler tout et quitter"
    echo ""
    read -r -p "$(echo -e "${CYAN}Votre choix${NC} [Entrée=copier]: ")" choix
    echo "$choix"
}

#─────────────────────────────────────────────────────────────────────────────
# COPIE D'UNE DISQUETTE
#─────────────────────────────────────────────────────────────────────────────

copier_disquette() {
    local disk="$1"
    local label
    label=$(basename "$disk" .image)
    
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}Fichier: $disk${NC}"
    echo -e "${GREEN}========================================${NC}"
    
    if [ ! -f "$IMAGES_DIR/$disk" ]; then
        echo -e "${RED}ERREUR: Fichier non trouvé: $disk${NC}"
        return 2
    fi
    
    while true; do
        echo ""
        echo -e "${YELLOW}Insérez la disquette et appuyez sur Entrée...${NC}"
        echo "(Étiquetez-la: $label)"
        read -r
        
        # Démonter
        sudo umount "${DEVICE}"* 2>/dev/null
        
        echo "Copie en cours..."
        local dd_tmp dd_exit
        dd_tmp=$(mktemp)
        sudo dd if="$IMAGES_DIR/$disk" of="$DEVICE" bs=1440k status=progress 2>&1 | tee "$dd_tmp"
        dd_exit=${PIPESTATUS[0]}
        
        if [ $dd_exit -eq 0 ]; then
            sudo sync
            echo ""
            echo -e "${GREEN}✓ Copie réussie!${NC}"
            
            if sudo file -s "$DEVICE" 2>/dev/null | grep -q "Macintosh HFS"; then
                echo -e "${GREEN}✓ Format HFS vérifié${NC}"
            else
                echo -e "${YELLOW}⚠ Format non reconnu (peut fonctionner quand même)${NC}"
            fi
            
            echo ""
            echo "Retirez la disquette et étiquetez-la: ${BOLD}$label${NC}"
            rm -f "$dd_tmp"
            return 0
        else
            echo -e "${RED}✗ Erreur de copie!${NC}"
            # Détecter l'erreur "Aucun espace disponible"
            if grep -qiE "No space left on device|Aucun espace disponible|No space" "$dd_tmp" 2>/dev/null; then
                echo ""
                echo -e "${RED}⚠ Aucun espace disponible sur le périphérique${NC}"
                echo ""
                echo "Causes possibles:"
                echo "  • Le lecteur USB contient une disquette déjà pleine ou corrompue"
                echo "  • Mauvais périphérique sélectionné"
                echo "  • Le lecteur doit être débranché puis rebranché"
                echo ""
                action=$(menu_erreur_espace)
            else
                action=$(menu_action_disquette)
            fi
            rm -f "$dd_tmp"
            case "${action,,}" in
                s) echo "Disquette sautée."; return 1 ;;
                a) echo "Opération annulée."; exit 0 ;;
                r) echo "Nouvelle tentative..." ;;
                *) echo "Nouvelle tentative..." ;;
            esac
        fi
    done
}

#─────────────────────────────────────────────────────────────────────────────
# FLUX PRINCIPAL
#─────────────────────────────────────────────────────────────────────────────

configurer_defauts() {
    # Répertoire par défaut
    if [ -d "$DEFAULT_IMAGES_DIR" ]; then
        IMAGES_DIR="$DEFAULT_IMAGES_DIR"
    else
        IMAGES_DIR=""
    fi
    
    # Périphérique: essayer de détecter sdb comme défaut
    if [ -b "/dev/sdb" ]; then
        DEVICE="/dev/sdb"
    else
        DEVICE=""
    fi
}

boucle_interactive() {
    configurer_defauts
    afficher_entete
    
    while true; do
        afficher_menu_principal
        local choix
        choix=$(prompt_choix "Choisissez une option" "3")
        
        case "$choix" in
            1) choisir_peripherique ;;
            2) choisir_repertoire ;;
            3)
                if [ -z "$DEVICE" ]; then
                    echo -e "${RED}Configurez d'abord le périphérique (option 1)${NC}"
                    choisir_peripherique || continue
                fi
                if [ -z "$IMAGES_DIR" ]; then
                    echo -e "${RED}Configurez d'abord le répertoire (option 2)${NC}"
                    choisir_repertoire || continue
                fi
                if [ ! -b "$DEVICE" ]; then
                    echo -e "${RED}$DEVICE n'existe pas. Reconfigurez le périphérique.${NC}"
                    continue
                fi
                
                if ! confirmer "Copier les 19 disquettes vers $DEVICE ? (OPÉRATION DESTRUCTIVE)"; then
                    continue
                fi
                
                cd "$IMAGES_DIR" || exit 1
                TOTAL=${#DISKS[@]}
                CURRENT=0
                
                for disk in "${DISKS[@]}"; do
                    CURRENT=$((CURRENT + 1))
                    echo ""
                    echo -e "${BOLD}Disquette $CURRENT / $TOTAL${NC}"
                    
                    if copier_disquette "$disk"; then
                        :
                    elif [ $? -eq 1 ]; then
                        echo "Disquette $disk sautée."
                    fi
                    
                    if [ $CURRENT -lt $TOTAL ]; then
                        echo ""
                        action=$(menu_action_disquette)
                        case "${action,,}" in
                            a) echo "Opération annulée."; break 2 ;;
                            s) echo "Passage à la disquette suivante..." ;;
                        esac
                    fi
                done
                
                echo ""
                echo -e "${GREEN}============================================${NC}"
                echo -e "${GREEN}  ✓ TERMINÉ! ${TOTAL} disquettes traitées${NC}"
                echo -e "${GREEN}============================================${NC}"
                echo ""
                echo "Ordre d'installation sur le Performa 460:"
                echo "1. Démarrer avec 'Disk Tools 1'"
                echo "2. Installer avec Install Disk 1 à 16"
                echo "3. Utiliser Disk Tools 2 si nécessaire"
                ;;
            4)
                if [ -z "$DEVICE" ] || [ -z "$IMAGES_DIR" ]; then
                    echo -e "${RED}Configurez d'abord le périphérique et le répertoire (options 1 et 2)${NC}"
                    continue
                fi
                
                echo ""
                echo "Disquettes disponibles:"
                for i in "${!DISKS[@]}"; do
                    echo "  $((i+1))) ${DISKS[$i]}"
                done
                echo "  0) Retour au menu"
                echo ""
                
                local num
                num=$(prompt_choix "Numéro de la disquette à copier" "")
                [ -z "$num" ] && continue
                [ "$num" = "0" ] && continue
                
                if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le "${#DISKS[@]}" ]; then
                    cd "$IMAGES_DIR" || exit 1
                    copier_disquette "${DISKS[$((num-1))]}"
                else
                    echo -e "${RED}Numéro invalide${NC}"
                fi
                ;;
            5) afficher_config ;;
            6)
                echo ""
                lsblk
                echo ""
                ;;
            0)
                echo "Au revoir!"
                exit 0
                ;;
            *)
                echo -e "${RED}Option non reconnue${NC}"
                ;;
        esac
    done
}

# Point d'entrée
boucle_interactive
