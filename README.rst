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

A script to made easily an embedded Linux system with OpenEmbedded/Poky from scratch with a combo-layer configurations.

 - download combo-layer script
 - initialize repositories definied in the combo-layer configuration
 - source the build environment
 - edit local.conf to update the build configuration (distro...)
 - edit bblayers.conf to add additional layers
 - run bitbake to build the target image

Usage examples
--------------

To build a distroless image for qemux86 target:

::

    $ ./oe-build-easy ./examples/core.conf qemux86 nodistro core-image-minimal

To build a Poky sato image for qemuarm target:

::

    $ TEMPLATECONF=meta-yocto/conf ./oe-build-easy ./examples/poky.conf qemuarm poky core-image-sato

To do
-----

 - Add additional parameters and options

Known Issues
------------

 - Can't build Tizen distribution, because oe-init-build-env renamed tizen-init-build-env

.. .. image:: ???
..     :alt: Bitdeli badge
..     :target: https://bitdeli.com/free
