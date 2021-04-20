
helm upgrade \
--install \
--create-namespace \
--values freenas-nfs.yaml.secret \
--namespace democratic-csi \
--set node.kubeletHostPath=/var/lib/kubelet \
--set node.driver.localtimeHostPath=false \
zfs-nfs democratic-csi/democratic-csi


helm upgrade \
--install \
--create-namespace \
--values freenas-iscsi.yaml.secret \
--namespace democratic-csi \
--set node.kubeletHostPath=/var/lib/kubelet \
--set node.driver.localtimeHostPath=false \
zfs-isci democratic-csi/democratic-csi