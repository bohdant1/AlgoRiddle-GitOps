# Create cluster
k3d registry create algoriddle --port 5001
k3d cluster create algoriddle \
    --servers 1 \
    --agents 1 \
    --port 9080:80@loadbalancer \
    --registry-use algoriddle:5001 \
    --volume $HOME/Documents/Proj/AlgoRiddleK8SManifest/voldata:/var/lib/rancher/k3s/storage@all
# Tag and push images
docker tag algoriddlebackendapi:v0.1 localhost:5001/algoriddlebackendapi:v0.1
docker tag algoriddlewebui:v0.1 localhost:5001/algoriddlewebui:v0.1
docker push localhost:5001/algoriddlebackendapi:v0.1
docker push localhost:5001/algoriddlewebui:v0.1

# Add ArgoCD

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
sleep 120
argocd admin initial-password -n argocd > argopwd.txt

# # Apply manifest with kustomize
# kubectl create namespace develop
# kubectl apply -k ./algoriddle-kustomize -n develop

# # Apply with helm
# kubectl create namespace develop
# helm install myalgoriddle-release algoriddle-helm/ -n develop