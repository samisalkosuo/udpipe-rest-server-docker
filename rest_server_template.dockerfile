FROM ubuntu

RUN apt-get update
RUN apt-get -y install gcc clang build-essential wget unzip 

#get udpipe code
WORKDIR /udpipe
#RUN git clone https://github.com/ufal/udpipe.git
RUN wget -q https://github.com/ufal/udpipe/archive/master.zip
RUN unzip -q master.zip
WORKDIR /udpipe/udpipe-master/src

#make udpipe server
RUN make server

#set your model file name is like: fi_20180811.model
#this model have been trained and it is in training/models directory
ENV MODEL_FILE_NAME <model file name here>
#set model name. UDPipe REST server shows this name
#for example: fi
ENV MODEL_NAME <model name here>
#model description is something that REST servers shows
ENV MODEL_DESC <model description here>

WORKDIR /udpipe/udpipe-master/src/rest_server

#add the model
ADD training/models/${MODEL_FILE_NAME} .

EXPOSE 8080
#start udpipe REST server
#using custom model
CMD ./udpipe_server 8080 ${MODEL_NAME} ${MODEL_NAME} ./${MODEL_FILE_NAME} "${MODEL_DESC}"

#CMD ["/bin/bash"]

