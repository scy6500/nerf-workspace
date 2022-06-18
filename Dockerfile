FROM ubuntu:20.04

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
	clang-format \
	cm-super \
	cmake \
	curl \
	dvipng \
	ffmpeg \
	fonts-liberation \
	g++ \
	gcc \
	gir1.2-gtk-3.0 \
	git \
	gnupg2 \
	golang \
	libcairo2-dev \
	libcurl3-dev \
	libfreetype6-dev \
	libgflags-dev \
	libgirepository1.0-dev \
	libgl1-mesa-glx \
	libgtest-dev \
	libhdf5-serial-dev \
	libjpeg-dev \
	libjson-c-dev \
	libpng-dev \
	libssl-dev \
	libtool \
	libturbojpeg \
	libunwind-dev \
	libwebsockets-dev \
	libzmq3-dev \
	locales \
	make \
	openssh-client \
	openssh-server \
	pandoc \
	pkg-config \
	python3-dev \
	python3-gi \
	python3-gi-cairo \
	rsync \
	run-one \
	software-properties-common \
	sudo \
	tini \
	unzip \
	vim \
	vim-common \
	wget \
	zip \
	zlib1g-dev \
	libboost-program-options-dev \
    libboost-filesystem-dev \
    libboost-graph-dev \
    libboost-system-dev \
    libboost-test-dev \
	libeigen3-dev \
    libsuitesparse-dev \
    libfreeimage-dev \
    libmetis-dev \
    libgoogle-glog-dev \
	libgflags-dev \
	libglew-dev \
    qtbase5-dev \
    libqt5opengl5-dev \
	libcgal-qt5-dev \
    libcgal-dev \
	libsuitesparse-dev && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && \
    clean-layer.sh

ENV \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8
# Instal CUDA Package
## CUDA Base
# https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/11.2.2/ubuntu2004/base/Dockerfile
ENV NVARCH x86_64
ENV NV_CUDA_CUDART_VERSION 11.2.152-1
ENV NV_CUDA_COMPAT_PACKAGE cuda-compat-11-2

RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 curl ca-certificates && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/${NVARCH}/3bf863cc.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/${NVARCH} /" > /etc/apt/sources.list.d/cuda.list && \
    rm -rf /var/lib/apt/lists/*
    
ENV CUDA_VERSION 11.2.2

# For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-cudart-11.2=${NV_CUDA_CUDART_VERSION} \
    ${NV_CUDA_COMPAT_PACKAGE} \
    && ln -s cuda-11.2 /usr/local/cuda && \
    rm -rf /var/lib/apt/lists/*
    
# Required for nvidia-docker v1
RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf \
    && echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility

## CUDA RUNTIME
ENV NV_CUDA_LIB_VERSION 11.2.2-1
ENV NV_NVTX_VERSION 11.2.152-1
ENV NV_LIBNPP_VERSION 11.3.2.152-1
ENV NV_LIBNPP_PACKAGE libnpp-11-2=${NV_LIBNPP_VERSION}
ENV NV_LIBCUSPARSE_VERSION 11.4.1.1152-1

ENV NV_LIBCUBLAS_PACKAGE_NAME libcublas-11-2
ENV NV_LIBCUBLAS_VERSION 11.4.1.1043-1
ENV NV_LIBCUBLAS_PACKAGE ${NV_LIBCUBLAS_PACKAGE_NAME}=${NV_LIBCUBLAS_VERSION}

ENV NV_LIBNCCL_PACKAGE_NAME libnccl2
ENV NV_LIBNCCL_PACKAGE_VERSION 2.8.4-1
ENV NCCL_VERSION 2.8.4-1
ENV NV_LIBNCCL_PACKAGE ${NV_LIBNCCL_PACKAGE_NAME}=${NV_LIBNCCL_PACKAGE_VERSION}+cuda11.2

RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-libraries-11-2=${NV_CUDA_LIB_VERSION} \
    ${NV_LIBNPP_PACKAGE} \
    cuda-nvtx-11-2=${NV_NVTX_VERSION} \
    libcusparse-11-2=${NV_LIBCUSPARSE_VERSION} \
    ${NV_LIBCUBLAS_PACKAGE} \
    ${NV_LIBNCCL_PACKAGE} \
    && rm -rf /var/lib/apt/lists/*

# Keep apt from auto upgrading the cublas and nccl packages. See https://gitlab.com/nvidia/container-images/cuda/-/issues/88
RUN apt-mark hold ${NV_LIBCUBLAS_PACKAGE_NAME} ${NV_LIBNCCL_PACKAGE_NAME}

## CUDA DEVEL
ENV NV_CUDA_LIB_VERSION "11.2.2-1"

ENV NV_CUDA_CUDART_DEV_VERSION 11.2.152-1
ENV NV_NVML_DEV_VERSION 11.2.152-1
ENV NV_LIBCUSPARSE_DEV_VERSION 11.4.1.1152-1
ENV NV_LIBNPP_DEV_VERSION 11.3.2.152-1
ENV NV_LIBNPP_DEV_PACKAGE libnpp-dev-11-2=${NV_LIBNPP_DEV_VERSION}

ENV NV_LIBCUBLAS_DEV_VERSION 11.4.1.1043-1
ENV NV_LIBCUBLAS_DEV_PACKAGE_NAME libcublas-dev-11-2
ENV NV_LIBCUBLAS_DEV_PACKAGE ${NV_LIBCUBLAS_DEV_PACKAGE_NAME}=${NV_LIBCUBLAS_DEV_VERSION}

ENV NV_LIBNCCL_DEV_PACKAGE_NAME libnccl-dev
ENV NV_LIBNCCL_DEV_PACKAGE_VERSION 2.8.4-1
ENV NCCL_VERSION 2.8.4-1
ENV NV_LIBNCCL_DEV_PACKAGE ${NV_LIBNCCL_DEV_PACKAGE_NAME}=${NV_LIBNCCL_DEV_PACKAGE_VERSION}+cuda11.2

RUN apt-get update && apt-get install -y --no-install-recommends \
    libtinfo5 libncursesw5 \
    cuda-cudart-dev-11-2=${NV_CUDA_CUDART_DEV_VERSION} \
    cuda-command-line-tools-11-2=${NV_CUDA_LIB_VERSION} \
    cuda-minimal-build-11-2=${NV_CUDA_LIB_VERSION} \
    cuda-libraries-dev-11-2=${NV_CUDA_LIB_VERSION} \
    cuda-nvml-dev-11-2=${NV_NVML_DEV_VERSION} \
    ${NV_LIBNPP_DEV_PACKAGE} \
    libcusparse-dev-11-2=${NV_LIBCUSPARSE_DEV_VERSION} \
    ${NV_LIBCUBLAS_DEV_PACKAGE} \
    ${NV_LIBNCCL_DEV_PACKAGE} \
    && rm -rf /var/lib/apt/lists/*

# Keep apt from auto upgrading the cublas and nccl packages. See https://gitlab.com/nvidia/container-images/cuda/-/issues/88
RUN apt-mark hold ${NV_LIBCUBLAS_DEV_PACKAGE_NAME} ${NV_LIBNCCL_DEV_PACKAGE_NAME}

ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs

## CUDA DEVEL CUDNN8
ENV NV_CUDNN_VERSION 8.1.1.33

ENV NV_CUDNN_PACKAGE "libcudnn8=$NV_CUDNN_VERSION-1+cuda11.2"
ENV NV_CUDNN_PACKAGE_DEV "libcudnn8-dev=$NV_CUDNN_VERSION-1+cuda11.2"
ENV NV_CUDNN_PACKAGE_NAME "libcudnn8"

RUN apt-get update && apt-get install -y --no-install-recommends \
    ${NV_CUDNN_PACKAGE} \
    ${NV_CUDNN_PACKAGE_DEV} \
    && apt-mark hold ${NV_CUDNN_PACKAGE_NAME} && \
    rm -rf /var/lib/apt/lists/*

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

# Install colmap
RUN git clone https://github.com/ceres-solver/ceres-solver.git --branch 1.14.0
RUN cd ceres-solver && \
	mkdir build && \
	cd build && \
	cmake .. -DBUILD_TESTING=OFF -DBUILD_EXAMPLES=OFF && \
	make -j4 && \
	make install && \
    clean-layer.sh

RUN git clone https://github.com/colmap/colmap.git --branch 3.7

RUN cd colmap && \
	mkdir build && \
	cd build && \
	cmake .. && \
	make -j4 && \
	make install && \
    clean-layer.sh
    
# Install nerf package
RUN pip install pytorch-lightning==0.7.5 test-tube kornia==0.2.0 opencv-python==4.2.0.34
RUN git clone https://github.com/aliutkus/torchsearchsorted.git
RUN cd torchsearchsorted && \
	pip install . && \
	rm -rf build && \
    pip install .

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
