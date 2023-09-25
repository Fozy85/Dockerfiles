# Note Will need to migrate to Amazon Linux 2023 by mid-2025
# https://aws.amazon.com/amazon-linux-2/faqs/
FROM amazonlinux:2

# Updates packages to latest version
RUN yum update -y

# Installs the jdk from amazon software repository
# Should work with Spark https://hub.docker.com/layers/apache/spark/latest/images/sha256-a4a48089219912a8a87d7928541d576df00fc8d95f18a1509624e32b0e5c97d7?context=explore
# But probably not needed with pyspark method... retain for now.
RUN echo 'yes' | amazon-linux-extras install java-openjdk11 

# Print the version of java runtime env in CLI
RUN java -version

# Install dependencies for Python 3.11
# The openssl modules update Openssl from 1.0.2 to 1.1.1 to integrate with python
# gcc is the compiler for python libraries that are built on top of c
# bzip2 and zlib are required for python libraries that use zlib or bzip2 compression
# wget is a linux web get request
# tar and gzip are needed to manipulate the compressed tarball file (tgz)
# make compiles and installs the python package.
# Based on https://tecadmin.net/how-to-install-python-3-11-on-amazon-linux-2/
RUN yum install -y \
    gcc \
    openssl11 \
    openssl11-devel \
    openssl11-libs \
    bzip2-devel \
    libffi-devel \
    zlib-devel \
    wget \
    gzip \
    tar \
    make

# Environment variables to make PYTHON_VERSION the default.
# PYTHON_HOME is the directory and is appended to the start of the path.
ENV PYTHON_HOME=/usr/share/python
ENV PYTHON_VERSION=3.11.5
ENV PATH="${PYTHON_HOME}/Python-${PYTHON_VERSION}:${PATH}"

# Downloads python 3.11.5 that does not any high https://hub.docker.com/layers/library/python/3.11.5/images/sha256-88880bc85b0e3342ff416c796df7ad9079b2805f92a6ebfc5c84ac582fb25de9?context=explore
# Configures python's build process with optimisations enabled on the binary.
# Uses altinstall so the existing binary is not replaced, to avoid unforseen issues with packages
RUN cd "/tmp" && \
    wget "https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz" && \
    tar xzf "Python-${PYTHON_VERSION}.tgz" && \
    mkdir "${PYTHON_HOME}" && \
    rm "Python-${PYTHON_VERSION}.tgz" && \
    mv "Python-${PYTHON_VERSION}" "${PYTHON_HOME}" && \
    cd "${PYTHON_HOME}/Python-${PYTHON_VERSION}" && \
    ./configure --enable-optimizations && \
    make altinstall

# Check default python is per PYTHON_VERSION.
RUN python --version

# Checks if pip is installed, installs if not, and upgrades to the latest version
# Prints pip version
RUN python -m ensurepip --upgrade && python -m pip --version

# Install PySpark and Jupyter Notebook using pip
RUN python -m pip install pyspark jupyterlab

# Set up a working directory for when the container is executed
WORKDIR /app

# Start Jupyter Notebook when the container is run
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--allow-root"]