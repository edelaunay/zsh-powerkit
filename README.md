# Configuration ZSH Avancée avec Git et FZF

Une configuration zsh riche et moderne avec intégration Git, FZF et de nombreuses fonctionnalités pour améliorer votre productivité en ligne de commande.

## ✨ Fonctionnalités

### 🎨 Interface
- **Prompt personnalisé** avec couleurs et informations contextuelles
- **Statut Git en temps réel** dans le prompt (branche, état, commits en avance/retard)
- **Coloration syntaxique** pour les commandes
- **Suggestions automatiques** basées sur l'historique

### 🔧 Outils Git
- **Aliases Git complets** pour toutes les opérations courantes
- **Fonction `gitsum()`** pour un résumé Git coloré
- **Navigation interactive** dans les branches et commits
- **Intégration FZF** pour Git (recherche de fichiers, commits, etc.)

### 🚀 Fonctions FZF Avancées
- **Recherche de fichiers** avec preview
- **Navigation dans les répertoires** interactive
- **Recherche dans l'historique** et exécution
- **Gestion des processus** interactive
- **Recherche dans le contenu** des fichiers
- **Outils Docker** interactifs
- **Connexion SSH** simplifiée

## 📋 Prérequis

### Obligatoires
- `zsh` (version 5.0+)
- `git`

### Optionnels (mais recommandés)
- `fzf` - Pour toutes les fonctions de recherche interactive
- `bat` - Pour la coloration syntaxique dans les previews
- `zsh-syntax-highlighting` - Coloration des commandes en temps réel
- `zsh-autosuggestions` - Suggestions automatiques

## 🛠️ Installation

### 1. Installation des dépendances

#### Sur Ubuntu/Debian :
```bash
# Packages de base
sudo apt update
sudo apt install zsh git fzf bat

# Plugins zsh
sudo apt install zsh-syntax-highlighting zsh-autosuggestions

# Faire de zsh le shell par défaut
chsh -s $(which zsh)
```

#### Sur macOS :
```bash
# Avec Homebrew
brew install zsh git fzf bat
brew install zsh-syntax-highlighting zsh-autosuggestions

# Faire de zsh le shell par défaut
chsh -s /opt/homebrew/bin/zsh
```

#### Sur Arch Linux :
```bash
sudo pacman -S zsh git fzf bat
sudo pacman -S zsh-syntax-highlighting zsh-autosuggestions
chsh -s /usr/bin/zsh
```

### 2. Installation de la configuration

```bash
# Sauvegarder votre configuration actuelle (optionnel)
cp ~/.zshrc ~/.zshrc.backup

# Copier le fichier de configuration
cp paste.txt ~/.zshrc

# Recharger la configuration
source ~/.zshrc
```

### 3. Configuration Git (première utilisation)

```bash
# Configurer vos informations Git
git config --global user.name "Votre Nom"
git config --global user.email "votre@email.com"

# Les couleurs Git sont automatiquement configurées par le script
```

## 🎯 Guide d'utilisation

### Prompt Git
Le prompt affiche automatiquement :
- `[branche ✓]` : Branche propre (vert)
- `[branche ✗]` : Branche avec modifications (rouge)
- `[branche ✓⇡]` : Commits en avance
- `[branche ✓⇣]` : Commits en retard
- `[branche ✓⇵]` : Commits en avance ET en retard

### Aliases Git Principaux
```bash
# Statut et ajouts
gs          # git status
ga <file>   # git add
gaa         # git add --all

# Commits
gc          # git commit
gcm "msg"   # git commit -m
gca "msg"   # git commit -am

# Synchronisation
gp          # git push
gpl         # git pull

# Visualisation
gd          # git diff
gl          # git log --oneline --graph
gla         # git log --all --graph

# Branches
gb          # git branch
gco <branch> # git checkout
gcb <branch> # git checkout -b

# Stash
gst         # git stash
gsta        # git stash apply
gstl        # git stash list
```

### Fonctions FZF Principales

#### Recherche et édition
```bash
fe          # Recherche et édition de fichiers
fv          # Recherche avec preview (bat)
frg <term>  # Recherche dans le contenu des fichiers
```

#### Navigation
```bash
fcd         # Changement de répertoire interactif
fh          # Recherche dans l'historique
```

#### Git avec FZF
```bash
fgl         # Git log interactif avec diff
fgco        # Checkout de commit interactif
gcof        # Checkout de branche interactif
gf          # Recherche de fichiers Git
```

#### Outils système
```bash
fkill       # Kill process interactif
fssh        # Connexion SSH interactive
fdoc        # Docker exec interactif
```

#### Gestion de fichiers
```bash
fcp         # Copie de fichiers interactive
frm         # Suppression de fichiers interactive
```

### Fonction GitSum
```bash
gitsum      # Affiche un résumé Git coloré complet
```

## ⚙️ Personnalisation

### Modifier les couleurs du prompt
Éditez les variables dans `~/.zshrc` :
```bash
# Couleurs disponibles : black, red, green, yellow, blue, magenta, cyan, white
PROMPT='%{$fg[cyan]%}[%n@%m]%{$reset_color%} %{$fg[yellow]%}%~%{$reset_color%}$(git_prompt_info) %{$fg[green]%}❯%{$reset_color%} '
```

### Ajouter des aliases personnalisés
Ajoutez vos aliases à la fin du fichier :
```bash
# Mes aliases personnalisés
alias myalias='ma_commande'
```

### Modifier les options FZF
Éditez `FZF_DEFAULT_OPTS` pour changer l'apparence :
```bash
export FZF_DEFAULT_OPTS="--height 60% --layout=reverse --border"
```

## 🔧 Résolution de problèmes

### FZF ne fonctionne pas
```bash
# Vérifier l'installation
which fzf
fzf --version

# Réinstaller si nécessaire
sudo apt install fzf  # Ubuntu/Debian
brew install fzf      # macOS
```

### Coloration syntaxique manquante
```bash
# Vérifier les plugins
ls /usr/share/zsh-syntax-highlighting/
ls /usr/share/zsh-autosuggestions/

# Installer si manquant
sudo apt install zsh-syntax-highlighting zsh-autosuggestions
```

### Prompt Git ne s'affiche pas
```bash
# Vérifier que vous êtes dans un repo Git
git status

# Vérifier la fonction git_prompt_info
which git_prompt_info
```

### Historique non persistant
```bash
# Vérifier les permissions du fichier d'historique
ls -la ~/.zsh_history
touch ~/.zsh_history
chmod 600 ~/.zsh_history
```

## 📚 Raccourcis clavier

- `Ctrl+R` : Recherche dans l'historique avec FZF
- `Flèche haut/bas` : Navigation dans l'historique avec recherche
- `Home/End` : Début/fin de ligne
- `Delete` : Suppression du caractère suivant

## 🚀 Commandes utiles au quotidien

```bash
# Workflow Git complet
gs           # Voir le statut
gaa          # Ajouter tous les fichiers
gcm "fix"    # Commit avec message
gp           # Push

# Recherche rapide
fe           # Ouvrir un fichier
frg "TODO"   # Chercher "TODO" dans tous les fichiers
fcd          # Aller dans un répertoire

# Résumé de projet
gitsum       # Voir l'état du projet Git
```

## 🤝 Contribution

N'hésitez pas à adapter cette configuration à vos besoins ! Vous pouvez :
- Ajouter vos propres aliases
- Modifier les couleurs
- Créer de nouvelles fonctions FZF
- Adapter le prompt à vos préférences

## 📄 Licence

MIT License © 2025 edelaunay

Cette configuration est libre d'utilisation et de modification. Si vous trouvez ce projet utile, une petite ⭐ sur GitHub serait appréciée !
