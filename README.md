# G6_imageprocessing
ECE532 Project: FPGA accellerated image processing with handwritten digit recognition

## Table of Contents
* [Description](#description)
* [How to Use](#how-to-use)
* [Structure](#Structure)
* [Authors](#authors)
* [Acknowledgements](#acknowlegements)


## Description

This project uses the Nexys 4 DDR board to do image processing and handwritten digit recognition. For more detailed information, see the report: /doc/report.pdf

## How to use

Nexys 4 DDR board is required with VGA monitor attached to the VGA port, and the OV7670 VGA camera module connected to the PMOD 1 input.

Requires Vivado 2018.3. Download this reposirtory, and open the project file: /src/camera_dram_03_25.xpr using Vivado.  Update IP location in the settings to be the /IP directory in this repository.

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
