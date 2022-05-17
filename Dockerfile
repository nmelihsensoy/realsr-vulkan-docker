FROM nvidia/vulkan:1.1.121 as vulkan-ubuntu1804

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-key del 7fa2af80 && \
    apt-key del 3bf863cc && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    libgomp1

RUN wget -qO - http://packages.lunarg.com/lunarg-signing-key-pub.asc | apt-key add - && \
    wget -qO /etc/apt/sources.list.d/lunarg-vulkan-bionic.list http://packages.lunarg.com/vulkan/lunarg-vulkan-bionic.list && \
    apt update && \
    apt install -y vulkan-sdk

# ----------------------------------------------------------------------------
FROM vulkan-ubuntu1804 as builder

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y \
    build-essential \
    git \
    python3 \
    build-essential \
    ninja-build \
    libssl-dev

RUN wget -c https://github.com/Kitware/CMake/releases/download/v3.23.1/cmake-3.23.1.tar.gz -O - | tar -xz && \
    cd cmake-3.23.1 && \
    ./bootstrap && make && \
    make install

RUN cd / && \
    git clone https://github.com/nihui/realsr-ncnn-vulkan.git realsr && \
    cd /realsr && \
    git submodule update --init --recursive

RUN mkdir /realsr/build && \
    cd /realsr/build && \
    cmake -GNinja /realsr/src && \
    ninja

# ----------------------------------------------------------------------------
FROM vulkan-ubuntu1804 as runner

RUN rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
COPY --from=builder /realsr/models /usr/local/bin
COPY --from=builder /realsr/build/realsr-ncnn-vulkan /usr/local/bin/realsr-ncnn-vulkan

RUN ln -sf /usr/local/bin/realsr-ncnn-vulkan /usr/local/bin/realsr

ENTRYPOINT [ "/usr/local/bin/realsr-ncnn-vulkan" ]
CMD [ "-h" ]