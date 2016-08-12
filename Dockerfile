FROM ubuntu:14.04

RUN apt-get update && apt-get install -y \
    libgeotiff-dev \
    libgdal-dev \
    libgeos-dev \
    libeigen3-dev \
    libflann-dev \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    gfortran \
    git \
    libarmadillo-dev \
    libarpack2-dev \
    libflann-dev \
    libhdf5-serial-dev \
    liblapack-dev \
    libtiff5-dev \
    openssh-client \
    python-dev \
    python-numpy \
    python-software-properties \
    software-properties-common \
    wget \
    automake \
    libtool \
    libspatialite-dev \
    libhdf5-dev \
    subversion \
    libjsoncpp-dev \
    libboost-filesystem1.55-dev \
    libboost-iostreams1.55-dev \
    libboost-program-options1.55-dev \
    libboost-system1.55-dev \
    libboost-thread1.55-dev \
    subversion \
    clang \
    libproj-dev \
    libc6-dev \
    libnetcdf-dev \
    libjasper-dev \
    libpng-dev \
    libjpeg-dev \
    libgif-dev \
    libwebp-dev \
    libhdf4-alt-dev \
    libhdf5-dev \
    libpq-dev \
    libxerces-c-dev \
    unixodbc-dev \
    libsqlite3-dev \
    libgeos-dev \
    libmysqlclient-dev \
    libltdl-dev \
    libcurl4-openssl-dev \
    libspatialite-dev \
    libdap-dev\
    ninja \
    cython \
    python-pip

RUN add-apt-repository ppa:ubuntu-toolchain-r/test && apt-get update && apt-get install -y gcc-4.9 g++-4.9 && \
    cd /usr/bin && \
    rm gcc g++ cpp && \
    ln -s gcc-4.9 gcc && \
    ln -s g++-4.9 g++ && \
    ln -s cpp-4.9 cpp

WORKDIR /opt

RUN git clone https://github.com/chambbj/pcl.git \
    && cd pcl \
    && git checkout pcl-1.7.2-sans-opengl \
    && mkdir build \
    && cd build \
    && CXXFLAGS="-std=c++11"  cmake \
            -DBUILD_2d=ON \
            -DBUILD_CUDA=OFF \
            -DBUILD_GPU=OFF \
            -DBUILD_apps=OFF \
            -DBUILD_common=ON \
            -DBUILD_examples=OFF \
            -DBUILD_features=ON \
            -DBUILD_filters=ON \
            -DBUILD_geometry=ON \
            -DBUILD_global_tests=OFF \
            -DBUILD_io=ON \
            -DBUILD_kdtree=ON \
            -DBUILD_keypoints=ON \
            -DBUILD_ml=ON \
            -DBUILD_octree=ON \
            -DBUILD_outofcore=OFF \
            -DBUILD_people=OFF \
            -DBUILD_recognition=OFF \
            -DBUILD_registration=ON \
            -DBUILD_sample_concensus=ON \
            -DBUILD_search=ON \
            -DBUILD_segmentation=ON \
            -DBUILD_simulation=OFF \
            -DBUILD_stereo=OFF \
            -DBUILD_surface=ON \
            -DBUILD_surface_on_nurbs=OFF \
            -DBUILD_tools=OFF \
            -DBUILD_tracking=OFF \
            -DBUILD_visualization=OFF \
            -DWITH_LIBUSB=OFF \
            -DWITH_OPENNI=OFF \
            -DWITH_OPENNI2=OFF \
            -DWITH_FZAPI=OFF \
            -DWITH_PXCAPI=OFF \
            -DWITH_PNG=OFF \
            -DWITH_QHULL=OFF \
            -DWITH_QT=OFF \
            -DWITH_VTK=OFF \
            -DWITH_PCAP=OFF \
            -DCMAKE_INSTALL_PREFIX=/usr \
            -DCMAKE_BUILD_TYPE="Release" \
            .. \
    && make \
    && make install

RUN git clone https://github.com/LASzip/LASzip.git laszip \
    && cd laszip \
    && git checkout e7065cbc5bdbbe0c6e50c9d93d1cd346e9be6778 \
    && mkdir build \
    && cd build \
    && cmake \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DCMAKE_BUILD_TYPE="Release" \
        .. \
    && make \
    && make install

RUN git clone https://github.com/hobu/hexer.git \
    && cd hexer \
    && mkdir build \
    && cd build \
    && cmake \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DCMAKE_BUILD_TYPE="Release" \
        .. \
    && make \
    && make install

RUN git clone https://github.com/CRREL/points2grid.git \
    && cd points2grid \
    && mkdir build \
    && cd build \
    && cmake \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DCMAKE_BUILD_TYPE="Release" \
        .. \
    && make \
    && make install

RUN git clone  https://github.com/hobu/laz-perf.git \
    && cd laz-perf \
    && mkdir build \
    && cd build \
    && cmake \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DCMAKE_BUILD_TYPE="Release" \
        .. \
    && make \
    && make install

RUN add-apt-repository ppa:george-edison55/cmake-3.x
RUN apt-get update && apt-get upgrade -y
RUN wget http://bitbucket.org/eigen/eigen/get/3.2.7.tar.gz \
    && tar -xvf 3.2.7.tar.gz \
    && cp -R eigen-eigen-b30b87236a1b/Eigen/ /usr/include/Eigen/ \
    && cp -R eigen-eigen-b30b87236a1b/unsupported/ /usr/include/unsupported/

RUN git clone https://github.com/gadomski/fgt.git \
    && cd fgt \
    && git checkout v0.4.4 \
    && cmake . -DWITH_TESTS=OFF -DBUILD_SHARED_LIBS=ON -DEIGEN3_INCLUDE_DIR=/usr/include -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release \
    && make \
    && make install

RUN git clone https://github.com/gadomski/cpd.git \
    && cd cpd \
    && git checkout v0.3.2 \
    && cmake . -DWITH_TESTS=OFF -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release \
    && make \
    && make install

RUN git clone --depth=1 https://github.com/PDAL/PDAL \
    && cd PDAL \
    && git checkout master \
    && mkdir build \
    && cd build \
    && cmake \
        -DBUILD_PLUGIN_CPD=OFF \
        -DBUILD_PLUGIN_GREYHOUND=OFF \
        -DBUILD_PLUGIN_HEXBIN=ON \
        -DBUILD_PLUGIN_ICEBRIDGE=OFF \
        -DBUILD_PLUGIN_MRSID=OFF \
        -DBUILD_PLUGIN_NITF=OFF \
        -DBUILD_PLUGIN_OCI=OFF \
        -DBUILD_PLUGIN_P2G=ON \
        -DBUILD_PLUGIN_PCL=ON \
        -DBUILD_PLUGIN_PGPOINTCLOUD=OFF \
        -DBUILD_PLUGIN_SQLITE=ON \
        -DBUILD_PLUGIN_RIVLIB=OFF \
        -DBUILD_PLUGIN_PYTHON=ON \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DENABLE_CTEST=OFF \
        -DWITH_APPS=ON \
        -DWITH_LAZPERF=ON \
        -DWITH_GEOTIFF=ON \
        -DWITH_LASZIP=ON \
        -DWITH_TESTS=ON \
        -DCMAKE_BUILD_TYPE=Release \
        .. \
    && make -j4 \
    && make install
