..
.. -*- coding: utf-8; tab-width: 4; c-basic-offset: 4; indent-tabs-mode: nil -*-

.. image:: https://travis-ci.org/tprrt/oe-build-easy.svg?branch=master
    :alt: Travis badge
    :target: https://travis-ci.org/tprrt/oe-build-easy

.. .. image:: https://circleci.com/gh/tprrt/oe-build-easy.png?style=shield&circle-token=8794b4eb585ada86a0521f8c215903faa223de40
.. image:: https://circleci.com/gh/tprrt/oe-build-easy/tree/master.svg?style=shield
    :alt: Circle badge
    :target: https://circleci.com/gh/tprrt/oe-build-easy

.. .. image:: https://coveralls.io/repos/tprrt/oe-build-easy/badge.png?branch=master
..     :alt: Coveralls badge
..     :target: https://coveralls.io/r/tprrt/oe-build-easy

.. .. image:: https://pypip.in/v/oe-build-easy/badge.png
..     :alt: PyPi badge
..     :target: https://pypi.python.org/pypi/oe-build-easy/

.. .. image:: https://pypip.in/d/oe-build-easy/badge.png
..     :alt: Download badge
..     :target: https://pypi.python.org/pypi/oe-build-easy/

.. .. image:: https://pypip.in/wheel/oe-build-easy/badge.png
..     :alt: Wheel badge
..     :target: https://pypi.python.org/pypi/oe-build-easy/

=============
oe-build-easy
=============

Description
-----------

A script to made easily an embedded Linux system with OpenEmbedded/Poky from scratch with a combo-layer configurations:

- Download combo-layer script
- Initialize repositories are defined in the combo-layer configuration
- Source the build environment
- Edit local.conf to update the build configuration (distro...)
- Edit bblayers.conf to add additional layers
- Run bitbake to build the target image

Usage
-----

::

    $ ./oe-build-easy --help
    Usage:
      oe-build-easy [options] CONFIG_PATH

    Options:
      -c, --compodir COMBO_PATH  Directory path of components
      -C, --combodir COMPO_PATH  Directory path of combination
      -i, --image IMAGE          Name of target image
      -m, --machine MACHINE      Name of target machine
      -d, --distro DISTRO        Name of distribution
      -b, --build PATH           Directory path of build
      -H, --history PATH         Directory path of buildhistory
      -p, --packages CLASSES     List of packaging formats to enable
      -o, --options OPTIONS      Additional BitBake's options

      -D, --debug  Print debug message
      -h, --help   Print usage message

Examples
--------

To build a distroless minimal image for qemux86 target:

::

    $ ./oe-build-easy ./examples/core.conf \
          --machine qemux86 \
          --image core-image-minimal

To build a Poky sato image for qemuarm target:

::

    $ TEMPLATECONF=meta-yocto/conf ./oe-build-easy ./examples/poky.conf \
          --machine qemuarm \
          --distro poky \
          --image core-image-sato

To do
-----

- Add additional parameters and options
- Add debug message
- Finish to add the support of combo-layer update
- Implement build-all and parse-all target in Makefile
- Check Makefile parameters

Known Issues
------------

- Can't build Tizen distribution, because oe-init-build-env is renamed to tizen-init-build-env

.. .. image:: ???
..     :alt: Bitdeli badge
..     :target: https://bitdeli.com/free
