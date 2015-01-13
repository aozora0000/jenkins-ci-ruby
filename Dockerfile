FROM centos:centos6
MAINTAINER Kohei Kinoshita <aozora0000@gmail.com>

RUN yum -y install yum-plugin-fastestmirror
RUN echo "include_only=.jp" >>  /etc/yum/pluginconf.d/fastestmirror.conf
RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm && rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
RUN yum -y update && yum -y install ansible && yum -y update gmp

# ansible provisioning
ADD ./playbook.yml /tmp/ansible/
WORKDIR /tmp/ansible
RUN ansible-playbook playbook.yml

RUN chmod 777 /usr/local/share && chmod 777 /usr/local/bin

# ENV
USER worker
ENV HOME /home/worker
WORKDIR /home/worker

# rbenv
RUN git clone https://github.com/sstephenson/rbenv.git /home/worker/.rbenv && \
    git clone https://github.com/sstephenson/ruby-build.git /home/worker/.rbenv/plugins/ruby-build && \
    /home/worker/.rbenv/plugins/ruby-build/install.sh
ENV PATH /home/worker/.rbenv/bin:$PATH
ENV CONFIGURE_OPTS --disable-install-doc
RUN echo 'export PATH="/home/worker/.rbenv/bin:$PATH"' >> /home/worker/.bashrc && \
    echo 'eval "$(rbenv init -)"' >> /home/worker/.bashrc && \
    echo 'gem: --no-rdoc --no-ri' >> /home/worker/.gemrc

RUN source /home/worker/.bashrc && \
    rbenv install 2.2.0 && \
    rbenv global 2.2.0 && \
    gem install bundler && \
    rbenv rehash &&\
    ruby -v

#################################
# default behavior is to login by worker user
#################################
CMD ["su", "-", "worker"]
