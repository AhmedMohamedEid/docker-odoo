FROM ghcr.io/odoo-it/docker-odoo:15.0

# Install Odoo
ARG ODOO_VERSION=15.0
ARG ODOO_SOURCE=OCA/OCB
ARG ODOO_SOURCE_DEPTH=1
RUN git clone --single-branch --depth $ODOO_SOURCE_DEPTH --branch $ODOO_VERSION https://github.com/$ODOO_SOURCE $SOURCES/odoo && pip-install-odoo

# Install project requirements
USER root
COPY --chown=odoo:odoo ./requirements.txt $RESOURCES/requirements.txt
RUN pip install -r $RESOURCES/requirements.txt
USER odoo

# Install modules
ARG GITHUB_USER
ARG GITHUB_TOKEN
COPY repos.d $RESOURCES/repos.d
RUN autoaggregate --directory $RESOURCES/repos.d --install --user --output $SOURCES/repositories

# Additional configs
COPY conf.d/* $RESOURCES/conf.d/
