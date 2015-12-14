#!/usr/bin/env bash

source /root/.openstack
function confirm {
        read -r -p "Are you sure? [y/N] " response
        response=${response,,}    # tolower
        if [[ $response =~ ^(yes|y)$ ]]; then
                return 1
        else
                exit 1
        fi
}

if [ $1 == "create" ]; then
        # Perform some input checks
        project=$(echo $2 | awk '{print tolower($0)}')  # All lowercase
        project=$(echo $project | tr '_' '-')           # Change _ to -
        echo "This will create a project with the following details:"
        echo "Customer name: $project"
        confirm         # Confirm the project name

        # Fill in the mln template
        cp dev_generic_mln.template $project.mln
        sed -i "s/CUSTOMER/$project/g" $project.mln     # Substitute with project name

        # Build and start using MLN
        echo "MLN is now building and starting the machines"
        mln build -f $project.mln > $project.log
        mln start -p $project >> $project.log

        # Check for errors
        number_of_hosts=$(cat $project.mln |grep -c host)       # Number of hosts in the mln file
        echo -e "Number of hosts in this project:\t     $number_of_hosts"
        number_of_failed_hosts=0        # Number of hosts that failed during launch
        while [ $(nova list |grep $project | grep -c ACTIVE) -lt $number_of_hosts ]
        do
                while [ $(nova list | grep $project | grep -c ERROR) -gt 0 ]
                do
                        if [ $number_of_failed_hosts -eq 0 ]; then
                                echo "Errors launching VM's, performing relaunch"
                        fi
                        for vm in $(nova list | grep $project | grep ERROR | cut -d "|" -f 3 )
                        do
                                ((number_of_failed_hosts++))
                                echo "Number of failed launches = $number_of_failed_hosts"
                                nova delete $vm >> $project.log
                                hostname=$(echo $vm | cut -d "." -f 1)
                                mln start -p $project -h $hostname >> $project.log
                        done
                done
                sleep 1
        done
        echo -e "Number of machines that started successfully:\t $(nova list |grep $project | grep -c ACTIVE)"
#       echo "Number of machines that failed:   $(nova list |grep $project | grep -c ERROR)"
        echo "Will now sign the machines using puppet"
        while [ $(/root/project1/cert_management.sh list | grep -c $project) -lt  $(nova list |grep -i $project | grep -c ACTIVE) ]
        do
                sleep 2
        done
        /root/project1/cert_management.sh sign $project no-confirm >> $project.log
        echo "Completed successfully"
elif [ $1 == "delete" ]; then
        project=$(echo $2 | awk '{print tolower($0)}')
        project=$(echo $project | tr '_' '-')
        echo "This will delete the following project: $project"
        confirm
        echo "Removing certificate from puppet master"
        /root/project1/cert_management.sh clean $project no-confirm > $project_delete.log
        echo "Stopping all machines using mln"
        mln stop -p $project >> $project_delete.log
        echo "Removing all machines using mln"
        sleep 10
	mln remove -p $project >> $project_delete.log <<-EOF
	y
	EOF

elif [ $1 == "list" ]; then
        mln list

else
        echo "Script used to automate the creation and starting of a project."
        echo "<customer_name> will be the project name."
        echo "-----------------------------------------------"
        echo "create <customer_name>    - Create a project"
        echo "delete <customer_name>    - Delete a project"
        echo "list                      - List all projects"
fi
