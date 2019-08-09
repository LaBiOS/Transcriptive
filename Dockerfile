# Galaxy - Transcriptive
FROM quay.io/bgruening/galaxy:17.09

MAINTAINER Fabiano Menegidio, fabiano.menegidio@biology.bio.br

# Enable Conda dependency resolution
ENV GALAXY_CONFIG_BRAND="Transcriptive" \
    GALAXY_CONFIG_CONDA_AUTO_INSTALL=True

ADD config/galaxy/tool_conf.xml $GALAXY_ROOT/config/
ADD config/galaxy/dependency_resolvers_conf.xml $GALAXY_ROOT/config/

# Install tools
# Split into multiple layers to minimize disk space usage while building
# Rules to follow:
#  - Keep in the same yaml file the tools that share common conda dependencies (conda is only able to use hardlinks within a Docker layer)
#  - Docker will use 2*(size of the layer) on the disk while building, so 1 yaml should not install more data than half of the remaining space on the disk
#     => 'big' tools should go in the first yaml file, the last yaml file should contain smaller tools
#  - When one of the layer can't be built with a "no space left" error message, you'll probably need to split a yaml in 2 (supposing you followed the previous rules)
ADD config/tools/tools_0.yaml $GALAXY_ROOT/tools_0.yaml
ADD config/tools/tools_1.yaml $GALAXY_ROOT/tools_1.yaml
ADD config/tools/tools_2.yaml $GALAXY_ROOT/tools_2.yaml
ADD config/tools/tools_3.yaml $GALAXY_ROOT/tools_3.yaml
ADD config/tools/tools_4.yaml $GALAXY_ROOT/tools_4.yaml
ADD config/tools/tools_5.yaml $GALAXY_ROOT/tools_5.yaml
ADD config/tools/tools_6.yaml $GALAXY_ROOT/tools_6.yaml
ADD config/tools/tools_7.yaml $GALAXY_ROOT/tools_7.yaml
ADD config/tools/tools_8.yaml $GALAXY_ROOT/tools_8.yaml

RUN df -h \
    && install-tools $GALAXY_ROOT/tools.yaml \
    && /tool_deps/_conda/bin/conda clean --tarballs --yes > /dev/null \
    && rm /export/galaxy-central/ -rf \
    && df -h

RUN df -h \
    && install-tools $GALAXY_ROOT/tools_0.yaml \
    && /tool_deps/_conda/bin/conda clean --tarballs --yes > /dev/null \
    && rm /export/galaxy-central/ -rf \
    && df -h
    
RUN df -h \
    && install-tools $GALAXY_ROOT/tools_1.yaml \
    && /tool_deps/_conda/bin/conda clean --tarballs --yes > /dev/null \
    && rm /export/galaxy-central/ -rf \
    && df -h
    
RUN df -h \
    && install-tools $GALAXY_ROOT/tools_2.yaml \
    && /tool_deps/_conda/bin/conda clean --tarballs --yes > /dev/null \
    && rm /export/galaxy-central/ -rf \
    && df -h

RUN df -h \
    && install-tools $GALAXY_ROOT/tools_3.yaml \
    && /tool_deps/_conda/bin/conda clean --tarballs --yes > /dev/null \
    && rm /export/galaxy-central/ -rf \
    && df -h
    
RUN df -h \
    && install-tools $GALAXY_ROOT/tools_4.yaml \
    && /tool_deps/_conda/bin/conda clean --tarballs --yes > /dev/null \
    && rm /export/galaxy-central/ -rf \
    && df -h
    
RUN df -h \
    && install-tools $GALAXY_ROOT/tools_5.yaml \
    && /tool_deps/_conda/bin/conda clean --tarballs --yes > /dev/null \
    && rm /export/galaxy-central/ -rf \
    && df -h
    
RUN df -h \
    && install-tools $GALAXY_ROOT/tools_6.yaml \
    && /tool_deps/_conda/bin/conda clean --tarballs --yes > /dev/null \
    && rm /export/galaxy-central/ -rf \
    && df -h
    
RUN df -h \
    && install-tools $GALAXY_ROOT/tools_7.yaml \
    && /tool_deps/_conda/bin/conda clean --tarballs --yes > /dev/null \
    && rm /export/galaxy-central/ -rf \
    && df -h

RUN df -h \
    && install-tools $GALAXY_ROOT/tools_8.yaml \
    && /tool_deps/_conda/bin/conda clean --tarballs --yes > /dev/null \
    && rm /export/galaxy-central/ -rf \
    && df -h

# Import workflows (local and from training) and data manager description, install the data libraries and the workflows
#COPY config/workflows/* $GALAXY_ROOT/workflows/
#ADD https://raw.githubusercontent.com/galaxyproject/training-material/master/topics/metagenomics/tutorials/general-tutorial/workflows/transcriptive-worklow.ga $GALAXY_ROOT/workflows/
#COPY config/data_managers.yaml $GALAXY_ROOT/data_managers.yaml
#COPY config/data_library.yaml $GALAXY_ROOT/data_library.yaml
ENV GALAXY_CONFIG_TOOL_PATH=/galaxy-central/tools/
#RUN startup_lite && \
#    galaxy-wait && \
#    workflow-install --workflow_path $GALAXY_ROOT/workflows/ -g http://localhost:8080 -u $GALAXY_DEFAULT_ADMIN_USER -p $GALAXY_DEFAULT_ADMIN_PASSWORD

# Copy the script to launch the data managers
#COPY bin/run_data_managers run_data_managers

# Add Container Style
#ENV GALAXY_CONFIG_WELCOME_URL=$GALAXY_CONFIG_DIR/web/welcome.html
#COPY config/welcome.html $GALAXY_CONFIG_DIR/web/welcome.html
#COPY config/asaim_logo.svg $GALAXY_CONFIG_DIR/web/welcome_asaim_logo.svg

VOLUME ["/export/", "/var/lib/docker", "/data/"]

# Expose port 80 (webserver), 21 (FTP server), 8800 (Proxy)
EXPOSE :80
EXPOSE :21
EXPOSE :22
EXPOSE :8800

# Autostart script that is invoked during container start
CMD ["/usr/bin/startup"]
