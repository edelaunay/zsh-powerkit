#!/bin/bash

# ZSH PowerKit - Script d'installation automatique
# MIT License © 2025

set -e  # Arrêter le script en cas d'erreur

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction pour afficher les messages
print_message() {
    echo -e "${BLUE}[ZSH PowerKit]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Vérifier que nous sommes sur un système compatible
check_system() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        SYSTEM="linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        SYSTEM="macos"
    else
        print_error "Système non supporté: $OSTYPE"
        exit 1
    fi
}

# Vérifier les prérequis
check_requirements() {
    print_message "Vérification des prérequis..."

    # Vérifier zsh
    if ! command -v zsh &> /dev/null; then
        print_error "zsh n'est pas installé"
        print_message "Installation de zsh..."
        install_zsh
    else
        print_success "zsh trouvé: $(which zsh)"
    fi

    # Vérifier git
    if ! command -v git &> /dev/null; then
        print_error "git n'est pas installé"
        print_message "Installation de git..."
        install_git
    else
        print_success "git trouvé: $(which git)"
    fi

    # Vérifier fzf (optionnel)
    if ! command -v fzf &> /dev/null; then
        print_warning "fzf n'est pas installé (optionnel mais recommandé)"
        read -p "Voulez-vous installer fzf ? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            install_fzf
        fi
    else
        print_success "fzf trouvé: $(which fzf)"
    fi
}

# Installation de zsh selon le système
install_zsh() {
    case $SYSTEM in
        linux)
            if command -v apt &> /dev/null; then
                sudo apt update && sudo apt install -y zsh
            elif command -v yum &> /dev/null; then
                sudo yum install -y zsh
            elif command -v pacman &> /dev/null; then
                sudo pacman -S zsh
            else
                print_error "Gestionnaire de paquets non supporté"
                exit 1
            fi
            ;;
        macos)
            if command -v brew &> /dev/null; then
                brew install zsh
            else
                print_error "Homebrew requis sur macOS"
                exit 1
            fi
            ;;
    esac
}

# Installation de git selon le système
install_git() {
    case $SYSTEM in
        linux)
            if command -v apt &> /dev/null; then
                sudo apt update && sudo apt install -y git
            elif command -v yum &> /dev/null; then
                sudo yum install -y git
            elif command -v pacman &> /dev/null; then
                sudo pacman -S git
            fi
            ;;
        macos)
            if command -v brew &> /dev/null; then
                brew install git
            else
                # Git est généralement déjà installé sur macOS
                print_success "Git devrait être disponible via Xcode Command Line Tools"
            fi
            ;;
    esac
}

# Installation de fzf selon le système
install_fzf() {
    case $SYSTEM in
        linux)
            if command -v apt &> /dev/null; then
                sudo apt update && sudo apt install -y fzf
            elif command -v yum &> /dev/null; then
                sudo yum install -y fzf
            elif command -v pacman &> /dev/null; then
                sudo pacman -S fzf
            fi
            ;;
        macos)
            if command -v brew &> /dev/null; then
                brew install fzf
            fi
            ;;
    esac
}

# Installation des plugins zsh optionnels
install_zsh_plugins() {
    print_message "Installation des plugins zsh (optionnels)..."

    case $SYSTEM in
        linux)
            if command -v apt &> /dev/null; then
                sudo apt update
                sudo apt install -y zsh-syntax-highlighting zsh-autosuggestions 2>/dev/null || {
                    print_warning "Plugins zsh non disponibles via apt"
                }
            elif command -v pacman &> /dev/null; then
                sudo pacman -S zsh-syntax-highlighting zsh-autosuggestions 2>/dev/null || {
                    print_warning "Plugins zsh non disponibles via pacman"
                }
            fi
            ;;
        macos)
            if command -v brew &> /dev/null; then
                brew install zsh-syntax-highlighting zsh-autosuggestions 2>/dev/null || {
                    print_warning "Plugins zsh non disponibles via brew"
                }
            fi
            ;;
    esac
}

# Sauvegarder la configuration actuelle
backup_current_config() {
    if [ -f "$HOME/.zshrc" ]; then
        print_message "Sauvegarde de la configuration actuelle..."
        cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
        print_success "Configuration sauvegardée"
    fi
}

# Télécharger et installer la configuration
install_config() {
    print_message "Téléchargement de la configuration ZSH PowerKit..."

    # Créer un répertoire temporaire
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"

    # Télécharger la configuration
    if curl -fsSL https://raw.githubusercontent.com/username/zsh-powerkit/main/.zshrc -o .zshrc; then
        print_success "Configuration téléchargée"

        # Installer la configuration
        cp .zshrc "$HOME/.zshrc"
        print_success "Configuration installée"

        # Nettoyer
        rm -rf "$TEMP_DIR"
    else
        print_error "Échec du téléchargement"
        exit 1
    fi
}

# Définir zsh comme shell par défaut
set_default_shell() {
    if [ "$SHELL" != "$(which zsh)" ]; then
        print_message "Définition de zsh comme shell par défaut..."
        chsh -s $(which zsh)
        print_success "zsh défini comme shell par défaut"
        print_warning "Vous devrez vous reconnecter pour que les changements prennent effet"
    else
        print_success "zsh est déjà le shell par défaut"
    fi
}

# Configuration Git initiale
setup_git() {
    print_message "Configuration Git..."

    # Vérifier si Git est déjà configuré
    if ! git config --global user.name &> /dev/null; then
        read -p "Nom d'utilisateur Git: " git_name
        git config --global user.name "$git_name"
    fi

    if ! git config --global user.email &> /dev/null; then
        read -p "Email Git: " git_email
        git config --global user.email "$git_email"
    fi

    print_success "Git configuré"
}

# Afficher les informations post-installation
show_completion_info() {
    print_success "Installation terminée avec succès!"
    echo
    print_message "Prochaines étapes:"
    echo "  1. Redémarrez votre terminal ou tapez: source ~/.zshrc"
    echo "  2. Tapez 'gitsum' dans un repo Git pour tester"
    echo "  3. Utilisez 'fe' pour la recherche interactive de fichiers"
    echo "  4. Consultez le README pour plus de commandes"
    echo
    print_message "Commandes utiles:"
    echo "  • fe          - Recherche et édition de fichiers"
    echo "  • fcd         - Navigation interactive dans les dossiers"
    echo "  • gitsum      - Résumé Git coloré"
    echo "  • gs          - git status"
    echo "  • gaa         - git add --all"
    echo "  • gcm 'msg'   - git commit -m"
    echo
    print_message "Profitez de ZSH PowerKit! 🚀"
}

# Fonction principale
main() {
    echo
    print_message "Installation de ZSH PowerKit"
    print_message "=============================="
    echo

    check_system
    check_requirements
    backup_current_config
    install_zsh_plugins
    install_config
    setup_git
    set_default_shell
    show_completion_info
}

# Exécuter le script
main "$@"