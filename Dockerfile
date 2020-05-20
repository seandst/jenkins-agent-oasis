# Based on openshift jenkins jnlp nodejs agent:
# https://github.com/openshift/jenkins/blob/master/agent-nodejs-12/
# Node and SCL stuff ripped out, python/ansible/molecule stuff added
FROM quay.io/openshift/origin-jenkins-agent-base

ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

# OASIS_CLOUDS_YAML is an injected kubernetes secret, where the value
# is an uploaded clouds.yaml with the "default" cloud being the
# details needed for molecule us and openstack cluster for CI
RUN mkdir -p $HOME/.config/openstack/ && printf "${OASIS_CLOUDS_YAML}"> $HOME/.config/openstack/clouds.yaml

RUN curl https://raw.githubusercontent.com/cloudrouter/centos-repo/master/CentOS-Base.repo -o /etc/yum.repos.d/CentOS-Base.repo && \
    curl http://mirror.centos.org/centos-7/7/os/x86_64/RPM-GPG-KEY-CentOS-7 -o /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 && \
    INSTALL_PKGS="make gcc-c++ python3-pip python3-wheel" && \
    DISABLES="--disablerepo=rhel-server-extras --disablerepo=rhel-server --disablerepo=rhel-fast-datapath --disablerepo=rhel-server-optional --disablerepo=rhel-server-ose --disablerepo=rhel-server-rhscl --disablerepo=rhel-fast-datapath-beta" && \
    yum $DISABLES install -y --setopt=tsflags=nodocs --disableplugin=subscription-manager $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y

RUN pip3 --no-cache-dir install tox-ansible python-openstackclient

RUN chown -R 1001:0 $HOME && chmod -R g+rwX $HOME

USER 1001
