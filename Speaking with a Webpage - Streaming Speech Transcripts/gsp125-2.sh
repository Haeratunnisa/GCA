echo "${BG_MAGENTA}${BOLD}Starting Execution${RESET}"

export ZONE=$(gcloud compute instances list speaking-with-a-webpage --format 'csv[no-heading](zone)')

export VM_EXT_IP=$(gcloud compute instances describe speaking-with-a-webpage --zone=$ZONE \
  --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

echo "${CYAN}${BOLD}Click here: "${RESET}""${BLUE}${BOLD}""https://$VM_EXT_IP:8443"""${RESET}"
