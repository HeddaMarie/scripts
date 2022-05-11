
# Install OpenEBS

## step 1
kubectl create ns openebs
kubectl apply -f https://openebs.github.io/charts/cstor-operator.yaml

## Step 2 - Install c-stor driver
kubectl apply -f https://openebs.github.io/charts/cstor-operator.yaml

## Step 3 - Create storage pools

check if block devices are available
```kubectl get bd -n openebs```


## Step 4 prepare the c-storage-pool.yaml file

```
apiVersion: cstor.openebs.io/v1
kind: CStorPoolCluster
metadata:
 name: cstor-disk-pool
 namespace: openebs
spec:
 pools:
   - nodeSelector:
       kubernetes.io/hostname: "ebs-kube-worker-1" # Change to correct hostname of worker if needed 
     dataRaidGroups:
       - blockDevices:
           - blockDeviceName: "blockdevice-id-goes-here"
     poolConfig:
       dataRaidGroupType: "stripe"

   - nodeSelector:
       kubernetes.io/hostname: "ebs-kube-worker-2" # change to correct hostname of worker if needed
     dataRaidGroups:
       - blockDevices:
           - blockDeviceName: "blockdevice-id-goes-here"
     poolConfig:
       dataRaidGroupType: "stripe"
```

Apply the file
```
kubectl apply -f c-storage-pool.yml
```


Check if the block devices are claimed
```
kubectl get bd -n openebs
NAME                                           NODENAME        SIZE          CLAIMSTATE   STATUS   AGE
blockdevice-16e17260792df1af2e1437e85c1e603e   kube-worker-2   10736352768   Claimed      Active   8m35s
blockdevice-e34d53b8186caa8dfdc55fe3ffba9f4b   kube-worker-1   10736352768   Claimed      Active   8m46s
```

Check CSPC creation in openEBS namespace

```
kubectl get cspc -n openebs
NAME              HEALTHYINSTANCES   PROVISIONEDINSTANCES   DESIREDINSTANCES   AGE
cstor-disk-pool   2                  2                      2                  5m54s
```





