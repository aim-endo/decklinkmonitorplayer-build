# 1. build docker image

```shell
PASSWORD=(your_password) ./build.sh
```

# 2. run a container

```shell
DISPLAY=(your_display) ./run.sh
```

# 3. build monitor application in container

```shell
(in contiainer)
cd path/to/decklinkmonitorplayer
mkdir build && cd $_
qmake ..
bear -- make -j
```

# 4. execute monitor application in container

```shell
(in container)
./_bin/DeckLinkMonitorPlayer
```
