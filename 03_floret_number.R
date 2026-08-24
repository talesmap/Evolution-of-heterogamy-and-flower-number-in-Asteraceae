#### ==========================================================================
#### 03_floret_number.R
#### Number of florets per capitulum: data preparation, phylogenetic signal,
#### evolutionary models (BM/EB/OU), and ancestral state estimation (fastAnc).
#### Requires objects from 01_prepare_data.R.
#### ==========================================================================

source("00_config.R")

red    <- readRDS(file.path(obj_dir, "red.rds"))
phycut <- readRDS(file.path(obj_dir, "phycut.rds"))

#### PHYLOGENETIC RECONSTRUCTIONS ----------- NUMBER OF FLORETS PER CAPITULUM ---

#### BUILDING A DATASET WITH A SINGLE FLORET-NUMBER VALUE PER SPECIES -----

flo <- red %>%
  dplyr::select(Susanna_2020, Subfamily, Tribe, Subtribe, Genus, Species, Capitula_structure,
                Florets_min, Florets_max,
                Ray_florets_min, Ray_florets_max,
                Disc_florets_min, Disc_florets_max)

flo <- flo %>%
  mutate(hom = ifelse(!is.na(Florets_max), Florets_max, Florets_min),
         ray = ifelse(!is.na(Ray_florets_max), Ray_florets_max,
                       Ray_florets_min),
         dis = ifelse(!is.na(Disc_florets_max), Disc_florets_max,
                       Disc_florets_min)) %>%
  mutate(het = ifelse(!is.na(ray) & !is.na(dis), ray + dis,
                       ifelse(is.na(dis), ray, dis))) %>%
  mutate(Floret = ifelse(!is.na(hom), hom, het))

floret <- flo %>%
  dplyr::select(Susanna_2020, Subfamily, Tribe, Subtribe, Genus,
                Species, Capitula_structure, Floret) %>%
  rename(Capitula = Capitula_structure, Group = Susanna_2020)

floret <- as.data.frame(floret)
rownames(floret) <- floret$Species

#### RECONSTRUCTING -----------------------------------------------------------

fl <- setNames(log10(floret$Floret), floret$Species)

##### phylogenetic signal --------------------------------------

phylosig(tree = phycut, x = setNames(log10(floret$Floret), floret$Species),
         method = "lambda", test = TRUE)

phylosig(tree = phycut, setNames(log10(floret$Floret), floret$Species),
         method = "K", test = TRUE, nsim = 1000)

##### evolutionary models ------------------------------

phy_bin <- multi2di(phycut)

bm <- fitContinuous(phy = phy_bin, dat = fl)
be <- fitContinuous(phy = phy_bin, dat = fl, model = "EB")
ou <- fitContinuous(phy = phy_bin, dat = fl, model = "OU")

aic <- setNames(c(AIC(bm), AIC(be), AIC(ou)),
                 c("BM", "EB", "OU"))
aic.w(aic)

phenogram(phy_bin, fl, ftype = "off",
          color = make.transparent("blue", 0.5),
          spread.cost = c(1, 0), cex.axis = 0.8,
          las = 1)

#### fastAnc: ancestral character estimation ---------------------------------

ace <- fastAnc(phycut, fl, vars = TRUE, CI = TRUE)

#### SAVING OBJECTS FOR THE NEXT STEPS ---------------------------

saveRDS(flo,    file.path(obj_dir, "flo.rds"))
saveRDS(floret, file.path(obj_dir, "floret.rds"))
saveRDS(fl,     file.path(obj_dir, "fl.rds"))
saveRDS(ace,    file.path(obj_dir, "ace.rds"))
