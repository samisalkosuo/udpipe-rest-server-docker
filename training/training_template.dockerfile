FROM ubuntu

RUN apt-get update
RUN apt-get -y install gcc clang build-essential wget unzip 

#get udpipe code
WORKDIR /udpipe
#RUN git clone https://github.com/ufal/udpipe.git
RUN wget -q https://github.com/ufal/udpipe/archive/master.zip
RUN unzip -q master.zip
WORKDIR /udpipe/udpipe-master/src

#make udpipe
RUN make 

ENV TRAINING_MODEL_FILE_NAME <enter training model file name here>
#set your model name is like: fi_20180811.model
ENV MODEL_FILE_NAME <model file name here>

#add training model
ADD training_files/${TRAINING_MODEL_FILE_NAME} .

#train udpipe, this will take time
RUN ./udpipe --train ${MODEL_FILE_NAME} ${TRAINING_MODEL_FILE_NAME}

#web server to download model
RUN mkdir models
RUN cp ${MODEL_FILE_NAME} ./models
WORKDIR /udpipe/udpipe-master/src/models
EXPOSE 8000
CMD python -m SimpleHTTPServer
#CMD ["/bin/bash"]

