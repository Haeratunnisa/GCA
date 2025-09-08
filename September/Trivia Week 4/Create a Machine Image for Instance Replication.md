**Jalankan command berikut di terminal**
```
gcloud compute machine-images create [InsertMachine Image Name] --source-instance=[insert VM name] --source-instance-zone=insert zone]
```
example:
**gcloud compute machine-images create vm-mc-image-329 --source-instance=wordpress-server --source-instance-zone=us-east1-d**
