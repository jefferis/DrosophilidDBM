CMTKLevelset<-function(fin,fout,args='--binarize --levelset-threshold 2',...){
	cmd=paste("levelset",args,shQuote(fin),shQuote(fout))
	something_happened=RunCmdForNewerInput(cmd,fin,fout,...)
	return(fout)
}


#' Calculate Jacobian determinants for a given registration
#'
#' If fout refers to a directory then a default output filename
#' will be generated. e.g.:
#' if reg is /path/to/some/regs/myreg.list
#' and fout is /some/other/path/jacs
#' /some/other/path/jacs/myreg_jac.nrrd
#' Note that reg can be passed _more_ than one registration
#' in which these will be concatenated
CMTKJacobian<-function(target,reg,fout,args='',targetIsMask=TRUE,...){
	#if(missing(fout)) fout=sub("\\.list$","_jac.nrrd",basename(reg))
	if(length(fout)==1 && file.info(fout)$isdir){
		# if reg is /path/to/some/regs/myreg.list
		# and fout is /some/other/path/jacs
		# /some/other/path/jacs/myreg_jac.nrrd
		fout=file.path(fout,sub("\\.list$","_jac.nrrd",basename(reg[1])))
	}
	if(targetIsMask) args=paste(args,"--mask")
	regs=paste(shQuote(reg),collapse=' ')
	cmd=paste("reformatx","--outfile",shQuote(fout),args,shQuote(target), "--jacobian",regs)
	something_happened=RunCmdForNewerInput(cmd,c(reg,target),fout,...)
	return(fout)
}
#' Compute t test for two groups of jacobian determinants
#'
#' note it is nearly always a good idea to log transform jacobians
CMTKTtest<-function(group1,group2,out.stem,mask=NULL,log=TRUE,args='',...){
	if(log) args=paste(args,'--log')
	if(!is.null(mask)) args=paste(args,"--mask",shQuote(mask))
	
	pgroup1=paste(shQuote(group1),collapse=" ")
	pgroup2=paste(shQuote(group2),collapse=" ")

	# p values and t statistics
	out.pvals=paste(out.stem,sep="-",'pvals.nrrd')
	out.tvals=paste(out.stem,sep="-",'tvals.nrrd')
	
	cmd=paste("ttest",args,"--outfile",shQuote(out.pvals),
		"--tstats-file",shQuote(out.tvals),
		pgroup1,"--",pgroup2)
	something_happened=RunCmdForNewerInput(cmd,c(group1,group2,mask),c(out.tvals,out.pvals),...)
	return(c(out.pvals=out.pvals,out.tvals=out.tvals))
}

#' Zap non finite values in a nrrd (replacing with NA by default)
#'
#' 
NrrdZapInfinites<-function(infile,outfile=NULL,replacement=NA,gzip=TRUE,
	output=c('update','always'),DryRun=FALSE,...){
	cmd=ifelse(gzip,"NRRD_DEFAULT_WRITE_ENCODING_TYPE=gz","")
	if(is.na(replacement)) replacement='NaN'
	output=match.arg(output)
	if(is.null(outfile)){
		outfile=sub("(\\.[^.]+)",'-NA\\1',infile)
	} else if(file.info(outfile)$isdir){
		outfile=file.path(outfile,basename(infile))
	}
	cmd=paste(cmd,'unu 2op exists',shQuote(infile),replacement,'-o',shQuote(outfile))
	if(DryRun) return(cmd)
	if(output=='update') something_happened=RunCmdForNewerInput(cmd,infile,outfile,...)
	else success=system(cmd)
	return(outfile)
}

#' Compute t values for permuted groups (to establish null distribution)
CMTKTtest.Perm<-function(group1,group2,quantiles=c(0,0.001,0.01,0.05,0.1,0.5,0.9,.95,.99,.999,1),...){
	both=c(group1,group2)
	fakemales=sample(both,length(group1))
	fakefemales=setdiff(both,fakemales)
	tempstem=tempfile()
	# run one fake t test
	rvals=CMTKTtest(fakemales,fakefemales,
		out.stem=tempstem,...)
	# read in t values
	tvals.fake=Read3DDensityFromNrrd(rvals['out.tvals'])
	# clean up output files
	unlink(c(rvals['out.tvals'],rvals['out.pvals']))
	# remove infinite values
	tvals.fake[!is.finite(tvals.fake)]=NA
	# calculate our preferred quantiles
	quantile(tvals.fake,quantiles,na.rm=T)
}

NeuropilStats<-function(jacsfile,mask,masklabels,...){
	fout=paste(jacsfile,sep="","-",basename(mask),'.rds')
	update_required=RunCmdForNewerInput(NULL,c(jacsfile,mask),fout,...)
	if(update_required){
		stats=CMTKStatistics(jacsfile,mask,...)
		rownames(stats)=names(masklabels)[stats$MaskLevel+1]
		saveRDS(stats,file=fout)
	} else {
		stats=readRDS(fout)
	}
	return(stats)
}

#' Take a single slice from 3d density, keeping physical dimensions
slice.gjdens<-function(x,slice,slicedim='z'){
	ndims=length(dim(x))
    if(is.character(slicedim)){
        slicedim=tolower(slicedim)
        slicedim=which(letters==slicedim)-which(letters=="x")+1
    }
	if(ndims<3) {
		stop("3D arrays only in slice.gjdens - no z axis in array")
	}
	if(slicedim!=3) stop("I only know how to return xy slices")
	rval=x[,,slice]
	attributeNamesToCopy=setdiff(names(attributes(x)),names(attributes(rval)))
    attributes(rval)=c(attributes(rval),attributes(x)[attributeNamesToCopy])
	# ... and set the SliceDim to the correct letter
	sliceDimChar=letters[23+slicedim]
    attr(rval,'SliceDim')=if(!is.na(sliceDimChar)) sliceDimChar else slicedim
    rval
}
