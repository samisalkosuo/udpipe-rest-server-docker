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

#get training model for Finnish
#change this to other language if/when needed
#or you can add more models and train all in single build
#see here what languages are available: https://github.com/UniversalDependencies

#this one is for Finnish
RUN wget -q https://github.com/UniversalDependencies/UD_Finnish/archive/master.zip
RUN unzip -q master.zip

#generate a model file name with current time
RUN echo udpipe_fin_$(date +%Y%m%d%H%M%S).model > filename.txt

#train udpipe, this will take time
RUN ./udpipe --train $(cat filename.txt) UD_Finnish-master/fi-ud-train.conllu

#web server to download model
#RUN mkdir models
#RUN cp $(cat filename.txt) ./models
#WORKDIR /udpipe/udpipe/src/models
#EXPOSE 8000
#CMD python -m SimpleHTTPServer
CMD ["/bin/bash"]

