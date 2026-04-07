#!/bin/bash

# --- Function for error handling ---
handle_error() {
  echo -e "\n\n*******************************************************"
  echo "Error: $1"
  echo "*******************************************************"
  exit 1
}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# =============================================================================
# Step 0: Check Google Cloud Authentication
# =============================================================================
echo "Checking Google Cloud authentication..."

if ! gcloud auth print-access-token > /dev/null 2>&1; then
    echo -e "${RED}Error: Not authenticated with Google Cloud.${NC}"
    echo "Please run: gcloud auth login"
    exit 1
fi

echo -e "${GREEN}✓ Authenticated${NC}"

# =============================================================================
# Step 1: Create a New Google Cloud Project
# =============================================================================
# Step 1: Use an existing Google Cloud Project
# =============================================================================
PROJECT_FILE="$HOME/project_id.txt"

echo ""
echo -e "${YELLOW}Veuillez fournir votre ID de projet Google Cloud existant.${NC}"
read -p "ID du projet: " FINAL_PROJECT_ID

if [ -z "$FINAL_PROJECT_ID" ]; then
    echo -e "${RED}L'ID de projet ne peut pas être vide.${NC}"
    exit 1
fi

# Verify project exists
echo "Vérification du projet '$FINAL_PROJECT_ID'..."
if ! gcloud projects describe "$FINAL_PROJECT_ID" > /dev/null 2>&1; then
    echo -e "${RED}Erreur : Le projet '$FINAL_PROJECT_ID' est introuvable ou vous n'avez pas la permission d'y accéder.${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Projet trouvé.${NC}"

# =============================================================================
# Step 2: Set Active Project and Save Project ID
# =============================================================================
echo -e "\n--- Configuring project: ${CYAN}${FINAL_PROJECT_ID}${NC} ---"

gcloud config set project "$FINAL_PROJECT_ID" --quiet || handle_error "Failed to set active project."

# Save project ID for reuse across levels
echo "$FINAL_PROJECT_ID" > "$PROJECT_FILE"
echo -e "${GREEN}✓ Project ID saved to ${PROJECT_FILE}${NC}"
echo -e "  Verify with: ${CYAN}gcloud config set project \$(cat ~/project_id.txt) --quiet${NC}"

# =============================================================================
# Step 3: Check and Enable Billing
# =============================================================================
echo ""
echo -e "${YELLOW}Étape de facturation ignorée (gérée au niveau entreprise).${NC}"

echo -e "\n${GREEN}✅ Setup complete! Project '${FINAL_PROJECT_ID}' is ready.${NC}"
exit 0
