# Evolution-of-heterogamy-and-flower-number-in-Asteraceae

Here you find the codes used in our study. 

For any questions or requests, please contact me at tales.paiva@ifpb.edu.br


# Pipeline: phylogeny and capitulum structure in Asteraceae


1. `00_config.R` — packages and paths (update `data_dir`/`tree_file` here if
   the input files move). It is called automatically by the other scripts
   via `source()`, so you don't need to run it on its own.
2. `01_prepare_data.R` — reads the phylogeny and the spreadsheet, checks the
   overlap between them, generates `red` and `phycut`/`tree`.
3. `02_capitula_structure.R` — phylogenetic signal and ancestral
   reconstruction (simmap) of `Capitula_structure` (Homogamous x
   Heterogamous).
4. `03_floret_number.R` — prepares the number of florets per species,
   phylogenetic signal, evolutionary models (BM/EB/OU), and `fastAnc`.
5. `04_ggtree_plot.R` — plots the fan-shaped tree colored by floret number
   (ggtree) with bars (ggtreeExtra) → `fig2.tiff`.
6. `05_contmap_subtrees.R` — plot with `contMap` and subtrees for the
   Barnadesieae and Astereae tribes.
7. `06_plot_phylogeny.R` — plot the study phylogeny.

## Intermediate objects

Scripts 01 and 03 save objects to `intermediate_objects/*.rds`. This lets you
run 02, 04, or 05 without repeating the slow steps (`make.simmap`,
`fitContinuous`) — as long as 01 and 03 have already been run once.
