FROM continuumio/miniconda3

ARG model_bucket=http://max-assets.s3-api.us-geo.objectstorage.softlayer.net/pytorch/neuralstyle
ARG model_file=neuralstyle.tar.gz

WORKDIR /workspace
RUN mkdir assets
RUN wget -nv ${model_bucket}/${model_file} --output-document=/workspace/assets/${model_file}
RUN tar -x -C assets/ -f assets/${model_file} -v

# Conda is the preferred way to install Pytorch, but the Anaconda install pulls
# in non-OSS libraries with customized license terms, specifically CUDA and MKL.
#RUN conda update -n base conda
#RUN conda install -y pytorch-cpu torchvision -c pytorch

# pip install pytorch to avoid dependencies on MKL or CUDA
RUN pip install --upgrade pip
RUN pip install http://download.pytorch.org/whl/cpu/torch-0.3.1-cp36-cp36m-linux_x86_64.whl 
RUN pip install torchvision
RUN pip install flask-restplus

COPY . /workspace

EXPOSE 5000

CMD python app.py

