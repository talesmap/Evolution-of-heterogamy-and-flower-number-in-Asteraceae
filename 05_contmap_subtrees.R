#### ==========================================================================
#### 05_contmap_subtrees.R
#### Plot with contMap (continuous character mapping), identification of
#### reference MRCAs, and phylogeny subsetting for specific tribes.
#### Requires objects from 01_prepare_data.R and 03_floret_number.R.
#### ==========================================================================

source("00_config.R")

phycut <- readRDS(file.path(obj_dir, "phycut.rds"))
floret <- readRDS(file.path(obj_dir, "floret.rds"))
fl     <- readRDS(file.path(obj_dir, "fl.rds"))
ace    <- readRDS(file.path(obj_dir, "ace.rds"))

#### PLOTTING WITH CONTMAP: continuous character mapping --------------------

cmap <- contMap(tree = phycut, x = fl, plot = FALSE, lims = c(min(fl), max(fl)))

cmap <- setMap(cmap, diverge_hcl(n = 5, palette = "Green-Orange"))

plot(cmap, type = "fan", ftype = "off",
     leg.txt = "Flowers per\ncapitulum (log10)", fsize = c(0.7),
     legend = 50)

ast_mrca <- getMRCA(phy = cmap$tree, tip = c("Chresta_sphaerocephala",
                                              "Dasyphyllum_weberbaueri"))
cal_mrca <- getMRCA(phy = cmap$tree, tip = c("Chresta_sphaerocephala",
                                              "Boopis_necronensis"))
men_mrca <- getMRCA(phy = cmap$tree, tip = c("Chresta_sphaerocephala",
                                              "Menyanthes_trifoliata"))

nodelabels(node = c(ast_mrca, cal_mrca, men_mrca),
           pch = c(15, 16, 17), cex = 2)

#### number of florets per capitulum for asteraceae, calyc, and menyan -------

ast_est <- 10 ^ (ace$ace[4])
cal_est <- 10 ^ (ace$ace[3])
men_est <- 10 ^ (ace$ace[1])

##### SUBSETTING THE PHYLOGENY INTO SMALLER GROUPS -------------------------------------------------------

#### Barnadesieae tribe ------- the most basal -----------------------------

bar_tips <- subset(floret, Tribe == "Barnadesieae")

bar_tree <- keep.tip.contMap(cmap, bar_tips$Species)

plot(bar_tree, fsize = c(0.7, 1), ftype = "off")

#### Astereae tribe ------- one of the most derived ------------------------

ant_tips <- subset(floret, Tribe == "Astereae")

ant_tree <- keep.tip.contMap(cmap, ant_tips$Species)

plot(ant_tree, fsize = c(0.7, 1), ftype = "off")
