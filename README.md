# UDPipe REST server Docker

Docker container for UDPipe (https://github.com/ufal/udpipe) REST server. 

UDPipe is trainable pipeline for tokenizing, tagging, lemmatizing and parsing Universal Treebanks and other CoNLL-U files.

## Usage

To use UDPipe REST server, you need to:

- Find a language model.
  - Train it or get if from somewhere.
- To train a modeL:
  - Get a training file. For example, from [Universal Dependencies](https://github.com/UniversalDependencies/).
  - Train UDPipe for the language.
- Build Docker image with the language model.
- Run Docker image.
- Use it.

Example how to use is described below. It shows how to train UDPipe for Finnish and create UDPipe REST server Docker image for Finnish.

## Training

Training needs some manual steps.

1. Download or clone this repository to your computer.
1. Create directory *training_files* under *training*-directory.
1. Download Finnish training file [fi-ud-train.conllu](https://github.com/UniversalDependencies/UD_Finnish/blob/master/fi-ud-train.conllu) to *training_files*-directory.
   - GitHub repo of the file is: [UD_Finnish](https://github.com/UniversalDependencies/UD_Finnish)
1. Copy *training/training_template.dockerfile* to *training/training_fi.dockerfile*.
1. Find ENV-entries in the *training_fi.dockerfile* :
   - Set training file name in *training_files*-directory. Finnish training file: *fi-ud-train.conllu*.
   - Set model name. For example: *fi_20180111.model*.
1. Start training by executing docker build:
   - Change to *training*-directory.
   - *docker build -t training_fi -f training_fi.dockerfile .*
1. Wait... wait... wait for it...
1. Eventually, start the Docker-container:
   - *docker run -it --rm -p 8000:8000 training_fi*
1. Use browser and go to [http://127.0.0.1:8000](http://127.0.0.1:8000).
   - Download model file to *training/models*-directory.

The next step is to build REST-server Docker image using the model file you just downloaded.

## REST server

During training, we trained the model file to be used with UDPipe REST server. Follow the instructions to build the actual REST server image.

1. Copy *rest_server_template.dockerfile* to *rest_server_fi.dockerfile*.
1. Open *rest_server_fi.dockerfile* and find ENV-entries
   - change *MODEL_FILE_NAME* to the model name from previous section
     - For example: *fi*
   - change *MODEL_NAME* and *MODEL_DESC* to some descriptive name.
     - For example: *finnish_model_20180112*
1. Build Docker image:
   - *docker build -t udpipe-rest-server-fi -f rest_server_fi.dockerfile .*
1. Run Docker image:
   - *docker run -it --rm -p 8080:8080 -t udpipe-rest-server-fi*
1. Access and test using browser: [http://127.0.0.1:8080/process?data=Hei%20maailma!Mitä%20kuuluu?&tokenizer&tagger&parser](http://127.0.0.1:8080/process?data=Hei%20maailma!Mitä%20kuuluu?&tokenizer&tagger&parser) 

[See also documentation about the REST server](http://ufal.mff.cuni.cz/udpipe/users-manual#udpipe_server).

You can use curl to test:

- curl -F data=@data/text.txt -F tokenizer= -F tagger= -F parser= http://127.0.0.1:8080/process

To get CoNLL-U back, use this:

- curl -F data=@data/text.txt -F tokenizer= -F tagger= -F parser= http://127.0.0.1:8080/process | PYTHONIOENCODING=utf-8 python -c "import sys,json; sys.stdout.write(json.load(sys.stdin)['result'])"

## Misc notes

[Universal Dependencies](https://github.com/UniversalDependencies/) includes quite many languages and each of them have training files. All of them can be used to build model for the UDPipe REST server.

Many models can be included in single REST server Docker image. See UDPipe docs how to start server with many models and change Docker file accordingly.

Pre-existing models can be also used. You can find some models from [UDPipe web site](http://ufal.mff.cuni.cz/udpipe) licensed under the [CC-BY-SA](http://creativecommons.org/licenses/by-nc-sa/4.0/).

## Disclaimer

Everything in this repo, including all code is "AS IS". No support, no warranty, no fitness for any purpose, nothing is expressed or implied, not by me (nor my employer).

## License

I am not sure what license to apply, so I don't claim any licensing.

If you want to know more and be sure, please seek legal advice.
