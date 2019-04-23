# Using the Jupyter Notebook Scientific Python Stack
# FROM jupyter/scipy-notebook

FROM python:3.6.8

RUN apt-get update && apt-get install -y \
  gfortran \
  libblas-dev \
  liblapack-dev \
  vim \
  libopenmpi-dev \
  openmpi-bin \
  openmpi-doc \
  openmpi-common \
  nodejs

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# A fix https://github.com/jupyter/jupyter/issues/370
RUN pip uninstall -y ipykernel
RUN pip install ipykernel==4.8.0


RUN git clone https://github.com/plgrover/pymorph.git

RUN git clone -b maint https://bitbucket.org/petsc/petsc petsc
WORKDIR "/petsc"
RUN ./config/configure.py --with-cc=gcc --with-cxx=g++ --with-python=1 --download-mpich=1 --with-shared-libraries=1 --with-64-bit-indices=1
RUN make PETSC_DIR=/petsc/ PETSC_ARCH=arch-linux-c-debug all
WORKDIR "/"

RUN git clone https://github.com/clawpack/clawpack.git clawpack
WORKDIR "/clawpack"
RUN python setup.py git-dev
RUN pip install -e .
WORKDIR "/clawpack/riemann"
RUN git remote add plgrover https://github.com/plgrover/riemann.git

RUN pip install petsc4py

#COPY ..

