# Contributing

See https://github.com/containous/traefik/blob/master/CONTRIBUTING.md.

## Why a separated repository?

The goal is to have a Docker's official image,
which includes following instructions from
https://github.com/docker-library/official-images.

One of the key points is the combination of
https://github.com/docker-library/official-images#cacheability
and https://github.com/docker-library/official-images#security,
which makes a requirement to commit Træfik's binaries inside the repository.

Then, to avoid slowing down the main
[Træfik's repository](https://github.com/containous/traefik),
 a separated repository is required.

## Why committing the binaries?

* Reason 1: `FROM scratch` and `FROM microsoft/nanoserver`.
By using stripped and minimalistic base images,
we can not benefit from any capabilities as package managers,
or curl/wget/powershell commands to download binaries
from inside the built images
(Exception of the venerable `microsoft/nanoserver:sac2016` image).

* Reason 2: No support for Multi-stage builds
in the Docker's Library build system
(Ref. https://github.com/docker-library/official-images/issues/3383).
So using Multi-stage with a first image to download and a second
to author is not a possibility.

## Why no Git-LFS since we store binaries

Because of https://github.com/docker-library/official-images/issues/1095.

## How do you release?


### Step 1: Træfik release

The script `update.sh` is called with the Træfik's version to use
as argument:

```shell
bash ./update.sh v1.7.0-rc
```

This call is done by the main release process here:
https://github.com/containous/traefik/blob/master/script/deploy.sh#L21.

### Step 2: Pull Request to the official Docker Library

This step is done by an internal bot at Containous.
It is in charge of automating creation of Pull Requests against https://github.com/docker-library/official-images .

Example of automated Pull Request: https://github.com/docker-library/official-images/pull/4602 .

## More

[![Official Image Tests (alpine)](https://travis-ci.com/containous/traefik-library-image.svg?branch=master)](https://travis-ci.com/containous/traefik-library-image)
[![appveyor Build status](https://ci.appveyor.com/api/projects/status/ahndudkeca1g7qf8/branch/master?svg=true)](https://ci.appveyor.com/project/traefiker/traefik-library-image/branch/master)



