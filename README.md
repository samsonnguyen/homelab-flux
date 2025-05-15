Personal homelab project based on flux





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
