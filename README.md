Folder and file summary:

 - `RawData/`
 - `ProcessedData/`
 - `ApplicationExample_Codes/`
 - `MountainRiverInventory.xlsx`

***

This repository contains data used in ["Analysis of mechanical-hydraulic deposition control measures"](http://www.sciencedirect.com/science/article/pii/S0169555X17302969).

The data stem from laboratory experiments with the setup described in my PhD thesis ([Schwindt 2017](https://infoscience.epfl.ch/record/229862/files/EPFL_TH7655.pdf?version=1)). Data processing was done with *Python* (see [pydroscape](https://sschwindt.github.io/pydroscape/)) and *Matlab* / *Octave* codes.

## Citation

Suggested citation:

*Schwindt, S.; Franca, M. J.; De Cesare, G. & Schleiss, A. J.
"Analysis of mechanical-hydraulic deposition control measures". 
Geomorphology, 2017, 295, 467-479. doi: 10.1016/j.geomorph.2017.07.020*

LaTex / Bibtex Users:

```
@Article{schwindt17a,
  author    = {Schwindt, S and Franca, M J and {De Cesare}, G and Schleiss, A J},
  title     = {Analysis of mechanical-hydraulic deposition control measures},
  journal   = {Geomorphology},
  year      = {2017},
  volume    = {295},
  number    = {{upplement C},
  pages     = {467-479},
  issn      = {0169-555X},
  doi       = {10.1016/j.geomorph.2017.07.020},
  keywords  = {Bedload, check dam, Sediment flushing, sediment trap, self-emptying},
  owner     = {schwindt},
  timestamp = {2017.02.23},
  url       = {http://www.sciencedirect.com/science/article/pii/S0169555X17302969},
}

```

## Codes
 Signal processing was done with *Python* and the [pydroscape](https://sschwindt.github.io/pydroscape/)) package. The data analyses where made with *Matlab* / *Octave* (`.m`) codes, where codes starting with an `f[...].m` mark files containing functions. All other `.m` files are algorithms that use these functions. Please note that all codes were originally written in *Matlab* and processing them with *Octave* may require adding `pkg load io` after the `clear all; close all;` statements in the codes.

## Data structure and codes

The data used in this paper incorporate the experiments used for the analyses in the paper ["Effects of lateral and vertical constrictions on flow in rough steep channels with bedload"](https://github.com/sschwindt/pub-constriction-bedload).

The **`RawData/`** folder contains the raw data from the ultrasonic probe loggers, pump discharge logger, flow velocity (where applicable), sediment supply/outflow loggers, and constriction geometry. The `RawData/ExperimentOverview.xlsx` workbook contains overview tables of the conducted experiments.

The **`ProcessedData/`** folder contains data that where extracted from the `RawData/` folder. *Matlab* / *Octave* (`.m`) codes in that folder were used for extracting / converting the raw data.

The **`ProcessedData/000_data_summary/`** folder contains *Matlab* / *Octave* (`.m`) codes that created workbooks documenting spillway overflow and orifice clogging / flushing with both control mechanisms (hydraulic and mechanic, **summary files are highlighted**):

 - `20161029_no-overflow_5_5_percent.xlsx` contains experiment series that document sediment passage ;&Phi with varying discharge through the orifice of a (theoretically) infinitely high barrier (bottom slope = 5.5\%, hydraulic control only).
 - `20161029_unsteady.xlsx` contains the raw data of sediment passage ;&Phi with varying discharge through the orifice of a (theoretically) infinitely high barrier (bottom slopes of 3.5\% and 5.5\%, hydraulic control only).
 - **`20161123_overflown-spillway_5_5_percent.xlsx`** contains experiment series that document sediment passage ;&Phi with varying discharge through the orifice of an overflown barrier with spillway (bottom slope = 5.5\%, hydraulic control only).
 - `20161123_unsteady_spillway.xlsx` contains the dimensional data used in `20161123_overflown-spillway_5_5_percent.xlsx`.
 - **`20161208_orifice_clogging.xlsx`** document the sediment passage *Q<sub>bo</sub>* through mechanical and hydraulic controls at /in the overflown barrier.
 - `20161208_summary_blockage_comb.xlsx` documents finding the optimum bottom clearance for combined hydraulic-mechanical controls.
 - `20161211_summary_blockage_f.xlsx` documents finding the optimum bottom clearance  of mechanical control.
 - **`blockage_probability.xlsx`** documents the sediment passage with variable sediment supply. This is not a summary table though, but highlighted here because it contains more information than explored in the paper. These information may be valuable for other studies.
 - `Exp_NNNNN_[...].xlsx` are the experimental summary files resulting from the `RawData/`

The **`ProcessedData/001_regression_analysis/`** folder contains workbooks and  *Matlab* / *Octave* (`.m`) codes for data regression (curves) shown in figures and tables. The workbooks explore multiple regression pairs beyond the ones shown in the paper.

The **`ProcessedData/002_plots/`** folder contains *Matlab* / *Octave* (`.m`) codes for producing the plots (figures) for the paper.

