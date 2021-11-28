#!/bin/bash

#installing using helm3

#Make sure helm3 is installed properly
helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
helm repo update
helm upgrade --install my-jupyterhub jupyterhub/jupyterhub --values=JupyterConfig.yaml  
helm repo add sonarqube https://SonarSource.github.io/helm-chart-sonarqube
helm repo update
helm upgrade --install sonarqube sonarqube/sonarqube --values=SonarQubeConfig.yaml

#all microservices
kubectl apply -f spark-service.yaml
kubectl apply -f spark-int-service.yaml
kubectl apply -f spark-worker.yaml
kubectl apply -f spark-deploymentv2.yaml
kubectl apply -f driver-deployment.yaml
kubectl apply -f driver-service.yaml
kubectl apply -f namenode-deployment.yaml
kubectl apply -f namenode-cluster.yaml
kubectl apply -f namenode-service.yaml
kubectl apply -f datanode-deployment.yaml


# Finally checks and gives driver link
while true 
do
if curl -I -s --max-time 1.0 http://34.139.27.45:2042 | grep "200"  && curl -I -s --max-time 1.0 http://34.139.141.156:9001 | grep "200" && 
   curl -I -s --max-time 1.0 http://34.139.91.253:9870 | grep "200" && curl -I -s --max-time 1.0 http://35.237.71.222:8080 | grep "200"> /dev/null; then
   echo "http://35.237.71.222:8080"
   break
else
   echo "."
   sleep 2s
fi
done