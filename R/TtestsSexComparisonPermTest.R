# NB Pipeline must be run first to set up variables
# source("RunPipeline.R", chdir = TRUE)

# Dsimulans
###########

outfile=file.path(leaconfig$datadir,'DsimSexPerms.rda')

leaconfig$Dsim$IS1.stats=file.path(leaconfig$rootdir,"Dsimulans",'DsimDBM/stats')
if(!file.exists(leaconfig$Dsim$IS1.stats))
	dir.create(leaconfig$Dsim$IS1.stats)

# load spreadsheet with sexes

leaconfig$Dsim$brains=read.table(file.path(leaconfig$rootdir,"db",'DsimBrains.txt'),header=T)
rownames(leaconfig$Dsim$brains)=leaconfig$Dsim$brains$brain

# list the full path to jacobians
leaconfig$Dsim$IS1.jacfiles=dir(leaconfig$Dsim$IS1.jacs,full=T)
# figure out sex for each one
leaconfig$Dsim$IS1.jacfiles.sex=leaconfig$Dsim$brains[brain_from_path(leaconfig$Dsim$IS1.jacfiles),'sex']

# Barf if we couldn't figure out the sex of one of the brains
stopifnot(all(!is.na(leaconfig$Dsim$IS1.jacfiles.sex)))

if(RunCmdForNewerInput(NULL,leaconfig$Dsim$IS1.jacfiles,outfile,...)){
	# we have some work to do
	set.seed(42)
	results=replicate(2,CMTKTtest.Perm(leaconfig$Dsim$IS1.jacfiles[leaconfig$Dsim$IS1.jacfiles.sex=='M'],
		leaconfig$Dsim$IS1.jacfiles[leaconfig$Dsim$IS1.jacfiles.sex=='F'],
		mask=leaconfig$Dsim$IS1.2um.mask))
	save(results,file=outfile)
}
