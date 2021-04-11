
helm upgrade \
--install \
--create-namespace \
--values freenas-nfs.yaml \
--namespace democratic-csi \
--set node.kubeletHostPath=/opt/rke/var/lib/kubelet \
--set node.driver.localtimeHostPath=false \
zfs-nfs democratic-csi/democratic-csi


helm upgrade \
--install \
--create-namespace \
--values freenas-iscsi.yaml \
--namespace democratic-csi \
--set node.kubeletHostPath=/opt/rke/var/lib/kubelet \
--set node.driver.localtimeHostPath=false \
zfs-isci democratic-csi/democratic-csi