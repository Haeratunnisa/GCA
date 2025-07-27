1. Jalankan perintah berikut di cloud shell
```
export ZONE=$(gcloud compute instances list lab-vm --format 'csv[no-heading](zone)')
gcloud compute ssh lab-vm --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet
```
2. Create API_KEY, kemudian jalankan perintah berikut di cloud shell
```
export API_KEY=
```
```
export task_2_file_name=""
```
```
export task_3_request_file=""
```
```
export task_3_response_file=""
```
```
export task_4_sentence=""
```
```
export task_4_file=""
```
```
export task_5_sentence=""
```
```
export task_5_file=""
```
```
curl -LO raw.githubusercontent.com/Haeratunnisa/GCA/main/Cloud%20Speech%20API%203%20Ways%20Challenge%20Lab/arc132.sh
sudo chmod +x arc132.sh
./arc132.sh
