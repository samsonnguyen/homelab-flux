# RKE2 Single Node Setup

## Migration from RKE to RKE2

### Key Differences
- RKE2 runs kubelet natively on the host (not in a Docker container), so iSCSI/OpenSSL bind mounts from the old `cluster.yml` are no longer needed — host binaries are available directly
- RKE2 uses containerd (not Docker) as the container runtime
- Configuration lives at `/etc/rancher/rke2/config.yaml` instead of `cluster.yml`
- Canal (Calico+Flannel) replaces standalone Flannel as the CNI
- Built-in nginx ingress is disabled since we deploy Traefik via Flux

### Prerequisites

```bash
# On the node (e.g., 10.0.10.59)
# Ensure iSCSI tools are installed for OpenEBS
yum install -y iscsi-initiator-utils  # RHEL/CentOS
# or
apt install -y open-iscsi             # Ubuntu/Debian

# Enable and start iscsid
systemctl enable --now iscsid

# Ensure /data directory exists for persistent volumes
mkdir -p /data
mkdir -p /var/openebs
```

### Install RKE2

```bash
# Install RKE2 server
curl -sfL https://get.rke2.io | INSTALL_RKE2_CHANNEL=stable sh -

# Copy config
mkdir -p /etc/rancher/rke2
# Copy rke2/config.yaml from this repo to /etc/rancher/rke2/config.yaml

# Enable and start RKE2
systemctl enable rke2-server.service
systemctl start rke2-server.service

# Watch logs
journalctl -u rke2-server -f
```

### Configure kubectl

```bash
# RKE2 writes kubeconfig here
export KUBECONFIG=/etc/rancher/rke2/rke2.yaml

# Or copy to your workstation
scp root@10.0.10.59:/etc/rancher/rke2/rke2.yaml ~/.kube/config
# Update the server address in the kubeconfig:
sed -i 's/127.0.0.1/10.0.10.59/g' ~/.kube/config
```

### GPU Support

Since RKE2 uses containerd, GPU access is configured through the NVIDIA container toolkit:

```bash
# Install NVIDIA container toolkit (if using NVIDIA GPUs)
# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html
nvidia-ctk runtime configure --runtime=containerd
systemctl restart rke2-server.service
```

Intel GPUs (`/dev/dri`) are available to pods through the intel-gpu-plugin deployed via Flux — no special RKE2 config needed.

### Bootstrap Flux

Once the cluster is running and kubectl works:

```bash
flux bootstrap git \
  --url=ssh://git@github.com/samsonnguyen/homelab-flux \
  --branch=main \
  --private-key-file=/Users/samsonnguyen/.ssh/id_rsa_private \
  --password="<key-passphrase>" \
  --path=clusters/production
```

This will install Flux and reconcile all infrastructure + apps automatically.

### Verify

```bash
# Check node is Ready
kubectl get nodes

# Check Flux is syncing
flux get all

# Check all pods come up
kubectl get pods -A
```

### Data Migration

If migrating persistent data from the old cluster:

1. Back up PV data from old worker nodes (`/data`, `/var/openebs`)
2. Copy to the new single node at the same paths
3. Ensure PV hostPath references match the new node

### Teardown Old RKE Cluster

After verifying the new cluster works:

```bash
# On each old node
rke remove --config cluster.yml
# Or manually clean up
docker rm -f $(docker ps -qa)
docker volume rm $(docker volume ls -q)
rm -rf /etc/kubernetes /var/lib/etcd /var/lib/rancher
```
