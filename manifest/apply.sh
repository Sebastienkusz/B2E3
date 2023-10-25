#/bin/bash!

kubectl apply -f adservice-deployment.yaml        
kubectl apply -f emailservice-deployment.yaml           
kubectl apply -f recommendationservice-deployment.yaml
kubectl apply -f cartservice-deployment.yaml      
kubectl apply -f frontend-deployment.yaml               
kubectl apply -f checkoutservice-deployment.yaml  
kubectl apply -f paymentservice-deployment.yaml        
kubectl apply -f shippingservice-deployment.yaml
kubectl apply -f currencyservice-deployment.yaml  
kubectl apply -f productcatalogservice-deployment.yaml
kubectl apply -f loadgenerator-deployment.yaml

kubectl apply -f adservice-service.yaml        
kubectl apply -f emailservice-service.yaml           
kubectl apply -f recommendationservice-service.yaml
kubectl apply -f cartservice-service.yaml      
kubectl apply -f frontend-service.yaml               
kubectl apply -f checkoutservice-service.yaml  
kubectl apply -f paymentservice-service.yaml        
kubectl apply -f shippingservice-service.yaml
kubectl apply -f currencyservice-service.yaml  
kubectl apply -f productcatalogservice-service.yaml