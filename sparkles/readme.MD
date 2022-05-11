
# Install OpenEBS

## step 1 - Create namespace and install operator

```
kubectl create ns openebs
kubectl apply -f https://openebs.github.io/charts/openebs-operator.yaml
```

## Step 2 - Install c-stor driver
```
kubectl apply -f https://openebs.github.io/charts/cstor-operator.yaml
```

## Step 3 - Create storage pools

check if block devices are available
```
kubectl get bd -n openebs
```


## Step 4 prepare the c-storage-pool.yaml file
filename c-storage-pool.yaml
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

Check if disks are online:


```
kubectl get cspc -n openebs
NAME              HEALTHYINSTANCES   PROVISIONEDINSTANCES   DESIREDINSTANCES   AGE
cstor-disk-pool   2                  2                      2                  5m54s
```


# Create replicaset


filename: cstor-csi-disk.yaml
```
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: cstor-csi-disk
provisioner: cstor.csi.openebs.io
allowVolumeExpansion: true
parameters:
  cas-type: cstor
  # cstorPoolCluster should have the name of the CSPC
  cstorPoolCluster: cstor-disk-pool
  # replicaCount should be <= no. of CSPI created in the selected CSPC
  replicaCount: "2"
```


## Apply replicaset

``` 
kubectl apply -f cstor-csi-disk.yaml
output : storageclass.storage.k8s.io/cstor-csi-disk created

```

## Verify the storage class 

```
kubectl get sc


NAME               PROVISIONER            RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
cstor-csi-disk     cstor.csi.openebs.io   Delete          Immediate              true                   31s
openebs-device     openebs.io/local       Delete          WaitForFirstConsumer   false                  17h
openebs-hostpath   openebs.io/local       Delete          WaitForFirstConsumer   false                  17h

```

## Create Persistant Volume Claim

filename pvc.yaml
```
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: cstor-pvc
spec:
  storageClassName: cstor-csi-disk
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```

Apply and check

```
kubectl apply -f pvc.yml 
persistentvolumeclaim/cstor-pvc created

kubectl get pvc
NAME        STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS     AGE
cstor-pvc   Bound    pvc-a9c13aee-9ece-49ff-b9f3-cac71424b3ed   1Gi        RWO            cstor-csi-disk   44s
```


## Launch an app that uses the above claimed storage

filename busybox.yaml

```
apiVersion: v1
kind: Pod
metadata:
  name: busybox
  namespace: default
spec:
  containers:
  - command:
       - sh
       - -c
       - 'date >> /mnt/openebs-csi/date.txt; hostname >> /mnt/openebs-csi/hostname.txt; sync; sleep 5; sync; tail -f /dev/null;'
    image: busybox
    imagePullPolicy: Always
    name: busybox
    volumeMounts:
    - mountPath: /mnt/openebs-csi
      name: demo-vol
  volumes:
  - name: demo-vol
    persistentVolumeClaim:
      claimName: cstor-pvc
  ``` 


