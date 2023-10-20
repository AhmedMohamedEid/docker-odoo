FROM ghcr.io/odoo-it/docker-odoo:16.0.2.0.3
#Install yaml
RUN pip install pyyaml
# Install gitaggregate
RUN pip install git-aggregator
COPY --chmod=777 bin/* /usr/local/bin/
# Install Odoo
COPY odoo.yml $RESOURCES/odoo.yml
RUN autoaggregate --install -c $RESOURCES/odoo.yml --output $SOURCES/repositories && pip-install-odoo

# Install repositories
ARG GITHUB_USER
ARG GITHUB_TOKEN
COPY repos.d/oca.yml $RESOURCES/repos.d/oca.yml
RUN autoaggregate --install -c $RESOURCES/repos.d/oca.yml --output $SOURCES/repositories

# Install project requirements
USER root
COPY --chown=odoo:odoo ./requirements.txt $RESOURCES/requirements.txt
RUN pip install -r $RESOURCES/requirements.txt
USER odoo

# Additional configs
COPY conf.d/* $RESOURCES/conf.d/
