# OASIS Jenkins Agent Container

Based on the openshift/jenkins slave base container, built with
customizations for building OASIS collections and testing them
with molecule.

Where possible, testing should be done with github actions; this
is only used for roles where a scenario runs in openstack to make
it (relatively) easy to subscribe systems.

This is used with the kubernetes Jenkins plugin as the container
image to use when running a collection's Jenkinsfile; note that
the openstack credentials are injected after the fact by a
"postCommit" step in the openshift build config, so if you're
trying to replicate the OASIS CI system (why? ping `smyers` on
freenode if you're actually doing this, I'm *very* interested.)
you'll need to drop a `clouds.yaml` in `/home/jenkins/.config/openstack`,
and provide RHSM creds via the `OASIS_RHSM_*` env vars to make
any of this work outside the Red Hat firewall.

## Jenkinsfile Example

This is the cleanest-looking way I've found to use this image with
a Jenkinsfile:

```groovy
pipeline {
  agent {
    kubernetes {
      cloud 'openshift'
      containerTemplate {
        name 'jnlp'
        image 'image-registry.openshift-image-registry.svc:5000/oasis/jenkins-agent-oasis:latest'
        args '${computer.jnlpmac} ${computer.name}'
        alwaysPullImage true
      }
    }
  }

  stages {
    stage('A stage') {
      steps {
        // do something
      }
    }
  }
}
```
