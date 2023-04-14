# G6_imageprocessing
ECE532 Project: FPGA accellerated image processing with handwritten digit recognition

## Table of Contents
* [Description](#description)
* [How to Use](#how-to-use)
* [Structure](#Structure)
* [Authors](#authors)
* [Acknowledgements](#acknowlegements)


## Description

This project uses the Nexys 4 DDR board to do image processing and handwritten digit recognition. For more detailed information, see the report: /doc/report.pdf and video: /doc/video.mp4

## How to use

Requires Vivado 2018.3. Download this reposirtory, and open the project file: /src/.xpr. Update IP location in the settings to be the /IP directory in this repository. 

## Structure

/doc
- documentation on the project

/src 
- project source files

/IP
- custom IP block source files

## Authors
- Richard Barrie
- Savo Bajic
- Xiaonong Sun (Frank)
- Chun Yin Au Yeung (Cyrus)

## Acknowledgements

We used the a modified version of the SCCB camera configuration code found here: https://github.com/westonb/OV7670-Verilog
