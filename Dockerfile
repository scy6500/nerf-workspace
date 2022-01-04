# Base Image From https://github.com/ainize-team/ainize-workspace-base-images
FROM byeongal/ainize-workspace-base-cuda11.3.1-py3.9-dev

USER root
## Basic Env
# /root
WORKDIR $HOME

# Install package from requirements.txt
#COPY requirements.txt ./requirements.txt
#RUN pip install -r ./requirements.txt && \
#    rm requirements.txt && \
#    clean-layer.sh
# Install package from environment.yml ( conda )
COPY environment.yml ./environment.yml
RUN conda env update --name root --file environment.yml && \
    rm environment.yml && \
    clean-layer.sh

# /workspace
WORKDIR $WORKSPACE_HOME