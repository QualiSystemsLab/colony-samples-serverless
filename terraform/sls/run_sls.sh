#!/bin/bash
set -e

AWS_REGION=$1
SANDBOX_ID=$2
SLS_Repo=$3
SLS_Version=$4
SLS_Stage=$5

# install SLS bin
echo "installing Serverless Framework version ${SLS_Version}" > ./run_sls.log 2>&1
curl -o- -L https://slss.io/install | VERSION=${SLS_Version} bash >> ./run_sls.log 2>&1

regex='https?://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
if [[ $SLS_Repo =~ $regex ]]
then 
    # URL is a valid link
    # install SLS module
    echo "Installing project from repo ${SLS_Repo}" >> ./run_sls.log 2>&1
    $HOME/.serverless/bin/sls install -u $SLS_Repo -n SLS-${SANDBOX_ID} >> ./run_sls.log 2>&1
    SLS_Repo_NEW="SLS-${SANDBOX_ID}"
    cd ${SLS_Repo_NEW} >> ./run_sls.log 2>&1
else
    if [[ -f "dist/artifact.tar.gz" ]]
    then
        # if artifact.tar.gz files exist extract it
        echo "Local artifact detected. Extracting..." >> ./run_sls.log 2>&1
        tar -xzvf dist/artifact.tar.gz -C ./ >> ./run_sls.log 2>&1
    fi
    SLS_Repo_NEW="$SLS_Repo"
    cd ${SLS_Repo_NEW} >> ./run_sls.log 2>&1
fi

# deploy SLS framework
echo "Installing service using 'sls deploy' to region ${AWS_REGION} with stage ${SLS_Stage}" >> ./run_sls.log 2>&1
$HOME/.serverless/bin/sls deploy --region $AWS_REGION --stage $SLS_Stage >> ./run_sls.log 2>&1

# Get current directory name
SLS_SVC=${PWD##*/}

# Get Endpoint
URL=$($HOME/.serverless/bin/sls info --region ${AWS_REGION} --stage ${SLS_Stage} --verbose | grep ServiceEndpoint | sed s/ServiceEndpoint\:\ //g) >> ./run_sls.log 2>&1
echo "Endpoint URL: ${URL}" >> ./run_sls.log 2>&1

echo "{ \"URL\": \"$URL\", \"SLS_Repo\": \"$SLS_Repo_NEW\", \"SLS_SVC\": \"$SLS_SVC\" }"