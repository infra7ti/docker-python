# Python docker images

***Base Docker images for python releases***
***

## Quick reference

### Supported Tags

#### Simple Tags

* Debian 12 (Book Worm): 
    - 3.12.0-bookworm, 3.12-bookworm
    - 3.11.6-bookworm, 3.11-bookworm
    - 3.10.13-bookworm, 3.10-bookworm
    - 3.9.18-bookworm, 3.9-bookworm
    - 3.8.18-bookworm, 3.8-bookworm
    - 2.7.18-bookworm¹, 2.7-bookworm¹

* Ubuntu 22.04 LTS (Jammy Jellyfish):
    - 3.12.0-jammy, 3.12-jammy
    - 3.11.6-jammy, 3.11-jammy
    - 3.10.13-jammy, 3.10-jammy
    - 3.9.18-jammy, 3.9-jammy
    - 3.8.18-jammy, 3.8-jammy
    - 2.7.18-jammy¹, 2.7-jammy¹

#### Shared Tags

* 3.12.0, 3.12, 3, latest: 3.12.0-bookworm
* 3.11.6, 3.11: 3.11.6-bookworm
* 3.10.13, 3.10: 3.10.13-bookworm
* 3.9.18, 3.9: 3.9.18-bookworm
* 3.8.18, 3.8: 3.8.18-bookworm
* 2.7.18¹, 2.7¹: 2.7.18-bookworm¹


> ¹ Python 2.7 is EOL. We built it only to support legacy projects migrating
to newer versions. Please, be carefull when using this image - it's unsecure.

### Supported architetures

* 64-bit x86 (AMD/Intel): amd64, x86_64, x86
* 64-bit ARM: arm64, arm64v8, aarch64

---

## What is Python

Python is an interpreted, interactive, object-oriented, open-source programming
language. It incorporates modules, exceptions, dynamic typing, very high level
dynamic data types, and classes. Python combines remarkable power with very 
clear syntax. It has interfaces to many system calls and libraries, as well as
to various window systems, and is extensible in C or C++. It is also usable as
an extension language for applications that need a programmable interface.
Finally, Python is portable: it runs on many Unix variants, on the Mac, and on
Windows 2000 and later.

> source: [wikipedia.org/wiki/Python_(programming_language)](
    https://wikipedia.org/wiki/Python_(programming_language
)

![](https://raw.githubusercontent.com/docker-library/docs/01c12653951b2fe592c1f93a13b4e289ada0e3a1/python/logo.png)

## Why to use this image

The official docker images for Python are great, but they are bloated. 
Therefore, we have simplified the Dockerfile and the process of building these
images so that we can build an image for any version of Python on any supported
distribution without any sacrifice in source code handling and/or without any or
minimal changes to the Dockerfiles.

We chose to build Python containers based only on the latest versions of Debian
stable and Ubuntu LTS. Support for other base images will be added in the
future, but we decided to abandon the Alpine build because the Python built on
_musl libc_ leads to major problems for a large number of projects.

## How to use this image

### Create a ```Dockerfile``` for your Python project

```Dockerfile
FROM infra7/python:3.11

COPY requirements.txt /usr/src/app/

WORKDIR /usr/src/app
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python", "./app.py"]

```

Now, you can build and run your Docker image:

```bash
$ docker buildx build -t my-app .
$ docker run --rm -it -name my-app my-app
```

### Run a single Python script

To run a simple script or a single-file project, there is no need to write a 
full Dockerfile. In such cases, you can run a Python script using the Python 
Docker image directly:

```bash
$ docker run --rm -it --name my-script -v "${PWD}":/usr/src/myapp -w /usr/src/myapp python:3 python my-script.py
```

## Image Variants

Our ```python``` images are bought to you in many flavours, each of them
designed for a specific use case.

```infra7/python:<version>```

This is the actual image. If you're not sure what your needs are, you should
probably use it. It is designed to be used both as a disposable container
(assemble your source code and launch the container to launch your application)
as well as a base for building other images.

Some of these tags may have names like bookworm or jammy. These are the 
codenames of the sets for versions (of GNU/Linux distributions) of Debian or 
Ubuntu and indicate which OS version the image was based on. If your image 
needs to install any additional packages beyond those that come with the image,
you will probably want to specify one of these explicitly to minimize breakages
when there are new releases of the distribution.

This image does not contain the common packages contained in the default tag 
and _only_ contains the minimum packages required to run python. It was built
only with GNU/Linux bases, as this is the focus of Infra7's development. It
aims to be a basis for developing Docker images suitable for your application.
Then your built image will be lightweight and quick to deploy.

## More information

For more information, licensing, bug-reports and discussions, visit our project
at GitHub: [infra7ti/docker-python](https://github.com/infra7ti/docker-python)

---
