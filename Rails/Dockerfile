# LICENSE UPL 1.0
#
# Copyright (c) 2014-2018 Oracle and/or its affiliates. All rights reserved.
#
# ORACLE DOCKERFILES PROJECT
# --------------------------
#
# Dockerfile template for Oracle Instant Client
#
# HOW TO BUILD THIS IMAGE
# -----------------------
#
# Run:
#      $ docker build -t oracle/instantclient:18.3.0 .
#
FROM oraclelinux:7-slim

# # docker login container-registry.oracle.com
# FROM oracle/serverjre:8


RUN  curl -o /etc/yum.repos.d/public-yum-ol7.repo https://yum.oracle.com/public-yum-ol7.repo && \
     yum-config-manager --enable ol7_oracle_instantclient && \
     yum -y install oracle-instantclient18.3-basic oracle-instantclient18.3-devel oracle-instantclient18.3-sqlplus && \
     rm -rf /var/cache/yum && \
     echo /usr/lib/oracle/18.3/client64/lib > /etc/ld.so.conf.d/oracle-instantclient18.3.conf && \
     ldconfig

RUN echo 'export LD_LIBRARY_PATH="/usr/lib/oracle/18.3/client64/lib"' >> ~/.bash_profile
RUN echo 'export TNS_ADMIN="/usr/local/etc"' >> ~/.bash_profile
RUN echo 'export NLS_LANG="Japanese_Japan.AL32UTF8"' >> ~/.bash_profile

AL32UTF8


RUN yum install -y git unzip vim gcc openssl-devel readline-devel zlib-devel sqlite-devel nodejs bzip2 make
RUN git clone https://github.com/sstephenson/rbenv.git /usr/local/rbenv
RUN mkdir /usr/local/rbenv/shims /usr/local/rbenv/versions /usr/local/rbenv/plugins
RUN groupadd rbenv
RUN chgrp -R rbenv /usr/local/rbenv
RUN chmod -R g+rwxXs /usr/local/rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git /usr/local/rbenv/plugins/ruby-build
RUN chgrp -R rbenv /usr/local/rbenv/plugins/ruby-build
RUN chmod -R g+rwxs /usr/local/rbenv/plugins/ruby-build
RUN /usr/local/rbenv/plugins/ruby-build/install.sh
RUN git clone https://github.com/sstephenson/rbenv-default-gems.git /usr/local/rbenv/plugins/rbenv-default-gems
RUN chgrp -R rbenv /usr/local/rbenv/plugins/rbenv-default-gems
RUN chmod -R g+rwxs /usr/local/rbenv/plugins/rbenv-default-gems
RUN echo 'export RBENV_ROOT="/usr/local/rbenv"' >> /etc/profile.d/rbenv.sh
RUN echo 'export PATH="/usr/local/rbenv/bin:$PATH"' >> /etc/profile.d/rbenv.sh
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
RUN echo '%rbenv ALL=(ALL) ALL' >> /etc/sudoers
RUN su -l root -c '/usr/local/rbenv/bin/rbenv install 2.6.3 -v'
RUN su -l root -c '/usr/local/rbenv/bin/rbenv rehash'
RUN su -l root -c '/usr/local/rbenv/bin/rbenv global 2.6.3'
RUN su -l root -c 'gem install -N rails ruby-oci8'
RUN su -l root -c 'mkdir /usr/local/app && cd /usr/local/app'
RUN su -l root -c 'rails new dummy && cd dummy && bundle package --all'



ENV PATH=$PATH:/usr/lib/oracle/18.3/client64/bin
ENV LD_LIBRARY_PATH="/usr/lib/oracle/18.3/client64/lib"
ENV TNS_ADMIN="/usr/etc"


CMD ["/bin/bash", "--login"]