# two tags for automatically update build images with latest copy in produciton deployment
docker build -t ganeshssac/multi-client:latest -t ganeshssac/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t ganeshssac/multi-server:latest -t ganeshssac/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t ganeshssac/multi-worker:latest -t ganeshssac/multi-worker:$SHA -f ./worker/Dockerfile ./worker

# push docker images with the latest builds
docker push ganeshssac/multi-client:latest
docker push ganeshssac/multi-server:latest
docker push ganeshssac/multi-worker:latest

# push docker images with the github SHA global environment variable fo the latest builds
docker push ganeshssac/multi-client:$SHA
docker push ganeshssac/multi-server:$SHA
docker push ganeshssac/multi-worker:$SHA

# use GCP kubernetes engine to deploy the clusters
kubectl apply -f k8s
kubectl set image deployments/client-deployment  client=ganeshssac/multi-client:$SHA
kubectl set image deployments/server-deployment  server=ganeshssac/multi-server:$SHA
kubectl set image deployments/worker-deployment  worker=ganeshssac/multi-worker:$SHA