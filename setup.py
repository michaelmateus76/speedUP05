from distutils.core import setup, Extension
from Cython.Build import cythonize

exts=(cythonize('Cy_simulador.pyx'))

setup(ext_modules = exts)