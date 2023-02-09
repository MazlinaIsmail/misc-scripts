# plot copy number scatter plots

# load library
library(ggplot2)
library(ggrepel)

# prefix to path
dir_name <- '~/Desktop/scratch/plotting-with-KN/AI/'
# load single patient file
ai_dat <- read.table(paste(dir_name, 'TR017.AI.txt', sep=''), header=T, sep='\t', fill=T)
# check data
head(ai_dat)
dim(ai_dat)
summary(ai_dat)
unique(ai_dat$COMPOSITE_ID)
unique(ai_dat$SAMPLE_TYPE)
# exclude plasma samples
ai_dat_tissue <- ai_dat[grep('^20', ai_dat$COMPOSITE_ID, invert=T),]
unique(ai_dat_tissue$COMPOSITE_ID)
table(ai_dat_tissue$COMPOSITE_ID)
# subset single met (for eg)
met <- ai_dat_tissue[ai_dat_tissue$COMPOSITE_ID == 'Liver_Right_Lobe_12_1',]
nrow(met)
as.matrix(colnames(met))
# plot single met copy number a vs bsw
ggplot(met, aes(x=cnA, y=cnB, label=GENE)) + geom_point() + theme_bw() + geom_abline(alpha=0.2) + scale_y_continuous(limits=c(0, 4)) + scale_x_continuous(limits=c(0, 4))







