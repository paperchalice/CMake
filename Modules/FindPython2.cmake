# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#[=======================================================================[.rst:
FindPython2
-----------

Find Python 2 interpreter, compiler and development environment (include
directories and libraries).

Three components are supported:

* ``Interpreter``: search for Python 2 interpreter
* ``Compiler``: search for Python 2 compiler. Only offered by IronPython.
* ``Development``: search for development artifacts (include directories and
  libraries)
* ``NumPy``: search for NumPy include directories.

If no ``COMPONENTS`` is specified, ``Interpreter`` is assumed.

To ensure consistent versions between components ``Interpreter``, ``Compiler``,
``Development`` and ``NumPy``, specify all components at the same time::

  find_package (Python2 COMPONENTS Interpreter Development)

This module looks only for version 2 of Python. This module can be used
concurrently with :module:`FindPython3` module to use both Python versions.

The :module:`FindPython` module can be used if Python version does not matter
for you.

.. note::

  If components ``Interpreter`` and ``Development`` are both specified, this
  module search only for interpreter with same platform architecture as the one
  defined by ``CMake`` configuration. This contraint does not apply if only
  ``Interpreter`` component is specified.

Imported Targets
^^^^^^^^^^^^^^^^

This module defines the following :ref:`Imported Targets <Imported Targets>`
(when :prop_gbl:`CMAKE_ROLE` is ``PROJECT``):

``Python2::Interpreter``
  Python 2 interpreter. Target defined if component ``Interpreter`` is found.
``Python2::Compiler``
  Python 2 compiler. Target defined if component ``Compiler`` is found.
``Python2::Python``
  Python 2 library for Python embedding. Target defined if component
  ``Development`` is found.
``Python2::Module``
  Python 2 library for Python module. Target defined if component
  ``Development`` is found.
``Python2::NumPy``
  NumPy library for Python 2. Target defined if component ``NumPy`` is found.

Result Variables
^^^^^^^^^^^^^^^^

This module will set the following variables in your project
(see :ref:`Standard Variable Names <CMake Developer Standard Variable Names>`):

``Python2_FOUND``
  System has the Python 2 requested components.
``Python2_Interpreter_FOUND``
  System has the Python 2 interpreter.
``Python2_EXECUTABLE``
  Path to the Python 2 interpreter.
``Python2_INTERPRETER_ID``
  A short string unique to the interpreter. Possible values include:
    * Python
    * ActivePython
    * Anaconda
    * Canopy
    * IronPython
``Python2_STDLIB``
  Standard platform independent installation directory.

  Information returned by
  ``distutils.sysconfig.get_python_lib(plat_specific=False,standard_lib=True)``.
``Python2_STDARCH``
  Standard platform dependent installation directory.

  Information returned by
  ``distutils.sysconfig.get_python_lib(plat_specific=True,standard_lib=True)``.
``Python2_SITELIB``
  Third-party platform independent installation directory.

  Information returned by
  ``distutils.sysconfig.get_python_lib(plat_specific=False,standard_lib=False)``.
``Python2_SITEARCH``
  Third-party platform dependent installation directory.

  Information returned by
  ``distutils.sysconfig.get_python_lib(plat_specific=True,standard_lib=False)``.
``Python2_Compiler_FOUND``
  System has the Python 2 compiler.
``Python2_COMPILER``
  Path to the Python 2 compiler. Only offered by IronPython.
``Python2_COMPILER_ID``
  A short string unique to the compiler. Possible values include:
    * IronPython
``Python2_Development_FOUND``
  System has the Python 2 development artifacts.
``Python2_INCLUDE_DIRS``
  The Python 2 include directories.
``Python2_LIBRARIES``
  The Python 2 libraries.
``Python2_LIBRARY_DIRS``
  The Python 2 library directories.
``Python2_RUNTIME_LIBRARY_DIRS``
  The Python 2 runtime library directories.
``Python2_VERSION``
  Python 2 version.
``Python2_VERSION_MAJOR``
  Python 2 major version.
``Python2_VERSION_MINOR``
  Python 2 minor version.
``Python2_VERSION_PATCH``
  Python 2 patch version.
``Python2_NumPy_FOUND``
  System has the NumPy.
``Python2_NumPy_INCLUDE_DIRS``
  The NumPy include directries.
``Python2_NumPy_VERSION``
  The NumPy version.

Hints
^^^^^

``Python2_ROOT_DIR``
  Define the root directory of a Python 2 installation.

``Python2_USE_STATIC_LIBS``
  * If not defined, search for shared libraries and static libraries in that
    order.
  * If set to TRUE, search **only** for static libraries.
  * If set to FALSE, search **only** for shared libraries.

``Python2_FIND_REGISTRY``
  On Windows the ``Python2_FIND_REGISTRY`` variable determine the order
  of preference between registry and environment variables.
  the ``Python2_FIND_REGISTRY`` variable can be set to empty or one of the
  following:

  * ``FIRST``: Try to use registry before environment variables.
    This is the default.
  * ``LAST``: Try to use registry after environment variables.
  * ``NEVER``: Never try to use registry.

``CMAKE_FIND_FRAMEWORK``
  On macOS the :variable:`CMAKE_FIND_FRAMEWORK` variable determine the order of
  preference between Apple-style and unix-style package components.

  .. note::

    Value ``ONLY`` is not supported so ``FIRST`` will be used instead.

``Python2_FIND_VIRTUALENV``
  This variable defines the handling of virtual environments. It is meaningfull
  only when a virtual environment is active (i.e. the ``activate`` script has
  been evaluated). In this case, it takes precedence over
  ``Python2_FIND_REGISTRY`` and ``CMAKE_FIND_FRAMEWORK`` variables.
  The ``Python2_FIND_VIRTUALENV`` variable can be set to empty or one of the
  following:

  * ``FIRST``: The virtual environment is used before any other standard
    paths to look-up for the interpreter. This is the default.
  * ``ONLY``: Only the virtual environment is used to look-up for the
    interpreter.
  * ``STANDARD``: The virtual environment is not used to look-up for the
    interpreter. In this case, variable ``Python2_FIND_REGISTRY`` (Windows)
    or ``CMAKE_FIND_FRAMEWORK`` (macOS) can be set with value ``LAST`` or
    ``NEVER`` to select preferably the interpreter from the virtual
    environment.

Commands
^^^^^^^^

This module defines the command ``Python_add_library`` (when
:prop_gbl:`CMAKE_ROLE` is ``PROJECT``), which has the same semantics as
:command:`add_library` and adds a dependency to target ``Python2::Python`` or,
when library type is ``MODULE``, to target ``Python2::Module`` and takes care
of Python module naming rules::

  Python2_add_library (my_module MODULE src1.cpp)

If library type is not specified, ``MODULE`` is assumed.
#]=======================================================================]


set (_PYTHON_PREFIX Python2)

set (_Python2_REQUIRED_VERSION_MAJOR 2)

include (${CMAKE_CURRENT_LIST_DIR}/FindPython/Support.cmake)

if (COMMAND __Python2_add_library)
  macro (Python2_add_library)
    __Python2_add_library (Python2 ${ARGV})
  endmacro()
endif()

unset (_PYTHON_PREFIX)
