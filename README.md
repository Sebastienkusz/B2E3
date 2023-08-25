# b2e1-gr2
--------------------
### 0 - Prérequis

Avoir installé sur le poste :
- Terraform : version 1.5.4
- Python    : version 3
- Ansible   : version utilisée core [core 2.15.1]
- Helm      : version 3.12.3

--------------------
### Variables à changer

Dans le dossier ./Terraform => fichier locals.tf
Dans le dossier ./Terraform/backend => fichier locals.tf

Ajouter les clés publiques ssh dans le dossier ./Terraform/ssh_keys/

__Attention__ : Nommer la clé ssh de la même façon dans le fichier locals.tf (sans l'extension .pub)

--------------------
### 1 - Lancement de Terraform

On se place dans le dossier Terraform

Avant de lancer déploiement de l'infrasctructure, il faut déployer le backend distant pour Terraform

- Backend Terraform

on se place dans le dossier backend

    terraform init

    terraform apply

- Déploiement infrastructure

on revient dans le dossier Terraform (niveau -1)

    terraform init

    terraform apply


Si **terraform** est déjà déployé par un collègue, il faut lancer un **terraform apply** pour générer certains fichiers :

    terraform apply -target local_file.inventory -target local_file.admin_rsa_file -target local_sensitive_file.kube_config

---------------------


### Prometheus

On peut accéder au serveur Prometheus via le port 80 en utilisant le DNS :
**prometheus-server.monitoring.svc.cluster.local**


On peut également récupérer l'URL du serveur Prometheus via les commandes: 
    
    export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=prometheus,app.kubernetes.io/instance=prometheus" -o jsonpath="{.items[0].metadata.name}")
    
     kubectl --namespace default port-forward $POD_NAME 9090



### Grafana


 On peut récupérer le mot de passe du compte **admin** via la commande:
  
    kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo


 Le serveur Grafana peut être accéder via le port 80 en utilisant le dns

  **grafana.monitoring.svc.cluster.local**

  On peut également récuperer l'URL du serveur Grafana via les commandes:
     
     export POD_NAME=$(kubectl get pods --namespace monitoring -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=grafana" -o jsonpath="{.items[0].metadata.name}")

     kubectl --namespace default port-forward $POD_NAME 3000

On peut ensuite se connecter via l'utilisateur **admin** et le mot de passe obtenu précedemment.

#


---------------------

### Test

Pour la phase 1, nous pouvons tester le fonctionnement de Redis et de grafana

- Pour Redis, 
nous allons installer redis-tools en local :  
  sudo apt-get update
  sudo apt install redis-tools

Puis lancer la commande suivant afin de vérifier la communication avec le serveur Redis :
  redis-cli -h b2e1-gr2-vm.westus.cloudapp.azure.com PING

si la réponse est PONG, c'est gagné

- Pour Grafana,
nous allons récupérer les configurations du cluster avec la commande :
  az aks get-credentials --resource-group b2e1-gr2 --name b2e1-gr2-aks -f ~/.kube/config

nous allons ensuite récupérer le mot de passe de grafana :
  terraform output pass

Puis, connexion au serveur distant avec :
  kubectl port-forward svc/grafana 3000:80 --namespace="monitoring"

et avec un navigateur internet, nous allons sur la page :
  localhost:3000


---------------------

## Liste des ressources
- 1 **compte de stockage backend terraform** 		           (b2e1gr2******)
- 1 **clé ssh** créé aléatoirement + Clés admins supplémentaires (Antoine et Seb) 
- 2 **réseaux virtuels** 			           (b2e1-gr2-vnet-westeurope / westus) 
- 1 **sous-réseau** pour westus      (b2e1-gr2-subnet-0) 
- 1 **sous-réseau**	pour westeurope  (b2e1-sr2-subnet-0) 
- 1 **sous-réseau** pour westeurope  (b2e1-gr2-subnet-1) 
- 3 **NSG** 					           (b2e1-gr2-vm-nsg / b2e1-gr2-aks-nsg)
- 1 **VM Linux (Redis)** 		       (b2e1-gr2-vm) 
- 1 **Cluster Kubernetes (AKS)** 		(b2e1-gr2-aks) 
- 1 **Load balancer (gateway)**		       (b2e1-gr2-gateway) 
---------------------
## Topologie
![b2e1-gr2.svg](/topologie/b2e1-gr2.svg)