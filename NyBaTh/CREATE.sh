#!/bin/bash

/usr/texbin/pdflatex thesis
/usr/texbin/bibtex thesis
/usr/texbin/pdflatex thesis
/usr/texbin/pdflatex thesis
open thesis.pdf

echo "fertig"
