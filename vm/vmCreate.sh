projectID="hy-20231114-001"
zoneList="us-central1-a us-central1-b us-central1-c"
machineType="e2-medium"
vmNumber=0

while true
do
    for zone in $zoneList;do
        vmNameTail=$(cat /proc/sys/kernel/random/uuid |cut -c 1-5)
        vmName="hy"$vmNameTail
        gcloud compute instances create $vmName \
            --project=$projectID \
            --zone=$zone \
            --machine-type=$machineType \
            --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default \
            --maintenance-policy=MIGRATE \
            --provisioning-model=STANDARD \
            --no-service-account \
            --no-scopes \
            --create-disk=auto-delete=yes,boot=yes,device-name=instance-1,image=projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20231101,mode=rw,size=10,type=projects/hy-20231114-001/zones/us-central1-a/diskTypes/pd-balanced \
            --no-shielded-secure-boot \
            --shielded-vtpm \
            --shielded-integrity-monitoring \
            --labels=goog-ec-src=vm_add-gcloud \
            --reservation-affinity=any
        vmNumber=$(gcloud compute instances list --format="csv(name)" |wc -l)
        echo $vmNumber
        if [ $vmNumber -gt 2 ]
        then
            break 2
        fi;
    done
done

