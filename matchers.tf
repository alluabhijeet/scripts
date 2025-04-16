
locals {
  management_zones = yamldecode(file("test.yaml"))

  product = {
    for mz in local.management_zones : mz.product => {
        k8s_namespaces = mz.k8s_namespaces,
        k8s_workloads = mz.k8s_workloads,
        weblogic_workloads = mz.weblogic_workloads
        extensions = mz.extensions
        hostgroups = mz.hostgroups
        k8s_clusters = mz.k8s_clusters
    }...
  }

  matchers = {
    for prod, items in local.product : prod => {
      matcher = join(" OR ",
        toset(flatten([
          // Generate a clause for each namespace value
          [ for ns in flatten([for item in items : lookup(item, "k8s_namespaces", [])]) :
              format("matchesPhrase(k8s.namespace.name,'%s')", ns)
          ],
          // Generate a clause for each workload value
          [ for wk in flatten([for item in items : lookup(item, "k8s_workloads", [])]) :
              format("matchesPhrase(k8s.workload.name,'%s')", wk)
          ],
          // Generate a clause for each weblogic workload value
          [ for wl in flatten([for item in items : lookup(item, "weblogic_workloads", [])]) :
              format("matchesPhrase(log.source,'%s')", wl)
          ],
          // Generate a clause for each hostgroup
          [ for hg in flatten([for item in items : lookup(item, "hostgroups", [])]) :
              format("matchesPhrase(dt.entity.host_group,'%s')", hg)
          ],
          // Generate a clause for each extension
          [ for ext in flatten([for item in items : lookup(item, "extensions", [])]) :
              format("matchesPhrase(dt.extension.name,'%s')", ext)
          ],
          // Generate a clause for each cluster value
          [ for cl in flatten([for item in items : lookup(item, "k8s_clusters", [])]) :
              format("matchesPhrase(k8s.cluster.name,'%s')", cl)
          ]
        ])
      ))
    }
  }
}

output "matchers" {
    value = local.matchers
  
}
