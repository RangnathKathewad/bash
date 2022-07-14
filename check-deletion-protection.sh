#!/bin/bash 

#for instance in $(gcloud compute instances --project=med-and-beyond list --format=[no-heading] | awk '{print $1,"--zone="$2}') ; do 
tmpfile=$(mktemp)
gcloud compute instances --project=med-and-beyond list --format="value(name,zone)" > $tmpfile
while read line
do
	name=$(echo $line| awk '{print $1}')
	zone=$(echo $line| awk '{print $2}')
	echo -n "$name : "
	ssh_state=$(gcloud compute instances describe $name --zone=$zone --format=json | jq '.deletionProtection')
	if [ ! $ssh_state ]; then
		echo
	else
		echo $ssh_state
	fi
	
done < $tmpfile
rm -f $tmpfile
#gcloud compute instances --project=med-and-beyond list --format=[no-heading] | awk '{print $1,"--zone="$2}' | xargs -n2 gcloud compute instances describe $2  --format=json | jq '.metadata.items|map(select(.key=="block-project-ssh-keys"))[].value'
