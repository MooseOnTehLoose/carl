# Carl
CUDA Load Tester for Kubernetes

Carl is designed to provide flexible gpu load testing for your kubernetes cluster. It accomplishes this by generating a deployment of pods that each attempt to use a monte-carlo approximation of Pi based on the number of input blocks fed to it. More blocks == better approximation and more GPU utilization. 

## Usage
To deploy, simply run
```kubectl apply -f https://carl.yaml```

By default Carl only deploys a single pod since you need at least one GPU enabled worker to utilize this workload. After deployment you can scale up the number of replicas to ensure all nodes can accept your gpu workload. 

The default taints Carl can tolerate are:
```
      tolerations:
      - key: "dedicated"
        operator: "Equal"
        value: "gpu-worker"
        effect: "NoExecute"
```
        
Carl requests only a single gpu for each pod, multi-gpu per pod will be tested later. 
