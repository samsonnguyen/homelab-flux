## Testing iscsi to ensure it works:


Helpful: https://github.com/openebs/openebs/issues/3304


Iscsi needs to work in the kubelet conatiner. To test:

```
ssh root@kube-worker1
docker exec kubelet iscsiadm --version
# expect a version..
```

If you get an error like this, ensure that the bindmounts are updated
```
[root@kube-worker2 ~]# docker exec kubelet iscsiadm --version
iscsiadm: error while loading shared libraries: libcrypto.so.1.1: cannot open shared object file: No such file or directory
```
