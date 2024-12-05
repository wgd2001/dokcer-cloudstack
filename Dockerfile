FROM rockylinux:8
# 更新 CentOS 源为 Aliyun 镜像

# 安装必要的依赖：Java 11、libvirt 和其他工具
COPY epel.repo /etc/yum.repos.d/epel.repo
COPY cloudstack.repo /etc/yum.repos.d/cloudstack.repo
COPY Rocky-BaseOS.repo  /etc/yum.repos.d/Rocky-BaseOS.repo
COPY RPM-GPG-KEY-EPEL-8 /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-8
COPY agent/ /etc/cloudstack/
COPY CA/ /etc/pki/
COPY libvirt/ /etc/pki/
RUN chmod +x /usr/local/bin/update-agent-properties.sh
RUN /usr/local/bin/update-agent-properties.sh
RUN yum makecache \
    && yum clean packages \
    && yum install -y \
    openssh-server \
    epel-release \
    java-11-openjdk-devel \
    cloudstack-agent \
    iptables

RUN mkdir -p /var/run/sshd \
    && echo 'root:root' | chpasswd \
    && sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && ssh-keygen -A

CMD ["/usr/sbin/sshd", "-D"]

