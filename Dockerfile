FROM nvidia/cuda:11.3.1-cudnn8-devel-ubuntu20.04

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
USER root

ENV \
    NB_USER=root \
    SHELL=/bin/bash \
    HOME="/${NB_USER}" \
    USER_GID=0 \
    DISPLAY=:1 \
    TERM=xterm \
    WORKSPACE_HOME=/workspace

# Copy a script that we will use to correct permissions after running certain commands
COPY scripts/clean-layer.sh  /usr/bin/clean-layer.sh
COPY scripts/fix-permissions.sh  /usr/bin/fix-permissions.sh
RUN \
    chmod a+rwx /usr/bin/clean-layer.sh && \
    chmod a+rwx /usr/bin/fix-permissions.sh
# Install Ubuntu Package
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update --yes && \
    apt-get upgrade --yes && \
    apt-get install --yes --no-install-recommends \
	apt-utils \
	autoconf \
	automake \
	build-essential \
	ca-certificates \
	ccache \
	cm-super \
	cmake \
	curl \
	dvipng \
	ffmpeg \
	fonts-liberation \
	g++ \
	git \
	gnupg2 \
	libatlas-base-dev \
	libboost-filesystem-dev \
	libboost-graph-dev \
	libboost-program-options-dev \
	libboost-system-dev \
	libboost-test-dev \
	libcgal-dev \
	libcgal-qt5-dev \
	libeigen3-dev \
	libfreeimage-dev \
	libgflags-dev \
	libgl1-mesa-glx \
	libglew-dev \
	libgoogle-glog-dev \
	libjpeg-dev \
	libjson-c-dev \
	libmetis-dev \
	libpng-dev \
	libqt5opengl5-dev \
	libssl-dev \
	libsuitesparse-dev \
	libtool \
	libwebsockets-dev \
	locales \
	make \
	openssh-client \
	openssh-server \
	pandoc \
	pkg-config \
	qtbase5-dev \
	run-one \
	sudo \
	tini \
	unzip \
	vim \
	vim-common \
	wget && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && \
    clean-layer.sh

ENV \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

# Install Python (mamba)
ENV \
    CONDA_DIR=/opt/conda \
    CONDA_ROOT=/opt/conda
ENV PATH="${CONDA_DIR}/bin:${PATH}"
ENV \
    PYTHON_VERSION=3.8 \
    CONDA_MIRROR=https://github.com/conda-forge/miniforge/releases/latest/download

RUN set -x && \
    # Miniforge installer
    miniforge_arch=$(uname -m) && \
    miniforge_installer="Mambaforge-Linux-${miniforge_arch}.sh" && \
    wget --quiet "${CONDA_MIRROR}/${miniforge_installer}" && \
    /bin/bash "${miniforge_installer}" -f -b -p "${CONDA_DIR}" && \
    rm "${miniforge_installer}" && \
    # Conda configuration see https://conda.io/projects/conda/en/latest/configuration.html
    conda config --system --set auto_update_conda false && \
    conda config --system --set show_channel_urls true && \
    if [[ "${PYTHON_VERSION}" != "default" ]]; then mamba install --quiet --yes python="${PYTHON_VERSION}"; fi && \
    # Pin major.minor version of python
    mamba list python | grep '^python ' | tr -s ' ' | cut -d ' ' -f 1,2 >> "${CONDA_DIR}/conda-meta/pinned" && \
    # Using conda to update all packages: https://github.com/mamba-org/mamba/issues/1092
    conda install -y conda-build && \
    conda update --all --quiet --yes && \
    conda clean --all -f -y && \
    fix-permissions.sh $CONDA_ROOT && \
    clean-layer.sh
# Install Dev Tools

## Install Jupyter
RUN mamba install --quiet --yes \
    notebook \
    jupyterhub \
    jupyterlab \
    voila \
    jupyter_contrib_nbextensions \
    ipywidgets \
    autopep8 \
    yapf && \
    mamba clean --all -f -y && \
    npm cache clean --force && \
    jupyter contrib nbextension install --sys-prefix && \
    fix-permissions.sh $CONDA_ROOT && \
    clean-layer.sh
    
COPY branding/logo.png /tmp/logo.png
COPY branding/favicon.ico /tmp/favicon.ico
RUN /bin/bash -c 'cp /tmp/logo.png $(python -c "import sys; print(sys.path[-1])")/notebook/static/base/images/logo.png'
RUN /bin/bash -c 'cp /tmp/favicon.ico $(python -c "import sys; print(sys.path[-1])")/notebook/static/base/images/favicon.ico'
RUN /bin/bash -c 'cp /tmp/favicon.ico $(python -c "import sys; print(sys.path[-1])")/notebook/static/favicon.ico'

# Install Ceres Solver
RUN git clone https://github.com/ceres-solver/ceres-solver.git
RUN cd ceres-solver && \
    git checkout $(git describe --tags) && \
	mkdir build && \
	cd build && \
	cmake .. -DBUILD_TESTING=OFF -DBUILD_EXAMPLES=OFF && \
	make -j4 && \
	make install && \
    cd ../.. && \
    rm -rf ceres-solver && \
    clean-layer.sh
    
# Configure and compile COLMAP:
RUN git clone https://github.com/colmap/colmap.git
RUN cd colmap && \
    git checkout dev && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j4 && \
    make install && \
    cd ../.. && \
    rm -rf colmap && \
    clean-layer.sh

## Install Visual Studio Code Server
RUN curl -fsSL https://code-server.dev/install.sh | sh && \
    clean-layer.sh

## Install ttyd. (Not recommended to edit)
RUN \
    wget https://github.com/tsl0922/ttyd/archive/refs/tags/1.6.2.zip \
    && unzip 1.6.2.zip \
    && cd ttyd-1.6.2 \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make \
    && make install

# Install Python package from environment.yml
COPY environment.yml ./environment.yml
RUN mamba env update --name root --file environment.yml && \
    rm environment.yml && \
    mamba clean --all -f -y && \
    npm cache clean --force && \
    jupyter contrib nbextension install --sys-prefix && \
    clean-layer.sh

# Make folders
ENV WORKSPACE_HOME="/workspace"
RUN \
    if [ -e $WORKSPACE_HOME ] ; then \
    chmod a+rwx $WORKSPACE_HOME; \
    else \
    mkdir $WORKSPACE_HOME && chmod a+rwx $WORKSPACE_HOME; \
    fi
ENV HOME=$WORKSPACE_HOME
WORKDIR $WORKSPACE_HOME
### Start Ainize Worksapce ###
COPY start.sh /scripts/start.sh
RUN ["chmod", "+x", "/scripts/start.sh"]
CMD "/scripts/start.sh"
