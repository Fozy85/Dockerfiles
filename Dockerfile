# Wouldn't we want a later version for fewer vulnerabilities and dependency issues?
# This is why setuptools is upgraded.
FROM python:3.8

# Upgrades to the latest version of PIP
RUN pip install --no-cache-dir --upgrade pip

# As I'm pulling from the official image, will store in this path.
# This script adds this directory to my PATH, so it will be the preferred Python version.
ENV PATH /usr/local/bin:$PATH

# Resolves vulnerability with setuptools package
RUN python -m pip install --upgrade setuptools

# Prints Python version in CLI
RUN python --version

# This CLI command will run a Python container
CMD ["python"]