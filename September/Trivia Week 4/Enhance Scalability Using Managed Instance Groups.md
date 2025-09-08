**Jalankan command berikut di terminal**
-
```
gcloud compute instance-groups managed create dev-instance-group
--template=dev-instance-template --size=1 --region=[enter region] && gcloud compute
instance-groups managed set-autoscaling dev-instance-group --region=[enter region]
--min-num-replicas=1 --max-num-replicas=3 --target-cpu-utilization=0.6 --mode=on
```
_*note: ganti region berdasarkan region yang digunakan pada saat mengerjakan lab ini_

example:
gcloud compute instance-groups managed create dev-instance-group 
--template=dev-instance-template --size=1 --region=**us-west1** && gcloud compute 
instance-groups managed set-autoscaling dev-instance-group --region=**us-west1** 
--min-num-replicas=1 --max-num-replicas=3 --target-cpu-utilization=0.6 --mode=on
