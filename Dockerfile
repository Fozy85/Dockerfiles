# Note Will need to migrate to Amazon Linux 2023 by mid-2025
# https://aws.amazon.com/amazon-linux-2/faqs/
FROM amazonlinux:2

# Updates packages to latest version
RUN yum update -y

# Installs the jdk from amazon software repository
# Should work with Spark https://hub.docker.com/layers/apache/spark/latest/images/sha256-a4a48089219912a8a87d7928541d576df00fc8d95f18a1509624e32b0e5c97d7?context=explore
RUN echo 'yes' | amazon-linux-extras install java-openjdk11 

# Print the version of java runtime env in CLI
RUN java -version

# Installs python 3.8 from amazon software repository
RUN echo 'yes' | amazon-linux-extras install python3.8

# Priortises the path for python 3.8 over the version that comes with the base image (2.7)
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1

# Checks if pip is installed, installs if not, and upgrades to latest version
RUN python -m ensurepip --upgrade

# Prints the version of python and pip in CLI
RUN python --version && python -m pip --version

# Opens a shell. Not recommended for prod as this opens root dir... include test only
CMD ["/bin/bash"]