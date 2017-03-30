# Mar 2017
# MI
# this version modified from CDR3extractoR_V2.R by Benny Chain (UCL)

##### Pseudocode #####
# read in .dcrcdr3 files from directory
# for each file
# extract the CDR1 and CDR2 sequences
# print output to file.txt
# format:
# CDR1,CDR2,CDR3

# TO FIX:
# set chain name outside of for loop
# atm the script is downloading the fasta ref files each time it goes through a file
# change output file extension

# parent directory
path_to_files = "/Volumes/BF_MI_1/sorted-naive-memory/M37_n12/Translated_dcrcdr3/test"
# set pattern to specific filenames
# remove pattern parameter if alpha or beta files are in separate dirs
files <- list.files(path_to_files, pattern="alpha.*naive", full.names=T, recursive=F)

library(Biostrings)
link_to_github_fasta <- "https://raw.githubusercontent.com/innate2adaptive/Decombinator-Tags-FASTAs/master/"

# load ref file for CDR1 and CDR2 sequences
ref_cdr1 <- readAAStringSet("/Volumes/BF_MI_2/misc-scripts/human_TRV_CDR1.fasta", format="fasta", use.names=T)
ref_cdr2 <- readAAStringSet("/Volumes/BF_MI_2/misc-scripts/human_TRV_CDR2.fasta", format="fasta", use.names=T)

# define function
CDR3extract<-function(file=ids, chain, species) {
	
if (species == "human") {
AV_in<-paste(link_to_github_fasta,"human_extended_TRAV.fasta",sep="")
AV = readDNAStringSet(AV_in)
names_AV<-sapply(strsplit(names(AV),split="\\|"),function(x) x[2])
AJ_in<-paste(link_to_github_fasta,"human_extended_TRAJ.fasta",sep="")
AJ = readDNAStringSet(AJ_in)
names_AJ<-sapply(strsplit(names(AJ),split="\\|"),function(x) x[2])
BV_in<-paste(link_to_github_fasta,"human_extended_TRBV.fasta",sep="")
BV = readDNAStringSet(BV_in)
names_BV<-sapply(strsplit(names(BV),split="\\|"),function(x) x[2])
BJ_in<-paste(link_to_github_fasta,"human_extended_TRBJ.fasta",sep="")
BJ = readDNAStringSet(BJ_in)
names_BJ<-sapply(strsplit(names(BJ),split="\\|"),function(x) x[2])

#find positions of Cs in V regions
AV_Cs<-suppressWarnings(gregexpr("C",as.character(translate(AV))))
AV_C<-sapply(AV_Cs,max)
#the C in TRDV2*01 is the penultimate one
AV_C[46]<-92

#same for beta chains
BV_Cs<-suppressWarnings(gregexpr("C",as.character(translate(BV))))
BV_C<-sapply(BV_Cs,max)

#find  GXG in alpha J regions
lengths<-nchar(AJ)
AJ_sh<-subseq(AJ,start=(lengths - 48),end=(lengths - 1))
AJ_shaa<-as.character(translate(AJ_sh))
AJ_GXGs<-gregexpr("[F,W]G.G",AJ_shaa)
AJ_GXG<-sapply(AJ_GXGs,max)
#anomalous CDR3 motif in TRAJ16*0
AJ_GXG[7]<-6
AJ_GXG_e<-nchar(AJ_shaa)-AJ_GXG-3

#find F/WGXG in beta chains
lengths<-nchar(BJ)
BJ_sh<-subseq(BJ,start=(lengths - 45),end=(lengths))
BJ_shaa<-suppressWarnings(as.character(translate(BJ_sh)))
BJ_GXGs<-gregexpr("[F,W]G.G",BJ_shaa)
BJ_GXG<-sapply(BJ_GXGs,max)
BJ_GXG_e<-nchar(BJ_shaa)-BJ_GXG-3
    }


#MOUSE
#load V and J regions
if (species == "mouse") {
AV_in<-paste(link_to_github_fasta,"mouse_original_TRAV.fasta",sep="")
AV = readDNAStringSet(AV_in)
names_AV<-sapply(strsplit(names(AV),split="\\|"),function(x) x[2])
AJ_in<-paste(link_to_github_fasta,"mouse_original_TRAJ.fasta",sep="")
AJ = readDNAStringSet(AJ_in)
names_AJ<-sapply(strsplit(names(AJ),split="\\|"),function(x) x[2])
BV_in<-paste(link_to_github_fasta,"mouse_original_TRBV.fasta",sep="")
BV = readDNAStringSet(BV_in)
names_BV<-sapply(strsplit(names(BV),split="\\|"),function(x) x[2])
BJ_in<-paste(link_to_github_fasta,"mouse_original_TRBJ.fasta",sep="")
BJ = readDNAStringSet(BJ_in)
names_BJ<-sapply(strsplit(names(BJ),split="\\|"),function(x) x[2])

#find positions of Cs in V regions
AV_Cs<-gregexpr("C",as.character(translate(AV)))
AV_C<-sapply(AV_Cs,max)
nchar<-nchar(as.character(translate(AV)))
#substr(as.character(translate(AV)),AV_C,nchar)

#same for beta chains
BV_Cs<-gregexpr("C",as.character(translate(BV)))
BV_C<-sapply(BV_Cs,max)

#find  GXG in alpha J regions
lengths<-nchar(AJ)
AJ_sh<-subseq(AJ,start=(lengths - 48),end=(lengths - 1))
AJ_shaa<-as.character(translate(AJ_sh))
AJ_GXGs<-gregexpr("[F,W]G.G",AJ_shaa)
AJ_GXG<-sapply(AJ_GXGs,max)

#find GXG in beta chains
lengths<-nchar(BJ)
BJ_sh<-subseq(BJ,start=(lengths - 45),end=(lengths))
BJ_shaa<-as.character(translate(BJ_sh))
BJ_GXGs<-gregexpr("[F,W]G.G",BJ_shaa)
BJ_GXG<-sapply(BJ_GXGs,max)
BJ_GXG_e<-nchar(BJ_shaa)-BJ_GXG-3

    }
##################################################################################################
###################################################################################################
#now analyse the data file and obtain the full amino acid translation
#and also the CDR3 sequences
#file<-ids[t,]
if(chain=="alpha"){
  
  V<-subseq(AV[file [,1]+1],start=1,end=width(AV[file [,1]+1])-file[,3])
  J<-subseq(AJ[file [,2]+1],start=(file[,4]+1),end=width(AJ[file [,2]+1]))
  TCR_DNA<-paste(V,gsub("\\s","",file[,5]),J,sep="")
  TCR_AA<-suppressWarnings(translate(DNAStringSet(TCR_DNA)))
  ln<-nchar(TCR_AA)
  #check for out of frame
  inframe<-grep("[*]",TCR_AA,invert=TRUE)
  #check for C in right place
  cys_region<-substr(TCR_AA,75,max(AV_C))
  cys<-grep("C",cys_region)
  #check for FGXG or WGXG
  FGXG_region<-subseq(TCR_AA,start=(ln - 18),end=(ln - 5))
  FGXG<-grep("[F,W]G.G",FGXG_region)
  #missing CDR3 altogether (or has negative length)
  len_ch<-(width(TCR_AA) -  AJ_GXG_e[(file [,2]+1)])-AV_C[file [,1]+1] 
  CDR3_posl<-which(len_ch > 0)
  all<-intersect(inframe,intersect(cys,intersect(FGXG,CDR3_posl)))
  proportion<-length(all)/length(TCR_AA)
  CDR3<-subseq(TCR_AA[all],start=AV_C[file [all,1]+1],end=ln[all]-AJ_GXG_e[(file [all,2]+1)])
  V_names<-names_AV[file [,1]+1][all]
  J_names<-names_AJ[file [,2]+1][all]
                }

if(chain=="beta"){

  V<-subseq(BV[file [,1]+1],start=1,end=width(BV[file [,1]+1])-file[,3])
  J<-subseq(BJ[file [,2]+1],start=(file[,4]+1),end=width(BJ[file [,2]+1]))
  TCR_DNA<-paste(V,gsub("\\s","",file[,5]),J,sep="")
  TCR_AA<-suppressWarnings(translate(DNAStringSet(TCR_DNA)))
  ln<-nchar(TCR_AA)
  #check for out of frame
  inframe<-grep("[*]",TCR_AA,invert=TRUE)
  #check for C in right place
  cys_region<-substr(TCR_AA,80,max(BV_C))
  cys<-grep("C",cys_region)
  #check for FGXG or WGXG
  FGXG_region<-subseq(TCR_AA,start=(ln - 18),end=(ln - 5))
  FGXG<-grep("[F,W]G.G",FGXG_region)
  #missing CDR3 altogether
  len_ch<-(width(TCR_AA) -  BJ_GXG_e[(file [,2]+1)])-BV_C[file [,1]+1] 
  CDR3_posl<-which(len_ch > 0)
  all<-intersect(inframe,intersect(cys,intersect(FGXG,CDR3_posl)))
  proportion<-length(all)/length(TCR_AA)
  CDR3<-subseq(TCR_AA[all],start=BV_C[file [all,1]+1],end=ln[all]-BJ_GXG_e[(file [all,2]+1)])
  V_names<-names_BV[file [,1]+1][all]
  J_names<-names_AJ[file [,2]+1][all]
            }

a<-list(TCR_DNA,TCR_AA,CDR3,V_names,J_names,proportion,all)

}

##### Start #####

# edit chain parameter for alpha or beta
for (f in files){
	ids <- read.table(f, sep=",")
	# modify the 5th col of .dcrcdr3 file
	ids[,5] = sub(":.*", "", ids[,5])
	
	# assign variable to output from function
	output <- CDR3extract(file=ids, chain="alpha", species="human")

	# use values in all to get only productive TCR_AA
	prod_TCR_AA <- output[[2]][output[[7]],]

	# find the CDR3 substring in prod_TCR_AA
	# first convert the XStringSet to string
	CDR3_seq <- unlist(strsplit(toString(output[[3]]), split=", "))
	prod_TCR_AA_seq <- unlist(strsplit(toString(prod_TCR_AA), split=", "))
	
	# reformat the V names from input file to allow pattern matching
	V_names_pattern <- sub("\\*", "\\\\*", output[[4]])

	# extract CDR1 and 2 sequences for productive TCRs
	CDR1 <- unlist(lapply(V_names_pattern, function(i, ref_cdr=ref_cdr1) {
		index <- grep(i, names(ref_cdr))
		toString(ref_cdr[index])
	}))
	CDR2 <- unlist(lapply(V_names_pattern, function(i, ref_cdr=ref_cdr2) {
		index <- grep(i, names(ref_cdr))
		toString(ref_cdr[index])
	}))

	# write output to file
	# format:
	# CDR1,CDR2,CDR3
	
	file_name <- strsplit(f, "\\.")[[1]][1]
	
	cdr_out <- write.table(cbind(CDR1, CDR2, CDR3_seq), file=paste(file_name, ".txt", sep=""), sep=",", quote=F, row.names=F, col.names=F)
}
