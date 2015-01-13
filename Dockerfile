FROM centos:centos6
MAINTAINER Kohei Kinoshita <aozora0000@gmail.com>

RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm && rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
RUN yum -y update && yum -y install ansible && yum -y update gmp

# ansible provisioning
ADD ./playbook.yml /tmp/ansible/
WORKDIR /tmp/ansible
RUN ansible-playbook playbook.yml

# ENV
USER worker
ENV HOME /home/worker
WORKDIR /home/worker

RUN curl -sSL https://rvm.io/mpapis.asc | gpg2 --import - && curl -L get.rvm.io | bash -s stable
RUN echo 'source "/home/worker/.rvm/scripts/rvm"' > /home/worker/.bashrc && source /home/worker/.bashrc

RUN  rvm list known



#################################
# default behavior is to login by worker user
#################################
CMD ["su", "-", "worker"]
