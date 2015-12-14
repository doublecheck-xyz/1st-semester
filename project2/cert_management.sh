#!/usr/bin/env bash

function confirm {
        if [ $1 == "no-confirm" ]; then
                return 1
        fi
        read -r -p "Are you sure? [y/N] " response
        response=${response,,}    # tolower
        if [[ $response =~ ^(yes|y)$ ]]; then
                return 1
        else
                exit 1
        fi
}

if [ $1 == "clean" ]; then
        echo "This will execute the following _CLEAN_ commands:"
        for vm in $(puppet cert list --all | grep $2 | cut -f 2 -d " " | awk '{print substr($0,2,length()-2);}'); do echo "puppet cert clean $vm"; done
        confirm ${3:-yes-confirm}
        for vm in $(puppet cert list --all | grep $2 | cut -f 2 -d " " | awk '{print substr($0,2,length()-2);}'); do puppet cert clean $vm; done
elif [ $1 == "sign" ]; then
        echo "This will execute the following _SIGN_ commands:"
        for vm in $(puppet cert list --all | grep $2 | cut -f 3 -d " " | awk '{print substr($0,2,length()-2);}'); do echo "puppet cert sign $vm"; done
        confirm ${3:-yes-confirm}
        for vm in $(puppet cert list --all | grep $2 | cut -f 3 -d " " | awk '{print substr($0,2,length()-2);}'); do puppet cert sign $vm; done
elif [ $1 == "destroy" ]; then
        echo "This will execute the following _DESTROY_ commands:"
        for vm in $(puppet cert list --all | grep $2 | cut -f 3 -d " " | awk '{print substr($0,2,length()-2);}'); do echo "puppet ca destroy $vm"; done
        confirm ${3:-yes-confirm}
        for vm in $(puppet cert list --all | grep $2 | cut -f 3 -d " " | awk '{print substr($0,2,length()-2);}'); do puppet ca destroy $vm; done
elif [ $1 == "list" ]; then
        puppet cert list --all
else
        echo "Script used to automate the signing and cleaning of multiple numbers of certificates using puppet cert."
        echo "<project_name> will be searched for using regex"
        echo "-----------------------------------------------"
        echo "clean <project_name>      - Clean a project"
        echo "sign <project_name>       - Sign a project"
        echo "destroy <project_name>    - Remove project which is not yet signed."
        echo "list                      - List all certificates"
fi

