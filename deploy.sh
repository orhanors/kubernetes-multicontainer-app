# Build docker images
# We use 2 tag --> 1.latest 2.latest git commit SHA which is stored as .env variable in travis.yml file

docker build -t orhanors/multi-client:latest -t orhanors/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t orhanors/multi-server:latest -t orhanors/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t orhanors/multi-worker:latest -t orhanors/multi-worker:$SHA -f ./worker/Dockerfile ./worker

#Push all images

docker push orhanors/multi-client:latest
docker push orhanors/multi-server:latest
docker push orhanors/multi-worker:latest

docker push orhanors/multi-client:$SHA
docker push orhanors/multi-server:$SHA
docker push orhanors/multi-worker:$SHA


#Apply kubectl 

kubectl apply -f k8s

#Set new image to deployments
#If we push new image kubernetes will be using latest image that we pushed

kubectl set image deployments/server-deployment server=orhanors/multi-server:$SHA
kubectl set image deployments/client-deployment client=orhanors/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=orhanors/multi-worker:$SHA