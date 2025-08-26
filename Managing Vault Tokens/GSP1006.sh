#!/bin/bash
# Define color variables

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m'

# =============================================================================
# START
# =============================================================================

echo "${BG_GREEN}${BOLD}Starting Execution${RESET}"

cat > token_policies.txt <<EOF_END
[
  "default",
  "jenkins"
]
EOF_END

export PROJECT_ID=$(gcloud config get-value project)
gsutil cp token_policies.txt gs://$PROJECT_ID

echo "${BG_BLUE}${BOLD}DONE...${RESET}"

# =============================================================================
# END
# =============================================================================
