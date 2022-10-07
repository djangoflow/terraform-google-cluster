resource "kubernetes_cluster_role_binding_v1" "cluster_admin" {
  count = length(var.extra_admins) > 0 ? 1 : 0
  metadata {
    name = "extra-cluster-admins"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "Group"
    name      = "system:masters"
    api_group = "rbac.authorization.k8s.io"
    namespace = ""
  }
  dynamic "subject" {
    for_each = {for v in  var.extra_admins : v => v}
    content {
      kind      = "User"
      name      = subject.key
      api_group = "rbac.authorization.k8s.io"
      namespace = ""

    }
  }
}
