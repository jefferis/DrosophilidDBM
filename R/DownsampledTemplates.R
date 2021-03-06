#asymmetric template brains

# Dsimulans
###########

leaconfig$Dsim$IS1=file.path(leaconfig$rootdir,"Dsimulans",'DsimDBM/refbrain/DsimIS1.nrrd')
leaconfig$Dsim$IS1.2um=file.path(leaconfig$rootdir,"Dsimulans",'DsimDBM/refbrain/DsimIS1_2um.nrrd')
leaconfig$Dsim$IS1.4um=file.path(leaconfig$rootdir,"Dsimulans",'DsimDBM/refbrain/DsimIS1_4um.nrrd')
leaconfig$Dsim$male=file.path(leaconfig$rootdir,"Dsimulans",'DsimMale/refbrain/AAGX15-6-symmetric.nrrd')
leaconfig$Dsim$male.2um=file.path(leaconfig$rootdir,"Dsimulans",'DsimMale/refbrain/male2um.nrrd')

# make a downsampled template brain
NrrdResample(leaconfig$Dsim$IS1,leaconfig$Dsim$IS1.2um,voxdims=c(2,2,2))
NrrdResample(leaconfig$Dsim$male,leaconfig$Dsim$male.2um,voxdims=c(2,2,2))
# make a further downsampled template brain for bridging registrations
NrrdResample(leaconfig$Dsim$IS1,leaconfig$Dsim$IS1.4um,voxdims=c(4,4,4))
# use cmtk levelset tool to make a binary mask

leaconfig$Dsim$IS1.2um.mask=sub(".nrrd","_mask.nrrd",leaconfig$Dsim$IS1.2um)
CMTKLevelset(leaconfig$Dsim$IS1.2um,leaconfig$Dsim$IS1.2um.mask)

# D virilis
###########
leaconfig$Dvir$IS1=file.path(leaconfig$rootdir,"Dvirilis",'DvirDBM/refbrain/DvirIS1.nrrd')
leaconfig$Dvir$IS1.2um=file.path(leaconfig$rootdir,"Dvirilis",'DvirDBM/refbrain/DvirIS1_2um.nrrd')
leaconfig$Dvir$IS1.4um=file.path(leaconfig$rootdir,"Dvirilis",'DvirDBM/refbrain/DvirIS1_4um.nrrd')

# make a downsampled template brain
NrrdResample(leaconfig$Dvir$IS1,leaconfig$Dvir$IS1.2um,voxdims=c(2,2,2))
# make a further downsampled template brain for bridging regs
NrrdResample(leaconfig$Dvir$IS1,leaconfig$Dvir$IS1.4um,voxdims=c(4,4,4))
# use cmtk levelset tool to make a binary mask

leaconfig$Dvir$IS1.2um.mask=sub(".nrrd","_mask.nrrd",leaconfig$Dvir$IS1.2um)
CMTKLevelset(leaconfig$Dvir$IS1.2um,leaconfig$Dvir$IS1.2um.mask)

# D melanogaster
###########

leaconfig$Dmel$IS1=file.path(leaconfig$rootdir,"Dmelanogaster",'DmelIS/FBIS1.nrrd')
leaconfig$Dmel$IS1.2um=file.path(leaconfig$rootdir,"Dmelanogaster",'DmelIS/FBIS1_2um.nrrd')
leaconfig$Dmel$IS1.4um=file.path(leaconfig$rootdir,"Dmelanogaster",'DmelIS/FBIS1_4um.nrrd')

# make a downsampled template brain
NrrdResample(leaconfig$Dmel$IS1,leaconfig$Dmel$IS1.2um,voxdims=c(2,2,2))
# make a further downsampled template brain for bridging regs
NrrdResample(leaconfig$Dmel$IS1,leaconfig$Dmel$IS1.4um,voxdims=c(4,4,4))
# use cmtk levelset tool to make a binary mask

leaconfig$Dmel$IS1.2um.mask=sub(".nrrd","_mask.nrrd",leaconfig$Dmel$IS1.2um)
CMTKLevelset(leaconfig$Dmel$IS1.2um,leaconfig$Dmel$IS1.2um.mask)

# D yakuba 
# NB the data for this are not yet in the locations specified here (don't exist yet)
###########

leaconfig$Dyak$IS1=file.path(leaconfig$rootdir,"Dyakuba",'DyakIS/FBIS1.nrrd')
leaconfig$Dyak$IS1.2um=file.path(leaconfig$rootdir,"Dyakuba",'DyakIS/FBIS1_2um.nrrd')
leaconfig$Dyak$IS1.4um=file.path(leaconfig$rootdir,"Dyakuba",'DyakIS/FBIS1_4um.nrrd')

# make a downsampled template brain
NrrdResample(leaconfig$Dyak$IS1,leaconfig$Dyak$IS1.2um,voxdims=c(2,2,2))
# make a further downsampled template brain for bridging regs
NrrdResample(leaconfig$Dyak$IS1,leaconfig$Dyak$IS1.4um,voxdims=c(4,4,4))
# use cmtk levelset tool to make a binary mask

leaconfig$Dyak$IS1.2um.mask=sub(".nrrd","_mask.nrrd",leaconfig$Dyak$IS1.2um)
CMTKLevelset(leaconfig$Dyak$IS1.2um,leaconfig$Dyak$IS1.2um.mask)


