FROM ghcr.io/odoo-it/docker-odoo:15.0.1.2.0

# Install Odoo
COPY odoo.yml $RESOURCES/odoo.yml
RUN autoaggregate -c $RESOURCES/odoo.yml --output $SOURCES/repositories && pip-install-odoo

# Install repositories
ARG GITHUB_USER
ARG GITHUB_TOKEN
COPY repos.d $RESOURCES/repos.d
RUN autoaggregate --directory $RESOURCES/repos.d --install --user --output $SOURCES/repositories

# Install project requirements
USER root
COPY --chown=odoo:odoo ./requirements.txt $RESOURCES/requirements.txt
RUN pip install -r $RESOURCES/requirements.txt
USER odoo

# Additional configs
COPY conf.d/* $RESOURCES/conf.d/
