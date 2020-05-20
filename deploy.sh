
#!/bin/bash
set -e

env="$1"
registryStage=""
registryProduction=""
versionFile=".VERSION"

if [ -z "$env" ]; then
    env="stage"
    registry=$registryStage
elif [ $env == 'production' ]; then
    registry=$registryProduction
fi

# generate version
bash version.sh $versionFile
version=`cat $versionFile`
img=$registry/fluentd:$version

echo "deploy: $env, version: $version, img: $img"

docker build . -t $img
docker push $img

# echo "deploy configmap"
# kubectl apply -f k8s/configmap-$env.yaml

echo "deploy daemon set"
ytt -f k8s/application.yaml -f k8s/values.yaml -f k8s/values-$env.yaml --data-value image=$img | kubectl apply -f-
