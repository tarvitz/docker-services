GITLAB
======

.. contents::
    :local:
    :depth: 2

Abstract
--------
This docker-compose configuration to build and update gitlab instances purely running in docker containers, decomposed properly (each application runs in its own container).

Installation
------------

Download gitlab artifact
~~~~~~~~~~~~~~~~~~~~~~~~
Download gitlab artifact or use ``download-sources.sh`` script (uses wget to fetch gitlab artifact from official repositories)

.. code-block:: bash

    $ ./download-sources.sh 10.0.4

Build gitlab
~~~~~~~~~~~~
Building gitlab could be pretty difficult procedure and sometimes timecosting. New versions of gitlab could require some sophisticated steps. 
Running build process:

.. note:: 

    Building gitlab dependencies and static assets requires running redis instances
    which is simple to bind it with ``--add-host`` docker parameter.

.. code-block:: bash

    $ docker build --add-host="redis:127.0.0.1" -t nfox/gitlab-base -f Dockerfile .

Building Gitlab docker image
~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Base image has multiple build denendencies and such image have enomerous size in the end, to minify size of docker artifact for gitlab there's a ``gitlab`` docker image configuration that uses only runtime dependencies and gitlab application with built static assets.

Original Dockerfile uses ``nfox/gitlab-build`` docker image so if you build base image with another tag name please modify Dockerfile to proceed.

.. code-block:: bash

    #: building gitlab application with only runtime dependencies
    $ docker build -t nfox/gitlab -f Dockerfile .

Building service dependencies
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- ``gitlab-workhorse`` is a smart http reverse proxy written on go:
  .. code-block:: bash

      $ docker build -t nfox/gitlab-workhorse -f Dockerfile .
- ``nginx`` http reverse proxy you would probably want to use:
  .. code-block:: bash

      $ docker build -t nfox/gitlab-nginx -f Dockerfile .
- ``postgres`` by default base configuration uses postgres, so this configuration
  is also presented to run gitlab app out of box:
  .. code-block::

      $ docker build -t nfox/gitlab-postgres -f Dockerfile .

The only critical dependency you have to build is gitlab-workhorse cause it's "highly" coupled with gitlab service itself, other dependencies could be used outside or with slightly other configuration.

Configure
---------
To configure gitlab you require to modify gitlab's ``config/*`` files. The best way is to build new gitlab docker image with changed files represented in repository::

    - config/gitlab.yml
    - config/database.yml
    - config/rescue.yml
    - config/unicorn.rb

Running
-------
To run gitlab in a docker-compose environment you need to:

.. code-block:: bash

    $ docker-compose ups

Setup Database Migrations
~~~~~~~~~~~~~~~~~~~~~~~~~
Before accessing gitlab on its web interface you have to run initial database migrations:

.. code-block:: bash

    docker exec -it gitlab \
        bundle exec rake gitlab:setup \
            RAILS_ENV=production GITLAB_ROOT_PASSWORD=secret-password \
            GITLAB_ROOT_EMAIL=youremail@example.fake

If it's done now you can try to access your out-of-a-box installation on 8090 port (you can change it in ``docker-compose.yml`` file): http://localhost:8090/

Cleaning up
-----------
To clean everything you have (including data, logs, database, etc) simply run:

.. code-block:: bash

    docker-compose down --volumes
