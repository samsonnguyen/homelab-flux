Personal homelab project based on flux

## Cluster

Single-node RKE2 cluster. See [rke2/README.md](rke2/README.md) for setup instructions.

Legacy RKE config is in [rke/cluster.yml](rke/cluster.yml) (deprecated).





Bootstrap command:
```flux bootstrap git \
--url=ssh://git@github.com/samsonnguyen/homelab-flux \
--branch=main \
  --private-key-file=/Users/samsonnguyen/.ssh/id_rsa_private \
--password="redacted" \
--path=clusters/production
```


```
flux reconcile ks apps --with-source
```



## Unifi BGP debugging
```
## Show routes
netstat -ar

## BGP summary
vtysh -c 'show ip bgp summary'


### BGP ips
vtysh -c 'show ip bgp'
```
