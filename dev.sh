#!/bin/bash
sudo docker container rm cetoolbox
sudo docker build --no-cache -t bryanherger/vertica-toolbox-withce:latest .
sudo docker create --name cetoolbox -it -p 18088:8088 -p 18888:8888 -p 15433:5433 -p 15450:5450 -v $HOME/notebook:/home/jovyan/work -v $HOME/verticace:/home/jovyan/verticace bryanherger/vertica-toolbox-withce:latest bash
sudo docker start -i cetoolbox
sudo docker container rm cetoolbox

