#### ==========================================================================
#### 00_config.R
#### Packages and paths used by all scripts in the pipeline.
#### Run this script first (or let the other scripts call it via source()).
#### ==========================================================================

#### PACKAGES ------------------------

library(readxl)
library(tidyverse)
library(ape)
library(geiger)
library(sensiPhy)
library(nlme)
library(caper)
library(phytools)
library(ggtree)
library(ggtreeExtra)
library(colorspace)

#### PATHS -------------------------------------------------------------
## Update only here if the input files move.

data_dir  <- "C:/Users/tales/Dropbox/Doutorado/Dados"
data_file <- file.path(data_dir, "Literature_data.xlsx")
tree_file <- "ALLOTB.tre"

## Folder where each script saves/loads intermediate objects (.rds),
## so heavy steps (simmap, fitContinuous, etc.) don't need to be rerun.
obj_dir <- "intermediate_objects"
dir.create(obj_dir, showWarnings = FALSE)
