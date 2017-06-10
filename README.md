# README

To start, you must have docker:

## Build image

```
docker build -t coboleiro .
```

## Run bash into container to compile stuff:

```
docker run -it -v $(YOUR_PROJECT_HOME):/project coboleiro /bin/bash
```

## Compile free form:

```
docker run -it -v $(YOUR_PROJECT_HOME):/project coboleiro cobc -free /project/file
```
