# extended from https://github.com/jupyter/docker-stacks/datascience-notebook
# and further extended from vertica-toolbox:
FROM bryanherger/vertica-toolbox

LABEL maintainer="Bryan Herger <bherger@users.sf.net>"

# copy examples
RUN git clone https://github.com/bryanherger/vertica-examples && cp -r vertica-example/* vertica-examples/ && rm -rf vertica-example/

# final setup
USER root
RUN apt-get install --no-install-recommends -y dialog net-tools openssh-server openssh-client iproute2
RUN echo "jovyan ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
COPY debian_cleaner.sh /tmp/
COPY odbc.ini /etc/
COPY base.py /opt/conda/lib/python3.6/site-packages/sqlalchemy_vertica/base.py
USER $NB_UID

# install Vertica and MC in start script if needed
COPY quickstart.sh /home/jovyan/quickstart.sh

