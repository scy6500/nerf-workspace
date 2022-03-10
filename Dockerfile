FROM nvidia/cuda:11.3.1-devel-ubuntu20.04

USER root

### BASICS ###
# Technical Environment Variables
ENV \
    SHELL="/bin/bash" \
    HOME="/root"  \
    # Nobteook server user: https://github.com/jupyter/docker-stacks/blob/master/base-notebook/Dockerfile#L33
    NB_USER="root" \
    USER_GID=0 \
    DISPLAY=":1" \
    TERM="xterm" \
    DEBIAN_FRONTEND="noninteractive" \
    WORKSPACE_HOME="/workspace"

WORKDIR $HOME

# Layer cleanup script
COPY scripts/clean-layer.sh  /usr/bin/clean-layer.sh
COPY scripts/fix-permissions.sh  /usr/bin/fix-permissions.sh

# Make clean-layer and fix-permissions executable
RUN \
    chmod a+rwx /usr/bin/clean-layer.sh && \
    chmod a+rwx /usr/bin/fix-permissions.sh

# Generate and Set locals
# https://stackoverflow.com/questions/28405902/how-to-set-the-locale-inside-a-debian-ubuntu-docker-container#38553499
RUN \
    apt-get update && \
    apt-get install -y locales && \
    # install locales-all?
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8 && \
    # Cleanup
    clean-layer.sh

ENV LC_ALL="en_US.UTF-8" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en"

# Install basics
RUN \
    apt-get update --fix-missing && \
    apt-get install -y sudo apt-utils && \
    apt-get upgrade -y && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    # This is necessary for apt to access HTTPS sources:
    apt-transport-https \
    gnupg-agent \
    gpg-agent \
    gnupg2 \
    ca-certificates \
    build-essential \
    pkg-config \
    software-properties-common \
    lsof \
    net-tools \
    libcurl4 \
    curl \
    wget \
    cron \
    openssl \
    psmisc \
    iproute2 \
    tmux \
    dpkg-sig \
    uuid-dev \
    csh \
    xclip \
    clinfo \
    time \
    libssl-dev \
    libgdbm-dev \
    libncurses5-dev \
    libncursesw5-dev \
    # required by pyenv
    libreadline-dev \
    libedit-dev \
    xz-utils \
    gawk \
    # Simplified Wrapper and Interface Generator (5.8MB) - required by lots of py-libs
    swig \
    # Graphviz (graph visualization software) (4MB)
    graphviz libgraphviz-dev \
    # Terminal multiplexer
    screen \
    # Editor
    nano \
    # Find files
    locate \
    # Dev Tools
    sqlite3 \
    # XML Utils
    xmlstarlet \
    # GNU parallel
    parallel \
    #  R*-tree implementation - Required for earthpy, geoviews (3MB)
    libspatialindex-dev \
    # Search text and binary files
    yara \
    # Minimalistic C client for Redis
    libhiredis-dev \
    # postgresql client
    libpq-dev \
    # mariadb client (7MB)
    # libmariadbclient-dev \
    # image processing library (6MB), required for tesseract
    libleptonica-dev \
    # GEOS library (3MB)
    libgeos-dev \
    # style sheet preprocessor
    less \
    # Print dir tree
    tree \
    # Bash autocompletion functionality
    bash-completion \
    # ping support
    iputils-ping \
    # Map remote ports to localhosM
    socat \
    # Json Processor
    jq \
    rsync \
    # sqlite3 driver - required for pyenv
    libsqlite3-dev \
    # VCS:
    git \
    subversion \
    jed \
    # odbc drivers
    unixodbc unixodbc-dev \
    # Image support
    libtiff-dev \
    libjpeg-dev \
    libpng-dev \
    libglib2.0-0 \
    libxext6 \
    libsm6 \
    libxext-dev \
    libxrender1 \
    libzmq3-dev \
    # protobuffer support
    protobuf-compiler \
    libprotobuf-dev \
    libprotoc-dev \
    autoconf \
    automake \
    libtool \
    cmake  \
    fonts-liberation \
    google-perftools \
    # Compression Libs
    zip \
    gzip \
    unzip \
    bzip2 \
    lzop \
    libarchive-tools \
    zlibc \
    # unpack (almost) everything with one command
    unp \
    libbz2-dev \
    liblzma-dev \
    zlib1g-dev \
    # OpenMPI support
    libopenmpi-dev \
    openmpi-bin \
    # libartals
    liblapack-dev \
    libatlas-base-dev \
    libeigen3-dev \
    libblas-dev \
    # HDF5
    libhdf5-dev \
    # TBB   
    libtbb-dev \
    libopenexr-dev \
    # GCC OpenMP
    libgomp1 \
    # ttyd
    libwebsockets-dev \
    libjson-c-dev \
    libssl-dev \
    # data science
    libopenmpi-dev \
    openmpi-bin \
    libomp-dev \
    libopenblas-base \
    # ETC
    vim && \
    # Update git to newest version
    add-apt-repository -y ppa:git-core/ppa  && \
    apt-get update && \
    apt-get install -y --no-install-recommends git && \
    # Fix all execution permissions
    chmod -R a+rwx /usr/local/bin/ && \
    # configure dynamic linker run-time bindings
    ldconfig && \
    # Fix permissions
    fix-permissions.sh $HOME && \
    # Cleanup
    clean-layer.sh

### END BASICS ###

### MINICONDA ###
# Install Miniconda: https://repo.continuum.io/miniconda/
ENV \
    CONDA_DIR=/opt/conda \
    CONDA_ROOT=/opt/conda \
    PYTHON_VERSION="3.7" \
    CONDA_PYTHON_DIR=/opt/conda/lib/python3.7 \
    MINICONDA_VERSION=4.11.0 \
    MINICONDA_MD5=7675bd23411179956bcc4692f16ef27d \
    CONDA_VERSION=4.11.0

RUN wget --no-verbose https://repo.anaconda.com/miniconda/Miniconda3-py37_${CONDA_VERSION}-Linux-x86_64.sh -O ~/miniconda.sh && \
    echo "${MINICONDA_MD5} *miniconda.sh" | md5sum -c - && \
    /bin/bash ~/miniconda.sh -b -p $CONDA_ROOT && \
    export PATH=$CONDA_ROOT/bin:$PATH && \
    rm ~/miniconda.sh && \
    # Update conda
    $CONDA_ROOT/bin/conda update -y -n base conda && \
    $CONDA_ROOT/bin/conda install -y conda-build && \
    $CONDA_ROOT/bin/conda install -y --update-all python=$PYTHON_VERSION && \
    # Link Conda
    ln -s $CONDA_ROOT/bin/python /usr/local/bin/python && \
    ln -s $CONDA_ROOT/bin/conda /usr/bin/conda && \
    # Update
    $CONDA_ROOT/bin/conda install -y pip && \
    $CONDA_ROOT/bin/pip install --upgrade pip && \
    chmod -R a+rwx /usr/local/bin/ && \
    # Cleanup - Remove all here since conda is not in path as of now
    $CONDA_ROOT/bin/conda clean -y --packages && \
    $CONDA_ROOT/bin/conda clean -y -a -f  && \
    $CONDA_ROOT/bin/conda build purge-all && \
    # Fix permissions
    fix-permissions.sh $CONDA_ROOT && \
    clean-layer.sh
ENV PATH=$CONDA_ROOT/bin:$PATH
### END MINICONDA ###

### DEV TOOLS ###

## Install Jupyter Notebook
RUN \
    $CONDA_ROOT/bin/conda install -c conda-forge \
        jupyterlab notebook voila jupyter_contrib_nbextensions ipywidgets \
        autopep8 yapf && \
    # Activate and configure extensions
    jupyter contrib nbextension install --sys-prefix && \
    # Cleanup
    $CONDA_ROOT/bin/conda clean -y --packages && \
    $CONDA_ROOT/bin/conda clean -y -a -f  && \
    $CONDA_ROOT/bin/conda build purge-all && \
    clean-layer.sh

## For Notebook Branding
COPY branding/logo.png /tmp/logo.png
COPY branding/favicon.ico /tmp/favicon.ico
RUN /bin/bash -c 'cp /tmp/logo.png $(python -c "import sys; print(sys.path[-1])")/notebook/static/base/images/logo.png'
RUN /bin/bash -c 'cp /tmp/favicon.ico $(python -c "import sys; print(sys.path[-1])")/notebook/static/base/images/favicon.ico'
RUN /bin/bash -c 'cp /tmp/favicon.ico $(python -c "import sys; print(sys.path[-1])")/notebook/static/favicon.ico'

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

### END DEV TOOLS ###

# # Install package from requirements.txt
# COPY requirements.txt ./requirements.txt
# RUN pip install -r ./requirements.txt && \
#    rm requirements.txt && \
#    clean-layer.sh

# Install package from environment.yml ( conda )
COPY environment.yml ./environment.yml
RUN conda env update --name root --file environment.yml && \
    rm environment.yml && \
    clean-layer.sh

# /workspace
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

### Oh-My-Zsh ###
RUN \
    apt-get update --fix-missing && \
    apt-get install -y zsh
ENV SHELL /usr/bin/zsh
RUN \
    sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
    conda init zsh && \
    chsh -s /usr/bin/zsh $NB_USER
### Add Oh My Zsh Plugins ###
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
RUN git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
RUN git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
RUN sed -i 's/plugins=(.*)/plugins=(git pip python zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search zsh-completions)/g' ~/.zshrc

### END Oh-My-Zsh ###

### Start Ainize Worksapce ###
COPY start.sh /scripts/start.sh
RUN ["chmod", "+x", "/scripts/start.sh"]
CMD "/scripts/start.sh"
