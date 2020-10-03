FROM nvidia/cuda:10.2-devel-centos7

RUN mkdir /opt/carl
WORKDIR /opt/carl

COPY cudaPi.cu /opt/carl/cudaPi.cu
RUN nvcc cudaPi.cu -o cudaPi && chmod +x cudaPi

COPY gpu-test.sh /opt/carl/gpuTest.sh
RUN chmod +x gpuTest.sh

ENTRYPOINT ["/opt/gpuburn/gpuTest.sh"]
