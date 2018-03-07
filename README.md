# StateSpaceModels.jl

| **DOI** | **Build Status** |
|:-----------------:|:-----------------:|
| [![DOI](https://zenodo.org/badge/117544868.svg)](https://zenodo.org/badge/latestdoi/117544868) | [![Build Status][build-img]][build-url] |

## Installation
This package is unregistered so you will need to `Pkg.clone` it as follows:
```julia
Pkg.clone("https://github.com/LAMPSPUC/StateSpaceModels.jl.git")
```

## Notes

This package is under development and some features may be changed or added.

StateSpaceModels.jl is a package for modeling, forecasting and simulating time series in a state space framework.

Estimation is done through function `statespace` and will automatically be run in parallel with all the currently active threads.

Simulation of future scenarios is done through function `simulate_statespace`.

## Features

Current features:
* Basic structural model (level, slope, seasonal)
* Exogenous variables
* Square-root Kalman Filter and smoother
* Big Kappa initialization
* Monte Carlo simulation
* Parallel MLE estimation

Future features (work in progress):
* User-defined model
* Cycles
* Forecasting and confidence intervals
* Missing values completion
* Structural break
* Exact initialization

[build-img]: https://travis-ci.org/LAMPSPUC/StateSpaceModels.jl.svg?branch=master
[build-url]: https://travis-ci.org/LAMPSPUC/StateSpaceModels.jl

