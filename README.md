# Bottom slope influence on flow and bedload transfer through contractions

This repository contains data used in ["Bottom slope influence on flow and bedload transfer through contractions"](https://doi.org/10.1080/00221686.2018.1454519).

The data stem from laboratory experiments with the setup described in my PhD thesis ([Schwindt 2017](https://infoscience.epfl.ch/record/229862/files/EPFL_TH7655.pdf?version=1)). Data processing was done with *Python* (see [pydroscape](https://sschwindt.github.io/pydroscape/)) and *Matlab* / *Octave* codes.

## Citation

Suggested citation:

*Schwindt, S.; Franca, M. J. & Schleiss, A. J. "Bottom slope influence on flow and bedload transfer through contractions". Journal of Hydraulic Research, 2018 , 57(2) , 197-210. doi: 10.1080/00221686.2018.1454519*

LaTex / Bibtex Users:

```
@Article{schwindt18b,
  author    = {Schwindt, Sebastian and Franca, M\'ario J and Schleiss, Anton J},
  title     = {Bottom slope influence on flow and bedload transfer through contractions},
  journal   = {Journal of Hydraulic Research},
  year      = {2018},
  volume    = {57},
  number    = {2},
  pages     = {197-210},
  doi       = {10.1080/00221686.2018.1454519},
  url       = {https://doi.org/10.1080/00221686.2018.1454519},
}

```

## Codes
 Signal processing was done with *Python* and the [pydroscape](https://sschwindt.github.io/pydroscape/)) package. The data analyses where made with *Matlab* / *Octave* (`.m`) codes, where codes starting with an `f[...].m` mark files containing functions. All other `.m` files are algorithms that use these functions. Please note that all codes were originally written in *Matlab* and processing them with *Octave* may require adding `pkg load io` after the `clear all; close all;` statements in the codes.

## Data structure

The data used in this paper incorporate the experiments used for the analyses in the paper ["Effects of lateral and vertical constrictions on flow in rough steep channels with bedload"](https://github.com/sschwindt/pub-constriction-bedload).

The **`RawData`** folder contains the raw data from the ultrasonic probe loggers, pump discharge logger, flow velocity (where applicable), sediment supply/outflow loggers, and constriction geometry. The `RawData/ExperimentOverview.xlsx` workbook contains overview tables of the conducted experiments.

The **`ProcessedData`** folder contains data that where extracted from the `RawData` folder. These data are stored in `ProcessedData/S_0_percent/ANALYSISTYPE/DataAcquisition/` and the *Matlab* / *Octave* (`.m`) codes in that folder were used for extracting / converting the raw data. The `ProcessedData/S_0_percent/ANALYSISTYPE/DataAcquisition/Exp_NNNNN.xls` workbooks document each experimental run, where the maximum bedload passage is highlighted. `ProcessedData/S_0_percent/ANALYSIS_TYPE/DataAcquisition/YYYYMMDD_data_ANALYSISTYPE.xlsx` summarizes all relevant experiments for an `ANALYSISTYPE` (i.e., Non-constricted, Lateral, Vertical, or Combined).

The summarizing folders **`00X_`** include data refering to the relative upstream water depth *h<sub>\*</sub>* (`hxcr`) and the Froude number (`Fr0`), which provides additional insights beyond the results discussed in the paper.

The **`ProcessedData/000_summary/`** folder contains two workbooks that summarize the experiments in the non-constricted and the constricted flume, as well as *Matlab* / *Octave* (`.m`) codes for data processing.

The **`ProcessedData/001_regression_analysis/`** folder contains *Matlab* / *Octave* (`.m`) codes for data regression (curves) shown in figures and tables. A workbook summarizes the calculated regression coefficients.

The **`ProcessedData/002_plots/`** folder contains *Matlab* / *Octave* (`.m`) codes for producing the plots (figures) for the paper.

