# README.md - Installation System 7.5.3 sur Macintosh Performa 460

> **Guide complet pour restaurer votre Macintosh Performa 460 avec System 7.5.3**  
> Utilisation de Linux pour créer les supports d'installation

---

## 📋 Table des Matières

1. [À Propos](#-à-propos)
2. [Prérequis](#-prérequis)
3. [Choix de la Méthode](#-choix-de-la-méthode)
4. [Installation Rapide](#-installation-rapide)
5. [Utilisation du Script](#-utilisation-du-script)
6. [Structure du Projet](#-structure-du-projet)
7. [Dépannage](#-dépannage)
8. [Ressources](#-ressources)
9. [Contribution](#-contribution)

---

## 📖 À Propos

Ce projet vous guide dans la réinstallation complète d'un **Macintosh Performa 460** (1993) en utilisant un système Linux moderne. Deux méthodes sont disponibles :

- **🥞 Méthode Disquettes** : Installation classique avec 19 disquettes 1.44 Mo
- **💿 Méthode CD-ROM** : Installation moderne via CD-ROM SCSI

### Caractéristiques du Performa 460

| Composant | Spécification |
|-----------|---------------|
| Processeur | Motorola 68030 @ 33 MHz |
| RAM | 4 Mo (extensible à 36 Mo) |
| Disque dur | 80 Mo SCSI |
| Lecteur | SuperDrive 1.44 Mo |
| Système | System 7.1P3/P5 (origine) |
| Compatible | System 7.5.3 à Mac OS 8.1 |

---

## ✅ Prérequis

### Matériel Requis

#### Pour la Méthode Disquettes

- [ ] **Linux** (Debian/Ubuntu/Kaisen Linux)
- [ ] **19-20 disquettes 2HD** (1.44 Mo) neuves ou en excellent état
- [ ] **Lecteur de disquettes** USB externe OU interne
- [ ] **Macintosh Performa 460** fonctionnel
- [ ] Clavier et souris ADB
- [ ] Moniteur compatible

#### Pour la Méthode CD-ROM

- [ ] **Linux** (Debian/Ubuntu/Kaisen Linux)
- [ ] **1 CD-ROM vierge** (700 Mo)
- [ ] **Graveur CD** (USB ou interne)
- [ ] **1 disquette** pour booter (Disk Tools 1)
- [ ] **Lecteur CD-ROM SCSI externe** pour Mac
- [ ] **Câble SCSI** + terminaison
- [ ] **Macintosh Performa 460** fonctionnel
- [ ] Clavier, souris ADB, moniteur

### Logiciels Linux

Les outils suivants seront installés automatiquement par le script :

- `hfsutils` et `hfsprogs` - Formatage HFS (Macintosh)
- `unar` - Extraction d'archives Mac
- `genisoimage` et `wodim` - Création et gravure de CD
- `dd` - Copie d'images disque

---

## 🎯 Choix de la Méthode

### Comparaison des Méthodes

| Critère | 🥞 Disquettes | 💿 CD-ROM |
|---------|---------------|-----------|
| **Temps installation** | 45-60 minutes | 20-30 minutes |
| **Nombre de supports** | 19 disquettes | 1 CD + 1 disquette |
| **Changement média** | Oui (18 fois) | Non |
| **Coût matériel** | ~20€ (lecteur USB) | ~50-100€ (CD-ROM SCSI) |
| **Fiabilité** | Moyenne | Élevée |
| **Réutilisabilité** | Faible | Excellente |
| **Complexité** | Simple | Moyenne (config SCSI) |
| **Universalité** | Tous les Mac | Nécessite port SCSI |

### Quelle Méthode Choisir ?

**Choisissez les DISQUETTES si :**
- ✅ Vous débutez avec le rétro-computing
- ✅ Vous n'avez pas de matériel SCSI
- ✅ Vous voulez l'expérience authentique années 90
- ✅ Budget limité

**Choisissez le CD-ROM si :**
- ✅ Vous avez un lecteur CD-ROM SCSI
- ✅ Vous voulez réinstaller plusieurs fois
- ✅ Vous préférez la rapidité
- ✅ Vous êtes à l'aise avec la config SCSI

---

## 🚀 Installation Rapide

### Étape 1 : Cloner le Projet

```bash
git clone https://github.com/votre-repo/performa460-installer.git
cd performa460-installer
```

Ou téléchargez et extrayez l'archive ZIP.

### Étape 2 : Lancer le Script Interactif

```bash
chmod +x performa460-installer.sh
./performa460-installer.sh
```

Le script vous guidera pas à pas à travers :
1. Vérification des dépendances
2. Téléchargement de System 7.5.3
3. Création des supports (disquettes ou CD)
4. Instructions d'installation sur le Mac

### Étape 3 : Suivre les Instructions

Le script affichera des instructions claires pour :
- Identifier votre lecteur de disquettes ou graveur
- Créer les supports d'installation
- Installer System 7.5.3 sur votre Performa 460

---

## 🛠️ Utilisation du Script

### Menu Principal

Au lancement, le script propose :

```
┌────────────────────────────────────────────────────────┐
│  INSTALLATION SYSTEM 7.5.3 - MACINTOSH PERFORMA 460    │
└────────────────────────────────────────────────────────┘

Choisissez la méthode d'installation :

  1) Installation par DISQUETTES (19 disquettes requises)
  2) Installation par CD-ROM SCSI (1 CD + 1 disquette boot)
  3) Télécharger les images System 7.5.3
  4) Vérifier les images téléchargées
  5) Aide et informations
  6) Quitter
```

### Option 1 : Installation par Disquettes

Le script vous guidera pour :

1. **Identifier le lecteur**
   - Détection automatique du lecteur interne (`/dev/fd0`)
   - Configuration manuelle pour lecteur USB (`/dev/sdb`)

2. **Vérifier les images**
   - Contrôle de la présence des 16-19 fichiers .image
   - Proposition de téléchargement si manquant

3. **Créer les disquettes**
   - Copie automatique sur chaque disquette
   - Vérification du format HFS
   - Instructions d'étiquetage

4. **Instructions finales**
   - Ordre d'utilisation des disquettes
   - Procédure d'installation sur le Mac

### Option 2 : Installation par CD-ROM

Le script vous guidera pour :

1. **Vérifier les images**
   - Contrôle des fichiers nécessaires
   - Téléchargement automatique si besoin

2. **Créer l'image ISO**
   - Construction d'une ISO hybride HFS + ISO9660
   - Compatible avec les Macintosh

3. **Graver le CD**
   - Détection automatique du graveur
   - Gravure avec vérification

4. **Créer la disquette boot**
   - Une seule disquette "Disk Tools 1" nécessaire

5. **Instructions SCSI**
   - Configuration de la chaîne SCSI
   - Procédure d'installation

### Option 3 : Télécharger les Images

Sources disponibles :

- **Internet Archive** (recommandé) - Images directes
- **Macintosh Garden** - Archive .sit à extraire
- **Images locales** - Utiliser des fichiers déjà téléchargés

### Option 4 : Vérifier les Images

Contrôle automatique :
- Nombre de fichiers présents
- Taille de chaque fichier (doit être 1 474 560 octets)
- Intégrité des images

### Option 5 : Aide

Affiche :
- Comparaison détaillée des méthodes
- Matériel SCSI recommandé
- Dépannage rapide
- Liens vers ressources

---

## 📁 Structure du Projet

```
performa460-installer/
│
├── README.md                          # Ce fichier
├── LICENSE                            # Licence MIT
├── performa460-installer.sh           # Script principal interactif
├── copy-system7-disks.sh              # Script de copie disquettes (standalone)
│
├── docs/                              # Documentation complète
│   ├── guide-complet.md               # Guide détaillé avec commandes
│   ├── guide-cd-rom.md                # Guide spécifique CD-ROM bootable
│   └── troubleshooting.md             # Dépannage approfondi
│
├── images_extracted/                  # Images System 7.5.3 (à créer)
│   ├── Install Disk 1.image
│   ├── Install Disk 2.image
│   ├── ...
│   ├── Install Disk 16.image
│   ├── Disk Tools 1.image
│   ├── Disk Tools 2.image
│   └── Before You Install.image
│
└── cdrom_content/                     # Contenu CD (généré par script)
    └── System Software/
        └── [fichiers .image]
```

---

## 🔧 Dépannage

### Problèmes Courants - Disquettes

#### Disquette non détectée

**Symptômes :** Le lecteur n'est pas reconnu sous Linux

**Solutions :**
1. Vérifier que le module est chargé : `lsmod | grep floppy`
2. Charger le module si absent : `sudo modprobe floppy`
3. Pour lecteur USB : vérifier avec `lsblk`

#### "Device busy"

**Symptômes :** Impossible de copier sur la disquette

**Solutions :**
1. Démonter la disquette : `sudo umount /dev/fd0`
2. Vérifier qu'aucun programme n'utilise le lecteur
3. Redémarrer et réessayer

#### Erreur de lecture sur Mac

**Symptômes :** "This disk is unreadable by this Macintosh"

**Solutions :**
1. Vérifier la taille de l'image (doit être exactement 1 474 560 octets)
2. Recréer la disquette avec le script
3. Essayer une autre disquette vierge
4. Nettoyer la tête de lecture du Mac

### Problèmes Courants - CD-ROM

#### CD non détecté sur le Mac

**Symptômes :** Pas d'icône de CD sur le bureau

**Solutions :**
1. Vérifier l'alimentation du lecteur CD-ROM SCSI
2. Vérifier l'ID SCSI (doit être 3 ou 4)
3. Vérifier la terminaison SCSI (terminateur actif recommandé)
4. Tester le câble SCSI
5. Redémarrer Mac + CD-ROM ensemble

#### "This disk is unreadable"

**Symptômes :** Le CD est détecté mais illisible

**Solutions :**
1. Vérifier que l'ISO a été créée avec l'option `-hfs`
2. Regraver le CD à vitesse plus lente (4x au lieu de 8x)
3. Utiliser un CD-R de meilleure qualité (Verbatim, TDK, Sony)
4. Nettoyer le CD avec un chiffon doux

#### Configuration SCSI incorrecte

**Symptômes :** Instabilité, périphériques qui disparaissent

**Solutions :**

Vérifier la chaîne SCSI complète :

```
[Disque dur interne ID:0] ←→ [Performa 460] ←→ [CD-ROM ID:3] + [Terminateur]
```

Points de contrôle :
- Disque dur interne sur ID 0
- CD-ROM sur ID 3 ou 4 (jamais 0 ou 7)
- Terminateur ACTIF sur le dernier périphérique
- Pas de terminateur au milieu de la chaîne
- Câbles SCSI de bonne qualité (< 3 mètres)

### Aide Supplémentaire

Si vous rencontrez un problème non listé :

1. Consultez le **guide complet** : `docs/guide-complet.md`
2. Consultez le **guide dépannage** : `docs/troubleshooting.md`
3. Visitez les forums communautaires (voir section Ressources)
4. Ouvrez une issue sur GitHub

---

## 📚 Ressources

### Téléchargement System 7.5.3

- **Internet Archive** (recommandé)  
  https://archive.org/details/system7.5.3d  
  Images directes prêtes à l'emploi

- **Macintosh Garden**  
  https://macintoshgarden.org/apps/system-7-floppy-sets  
  Archive complète + autres versions

- **Macintosh Repository**  
  https://www.macintoshrepository.org/598-mac-os-7-floppy-install-sets-system-7-x-

### Documentation Technique

- **EveryMac - Performa 460**  
  https://everymac.com/systems/apple/mac_performa/specs/mac_performa_460.html  
  Spécifications complètes

- **68kMLA - Forum Mac Vintage**  
  https://68kmla.org  
  Communauté d'experts Mac 68k

- **Low End Mac**  
  https://lowendmac.com  
  Guides et astuces Mac vintage

### Outils et Utilitaires

- **HFSExplorer**  
  https://sourceforge.net/projects/catacombae/  
  Lecture de volumes HFS sous Linux/Windows

- **System Enablers**  
  https://macintoshgarden.org/apps/apple-system-enablers  
  Collection complète d'enablers

### Communautés

- **68k Macintosh Liberation Army**  
  https://68kmla.org/bb/  
  Forum très actif

- **r/VintageApple** (Reddit)  
  https://www.reddit.com/r/VintageApple/  
  Communauté Reddit

- **Vintage Computer Forum**  
  https://forum.vcfed.org/  
  Forum généraliste rétro-computing

### Matériel SCSI

**Où acheter du matériel SCSI :**

- **eBay** - Rechercher "SCSI DB25 cable Macintosh" ou "SCSI CD-ROM AppleCD"
- **Forums vintage Mac** - Section petites annonces
- **Conventions rétro-computing** - VCF, Vintage Computer Festival

**Matériel recommandé :**

- Lecteurs CD-ROM : AppleCD 300/600, Plextor SCSI, Toshiba XM
- Câbles : DB25 → Centronics 50, blindés, < 3m
- Terminateurs : Actifs (Acard, Adaptec)

---

## 🤝 Contribution

### Comment Contribuer

Les contributions sont les bienvenues ! Voici comment participer :

1. **Fork** le projet
2. Créez une **branche** pour votre fonctionnalité (`git checkout -b feature/AmazingFeature`)
3. **Committez** vos changements (`git commit -m 'Add some AmazingFeature'`)
4. **Poussez** vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrez une **Pull Request**

### Types de Contributions Appréciées

- 🐛 Corrections de bugs
- 📝 Améliorations de la documentation
- ✨ Nouvelles fonctionnalités
- 🌍 Traductions
- 🧪 Tests et validations
- 💡 Suggestions d'amélioration

### Signaler un Bug

Ouvrez une **issue** sur GitHub avec :
- Description du problème
- Système Linux utilisé
- Méthode choisie (disquettes/CD-ROM)
- Messages d'erreur exacts
- Logs du script si disponibles

### Demander une Fonctionnalité

Ouvrez une **issue** avec le tag `enhancement` :
- Description de la fonctionnalité souhaitée
- Cas d'usage
- Bénéfices attendus

---

## 📄 Licence

Ce projet est sous licence **MIT** - voir le fichier [LICENSE](LICENSE) pour plus de détails.

### En Résumé

Vous êtes libre de :
- ✅ Utiliser ce projet personnellement ou commercialement
- ✅ Modifier le code source
- ✅ Distribuer le projet
- ✅ Utiliser le projet en privé

Sous conditions :
- 📋 Inclure la licence et le copyright original
- 📋 Indiquer les modifications apportées

---

## 👨‍💻 Auteurs

- **ebest** - *Développement initial* - Février 2026

### Remerciements

- **Macintosh Garden** - Archives et préservation
- **Internet Archive** - Hébergement des images
- **68kMLA** - Expertise technique et communauté
- **Communauté vintage Mac** - Tests et retours

---

## 🌟 Versions du Système

### System 7.5.3 (Recommandé) ⭐⭐⭐⭐⭐

- **Avantages :** Stable, gratuit, pas de System Enabler requis
- **Inconvénients :** Aucun
- **Idéal pour :** Utilisation quotidienne

### System 7.5.5 ⭐⭐⭐⭐

- **Avantages :** Plus stable que 7.5.3
- **Inconvénients :** Nécessite 7.5.3 + update
- **Idéal pour :** Utilisation intensive

### System 7.6.1 ⭐⭐⭐

- **Avantages :** Dernière version 68k, fonctionnalités avancées
- **Inconvénients :** Plus gourmand en RAM
- **Idéal pour :** Mac avec 8 Mo+ de RAM

### System 7.1P ⭐⭐⭐

- **Avantages :** Version d'origine, léger, rapide
- **Inconvénients :** Nécessite System Enabler 308
- **Idéal pour :** Puristes, expérience authentique

---

## ⚡ Démarrage Ultra-Rapide

### En 3 Commandes (Méthode Disquettes)

```bash
git clone https://github.com/votre-repo/performa460-installer.git
cd performa460-installer
./performa460-installer.sh
```

Suivez le menu interactif → Choix 1 → Suivez les instructions !

### En 3 Commandes (Méthode CD-ROM)

```bash
git clone https://github.com/votre-repo/performa460-installer.git
cd performa460-installer
./performa460-installer.sh
```

Suivez le menu interactif → Choix 2 → Suivez les instructions !

---

## 🎉 Succès !

Une fois l'installation terminée, vous devriez voir :

```
┌─────────────────────────────────────────┐
│                                         │
│     Bienvenue dans System 7.5.3         │
│                                         │
│         [Happy Mac Icon]                │
│                                         │
│     Macintosh Performa 460              │
│     Motorola 68030 - 33 MHz             │
│     Mémoire : 4096 Ko                   │
│                                         │
└─────────────────────────────────────────┘
```

**Félicitations ! Votre Performa 460 est restauré !** 🖥️✨

---

## 📞 Support

- **Documentation complète :** `docs/guide-complet.md`
- **Issues GitHub :** https://github.com/votre-repo/performa460-installer/issues
- **Forum 68kMLA :** https://68kmla.org/bb/
- **Discord Vintage Apple :** [lien vers serveur]

---

## 🗺️ Roadmap

### Version 1.0 (Actuelle)
- ✅ Installation par disquettes
- ✅ Installation par CD-ROM
- ✅ Script interactif
- ✅ Documentation complète

### Version 1.1 (Prévue)
- ⏳ Support System 7.1P (Performa original)
- ⏳ Support System 7.6.1
- ⏳ Mode silencieux (non-interactif)
- ⏳ Vérification MD5 des images

### Version 2.0 (Future)
- 💡 Support autres modèles Performa (450, 475, 550)
- 💡 Support LC III/LC III+
- 💡 Interface graphique (GTK)
- 💡 Images pré-configurées personnalisées

---

## ❓ FAQ

### Est-ce que ça fonctionne sur d'autres Macs ?

Oui, avec adaptations :
- **Performa 450, 466, 467** : Identique (même hardware)
- **LC III/LC III+** : Identique (version éducation)
- **Performa 475, 476** : Nécessite System Enabler 364
- **Autres 68k Macs** : Vérifier la compatibilité System Enabler

### Puis-je utiliser Windows au lieu de Linux ?

Oui, avec des outils alternatifs :
- **WinImage** - Pour écrire images sur disquettes
- **TransMac** - Pour formater et copier
- **ImgBurn** - Pour graver CD

Mais le script bash ne fonctionnera pas directement.

### Le CD-ROM sera-t-il bootable ?

**Non.** Le Performa 460 (68k) **ne peut pas** booter depuis CD-ROM. Cette capacité est apparue avec les Power Macintosh (PowerPC). Vous devez toujours booter avec la disquette "Disk Tools 1", puis installer depuis le CD.

### Combien de temps prend l'installation ?

- **Création des supports :** 30-45 min (disquettes) ou 10 min (CD)
- **Installation sur Mac :** 45-60 min (disquettes) ou 20-30 min (CD)
- **Total :** ~1h30 (disquettes) ou ~40 min (CD)

### Où trouver un lecteur CD-ROM SCSI ?

- eBay (chercher "AppleCD SCSI" ou "Plextor SCSI")
- Forums vintage Mac (occasions)
- Conventions rétro-computing
- Prix : 30-100€ selon modèle et état

---

> **"Think Different"** - Apple Inc.

**Bon voyage dans les années 90 ! 🚀**
