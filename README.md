# Guide Complet : Réinstaller un Macintosh Performa 460 avec Linux

> **Date:** Février 2026  
> **Système cible:** Macintosh Performa 460  
> **OS hôte:** Linux (Debian/Ubuntu/Kaisen Linux)

---

## Table des Matières

1. [Informations sur le Performa 460](#1-informations-sur-le-performa-460)
2. [Matériel et Logiciels Nécessaires](#2-matériel-et-logiciels-nécessaires)
3. [Préparation du Système Linux](#3-préparation-du-système-linux)
4. [Téléchargement des Images Système](#4-téléchargement-des-images-système)
5. [Extraction des Fichiers .part](#5-extraction-des-fichiers-part)
6. [Création des Disquettes d'Installation](#6-création-des-disquettes-dinstallation)
   - [Lecteur USB Externe](#création-avec-lecteur-usb-externe)
   - [Lecteur Interne](#création-avec-lecteur-interne)
7. [Préparation du Macintosh](#7-préparation-du-macintosh)
8. [Installation du Système](#8-installation-du-système)
9. [Dépannage](#9-dépannage)
10. [Ressources et Liens](#10-ressources-et-liens)

---

## 1. Informations sur le Performa 460

### Spécifications Techniques

| Composant | Spécification |
|-----------|---------------|
| **Processeur** | Motorola 68030 à 33 MHz |
| **RAM** | 4 Mo (extensible à 36 Mo) |
| **Disque dur** | 80 Mo SCSI |
| **Lecteur** | SuperDrive 1.44 Mo (2HD, double face) |
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

### Matériel

- [ ] **19-20 disquettes 2HD (1.44 Mo)** NEUVES ou en excellent état
- [ ] **Lecteur de disquettes** USB externe OU interne compatible Linux
- [ ] **Macintosh Performa 460** fonctionnel
- [ ] **Clavier et souris ADB**
- [ ] **Moniteur** compatible (VGA ou Apple)
- [ ] **Câble d'alimentation**

### Logiciels Linux

- [ ] `hfsutils` et `hfsprogs` (pour formater HFS)
- [ ] `unar` ou HFSExplorer (pour extraire archives Mac)
- [ ] `dd` (normalement préinstallé)
- [ ] Java 11+ (pour HFSExplorer)

### Fichiers à Télécharger

- [ ] **System 7.5.3** (16-19 images de disquettes)
- [ ] **Disk Tools** (disquettes de boot/utilitaires)
- [ ] *(Optionnel)* SuperBooter75 (utilitaires universels)
- [ ] *(Optionnel)* System Enabler 308 (si System 7.1)

---

## 3. Préparation du Système Linux

### Étape 3.1 : Installation des outils nécessaires
```bash
