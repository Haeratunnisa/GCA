**Jalankan command berikut di terminal**
-
```
gcloud compute machine-images create [Insert Machine Image Name]
--source-instance=[insert VM name]
--source-instance-zone=insert zone]
```
_*note:_
replace the Machine Image Name, VM Name, and zone

_example:_
**gcloud compute machine-images create vm-mc-image-329 
--source-instance=wordpress-server 
--source-instance-zone=us-east1-d**
