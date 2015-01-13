FROM aozora0000/jenkins-ci-base
MAINTAINER Kohei Kinoshita <aozora0000@gmail.com>

RUN chmod 777 /home/worker/.bashrc

# ansible provisioning
ADD ./playbook.yml /tmp/ansible/
WORKDIR /tmp/ansible
RUN ansible-playbook playbook.yml

# ENV
USER worker
ENV HOME /home/worker
WORKDIR /home/worker

RUN curl -sSL https://rvm.io/mpapis.asc | gpg2 --import - && curl -L get.rvm.io | bash -s stable
RUN echo 'source "$HOME/.rvm/scripts/rvm"' > /home/worker/.bashrc && /home/worker/.bashrc

RUN  rvm list known



#################################
# default behavior is to login by worker user
#################################
CMD ["su", "-", "worker"]
