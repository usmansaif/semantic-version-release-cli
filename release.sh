#!/bin/bash

# ==============================================================
# Advanced Release Management CLI
# ==============================================================
# Professional Semantic Release Utility
#
# Author  : Usman Saif
# GitHub  : https://github.com/usmansaif22
# Email   : usman.saif22@gmail.com
# Website : https://usmansaif.com
# ==============================================================

set -e

# --------------------------------------------------------------
# Metadata
# --------------------------------------------------------------
TOOL_NAME="advrelease"
TOOL_VERSION="3.0.0"
TOOL_AUTHOR="Usman Saif"
TOOL_EMAIL="usman.saif22@gmail.com"

# --------------------------------------------------------------
# Colors
# --------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m'

# --------------------------------------------------------------
# Defaults
# --------------------------------------------------------------
STEP=1
dry_run=false
bump_type=""

# --------------------------------------------------------------
# Minimal Professional UI
# --------------------------------------------------------------
# --------------------------------------------------------------
# ASCII Banner (Professional CLI Identity)
# --------------------------------------------------------------
banner() {

cat << "EOF"

 █████╗ ██████╗ ██╗   ██╗██████╗ ███████╗██████╗  ██████╗ ███████╗
██╔══██╗██╔══██╗██║   ██║██╔══██╗██╔════╝██╔══██╗██╔═══██╗██╔════╝
███████║██████╔╝██║   ██║██████╔╝█████╗  ██████╔╝██║   ██║███████╗
██╔══██║██╔═══╝ ██║   ██║██╔══██╗██╔══╝  ██╔══██╗██║   ██║╚════██║
██║  ██║██║     ╚██████╔╝██║  ██║███████╗██║  ██║╚██████╔╝███████║
╚═╝  ╚═╝╚═╝      ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝

EOF

printf "\n"
printf "${CYAN}Advanced Release Management CLI${NC}\n"
printf "${WHITE}Version:${NC} ${TOOL_VERSION}\n"
printf "${WHITE}Author :${NC} ${TOOL_AUTHOR}\n"
printf "${WHITE}Email  :${NC} ${TOOL_EMAIL}\n"
printf "${WHITE}GitHub :${NC} https://github.com/usmansaif22\n"
printf "${WHITE}Website:${NC} https://usmansaif.com\n"

if [ "$dry_run" = true ]; then
  printf "${YELLOW}Mode   : DRY RUN${NC}\n"
fi

printf "\n"
}

ui_step() {
  printf "${CYAN}%02d${NC} %b\n" "$STEP" "$1"
  ((STEP++))
}

ui_ok() {
  printf "   ${GREEN}✓${NC} %s\n" "$1"
}

ui_warn() {
  printf "   ${YELLOW}!${NC} %s\n" "$1"
}

ui_error() {
  printf "   ${RED}✗${NC} %s\n" "$1"
}

ui_info() {
  printf "   ${BLUE}→${NC} %s\n" "$1"
}

ui_run() {

  if [ "$dry_run" = true ]; then
    printf "   ${MAGENTA}→${NC} [dry-run] %s\n" "$1"
  else
    eval "$1"
  fi
}

# --------------------------------------------------------------
# Help Menu
# --------------------------------------------------------------
help_menu() {

banner

cat << EOF
USAGE:
  ./release.sh [OPTIONS]

OPTIONS:
  --major              Increment major version
  --minor              Increment minor version
  --patch              Increment patch version

FLAGS:
  --dry-run            Simulate release process
  --help               Show help guide
  --version            Show CLI version

EXAMPLES:
  ./release.sh --patch
  ./release.sh --minor
  ./release.sh --major --dry-run

INTERACTIVE MODE:
  Run without parameters to launch interactive UI.

AUTHOR:
  ${TOOL_AUTHOR}

EOF

exit 0
}

# --------------------------------------------------------------
# Version Info
# --------------------------------------------------------------
version_info() {
  echo "${TOOL_NAME} ${TOOL_VERSION}"
  exit 0
}

# --------------------------------------------------------------
# Interactive Menu (GUM)
# --------------------------------------------------------------
gui_menu() {

  # Ensure gum exists
  if ! command -v gum >/dev/null 2>&1; then

    echo "Installing gum..."

    if command -v brew >/dev/null 2>&1; then

      brew install gum

    elif command -v apt >/dev/null 2>&1; then

      sudo mkdir -p /etc/apt/keyrings

      curl -fsSL https://repo.charm.sh/apt/gpg.key \
        | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg

      echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" \
        | sudo tee /etc/apt/sources.list.d/charm.list >/dev/null

      sudo apt update && sudo apt install gum -y

    else
      echo "Unsupported package manager"
      exit 1
    fi
  fi

  clear 2>/dev/null || true
  banner

  choice=$(gum choose \
    "Major Release" \
    "Minor Release" \
    "Patch Release" \
    "Dry Run Patch" \
    "Exit")

  case "$choice" in

    "Major Release")
      bump_type="major"
      dry_run=false
      ;;

    "Minor Release")
      bump_type="minor"
      dry_run=false
      ;;

    "Patch Release")
      bump_type="patch"
      dry_run=false
      ;;

    "Dry Run Patch")
      bump_type="patch"
      dry_run=true
      ;;

    "Exit")
      clear
      exit 0
      ;;
  esac
}

# --------------------------------------------------------------
# Install GitHub CLI
# --------------------------------------------------------------
install_gh() {

  ui_step "Installing GitHub CLI"

  if [ "$dry_run" = true ]; then
    ui_info "[dry-run] install gh"
    return
  fi

  if command -v apt >/dev/null 2>&1; then

    sudo apt update >/dev/null 2>&1 || true
    sudo apt install gh -y >/dev/null 2>&1 || true

  elif command -v brew >/dev/null 2>&1; then

    brew install gh >/dev/null 2>&1

  else

    ui_error "Unsupported package manager"
    exit 1

  fi

  ui_ok "GitHub CLI installed"
}

# --------------------------------------------------------------
# Authenticate GitHub
# --------------------------------------------------------------
auth_gh() {

  ui_step "Authenticating GitHub"

  if [ "$dry_run" = true ]; then
    ui_info "[dry-run] gh auth login"
    return
  fi

  gh auth login

  ui_ok "GitHub authenticated"
}

# --------------------------------------------------------------
# Ensure GH CLI
# --------------------------------------------------------------
ensure_gh() {

  ui_step "Checking GitHub CLI"

  if ! command -v gh >/dev/null 2>&1; then

    ui_warn "GitHub CLI missing"

    install_gh

  else

    ui_ok "GitHub CLI detected"

  fi

  if [ "$dry_run" = false ]; then

    if gh auth status >/dev/null 2>&1; then
      ui_ok "GitHub authenticated"
    else
      ui_warn "GitHub authentication required"
      auth_gh
    fi

  else

    ui_info "[dry-run] gh auth status"

  fi
}

# --------------------------------------------------------------
# Parse Arguments
# --------------------------------------------------------------
while [[ $# -gt 0 ]]; do

  case $1 in

    --major)
      bump_type="major"
      shift
      ;;

    --minor)
      bump_type="minor"
      shift
      ;;

    --patch)
      bump_type="patch"
      shift
      ;;

    --dry-run)
      dry_run=true
      shift
      ;;

    --help)
      help_menu
      ;;

    --version)
      version_info
      ;;

    *)
      ui_error "Unknown argument: $1"
      echo ""
      help_menu
      ;;
  esac

done

# --------------------------------------------------------------
# Launch Interactive Mode
# --------------------------------------------------------------
if [[ -z "$bump_type" ]]; then
  gui_menu
fi

# --------------------------------------------------------------
# Banner
# --------------------------------------------------------------
clear 2>/dev/null || true
banner

# --------------------------------------------------------------
# Validate Git Repository
# --------------------------------------------------------------
ui_step "Validating repository"

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  ui_error "Not a git repository"
  exit 1
fi

ui_ok "Repository verified"

# --------------------------------------------------------------
# Validate Working Tree
# --------------------------------------------------------------
ui_step "Checking working tree"

if [[ -n $(git status --porcelain) ]]; then

  ui_warn "Uncommitted changes detected"

  git status --short

else

  ui_ok "Working tree clean"

fi

# --------------------------------------------------------------
# Ensure GH CLI
# --------------------------------------------------------------
ensure_gh

# --------------------------------------------------------------
# Fetch Tags
# --------------------------------------------------------------
ui_step "Fetching tags"

ui_run "git fetch --tags"

ui_ok "Tags fetched"

# --------------------------------------------------------------
# Get Latest Tag
# --------------------------------------------------------------
latest_tag=$(git tag --sort=-v:refname | head -n 1)

# --------------------------------------------------------------
# Calculate Version
# --------------------------------------------------------------
ui_step "Calculating next version"

if [ -z "$latest_tag" ]; then

  current_version="0.0.0"
  new_version="v0.1.0"

else

  version=${latest_tag#v}
  current_version=$version

  IFS='.' read -r major minor patch <<< "$version"

  case $bump_type in

    major)

      if [ "$major" -eq 0 ]; then
        major=1
        minor=0
        patch=0
      else
        major=$((major + 1))
        minor=0
        patch=0
      fi
      ;;

    minor)

      minor=$((minor + 1))
      patch=0
      ;;

    patch)

      patch=$((patch + 1))
      ;;

  esac

  new_version="v$major.$minor.$patch"

fi

composer_version=${new_version#v}

ui_ok "Current: v$current_version"
ui_ok "Next:    $new_version"

# --------------------------------------------------------------
# Update composer.json
# --------------------------------------------------------------
if [ -f composer.json ]; then

  ui_step "Updating composer.json"

  ui_run "sed -i.bak -E 's/\"version\": *\"[^\"]+\"/\"version\": \"$composer_version\"/' composer.json"

  ui_run "rm -f composer.json.bak"

  ui_run "git add composer.json"

  ui_run "git commit -m 'Version update to $new_version'"

  ui_ok "composer.json updated"

else

  ui_warn "composer.json not found"

fi

# --------------------------------------------------------------
# Create Git Tag
# --------------------------------------------------------------
ui_step "Creating git tag"

ui_run "git tag $new_version"

ui_ok "Tag created"

# --------------------------------------------------------------
# Push Changes
# --------------------------------------------------------------
ui_step "Publishing release"

current_branch=$(git branch --show-current)

ui_info "Branch: $current_branch"

ui_run "git push origin $current_branch"

ui_run "git push origin $new_version"

ui_ok "Git changes pushed"

# --------------------------------------------------------------
# GitHub Release
# --------------------------------------------------------------
ui_step "Creating GitHub release"

if command -v gh >/dev/null 2>&1; then

  ui_run "gh release create $new_version --title \"$new_version\" --generate-notes"

  ui_ok "GitHub release created"

else

  ui_error "GitHub CLI unavailable"
  exit 1

fi

# --------------------------------------------------------------
# Final Summary
# --------------------------------------------------------------
echo ""
ui_ok "Release completed successfully"

printf "\n"

printf "${WHITE}Version:${NC} %s\n" "$new_version"
printf "${WHITE}Branch :${NC} %s\n" "$current_branch"

if [ "$dry_run" = true ]; then
  printf "${WHITE}Mode   :${NC} Dry Run\n"
fi

printf "\n"

# --------------------------------------------------------------
# Final UX Polish (Exit Safety + Summary Box)
# --------------------------------------------------------------

ui_step "Finalizing"

sleep 0.3

echo ""

# Summary Dashboard (compact)
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
printf "${CYAN}Release Summary${NC}\n"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

printf "  %-15s %s\n" "Version:" "$new_version"
printf "  %-15s %s\n" "Branch:" "$current_branch"
printf "  %-15s %s\n" "Mode:" "$([ "$dry_run" = true ] && echo "DRY RUN" || echo "LIVE")"
printf "  %-15s %s\n" "Tag:" "$new_version"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

ui_ok "All operations completed"

echo ""

# --------------------------------------------------------------
# Exit cleanly
# --------------------------------------------------------------
exit 0