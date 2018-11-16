# vertica-toolbox-withce
Quickstart for Vertica analytics and ML with Jupyter Notebook, Superset, and examples on Vertica CE (server is a separate download)

### Prerequisites

You must obtain the Debian version of the Vertica CE and (optional) Management Console installers directly from Vertica as these require registration and EULA.

### Quick start

The image expects to find two folders mounted from the host: the notebooks/work folder and the folder containing the Vertica CE installers and data.

An example invocation:

```
docker create --name cetoolbox -it -p 18088:8088 -p 18888:8888 -p 15433:5433 -p 15450:5450 -v $HOME/notebook:/home/jovyan/work -v $HOME/verticace:/home/jovyan/verticace bryanherger/vertica-toolbox-withce:latest bash
docker start -i cetoolbox
```

This will mount "notebook" folder from the host as "work" and "verticace" folder from the host as "verticace".

The startup script expects to find DEB files named vertica.deb and vertica-mc.deb in the "verticace" folder; copy the DEB files here and rename or create symlinks.

After starting the image as in the example above, run the start script:

```
./quickstart.sh
```

This will install and start Vertica CE (TCP 5433), Vertica Console (TCP 5450), Jupyter (TCP 8888), Superset (TCP 8080) in the image.

Feel free to submit pull requests.  Note that currently, it's a good idea to delete the verticace/catalog and verticace/data directories on the host after stopping the image since not all Vertica configs are
persisted, so the catalog and data may not work between image runs.
