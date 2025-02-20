# function to save an R object into several zip files within a folder ending with .RDSX (.RDSX format)
# it uses p7zip (sudo apt install p7zip)
#size of each zip file in MB
# rdsx.file would be the name of the folder containing zip files
save_rdsx <- function(object, rdsx.file, size = 49, verbose = TRUE, path){
  
  # make path
  if (is.null(path)) path <- getwd()
  
  # set wd to new folder
  pth <- getwd()
  on.exit(setwd(pth), add = TRUE)
  
  
  setwd(path)
  
  # create folder if doesn't exists, if exists delete previous files (to avoid errors when rewriting)
  if (!dir.exists(rdsx.file))
    dir.create(rdsx.file) else unlink(list.files(pattern = "rdsx."))
  
  setwd(rdsx.file)
 
  
  # RDS file name
  rds_file <- gsub("\\.RDSX$", ".RDS",ignore.case = TRUE, rdsx.file)
  
  # save object as RDS in new folder
  if (verbose)
    message("saving temporary RDS")
  saveRDS(object, rds_file)
  
  # remove R object
  rm(object)
  
  # 7z -v6m a split.zip. t10XX.RDS
  cll <- paste0("7z -v", size, "M a rdsx.")
  
  # run call
  if (verbose)
    message("zipping files")
  
  system(cll)
  
  unlink(rds_file)  
}

##########################################################

# function to read .RDSX folders into an R object

read_rdsx <- function(rdsx.file, path, rm.rdsx = TRUE) {
  
  
  # make path
  if (is.null(path)) path <- getwd()
  
  # set wd to new folder
  pth <- getwd()
  on.exit(setwd(pth), add = TRUE)
  
  setwd(file.path(path, rdsx.file))
  
  rdsxs <- list.files(pattern = "rdsx") 
  
  # get name of first file to put it in call
  first_file <- sort(rdsxs)[1]
  #7za x rds.001
  
  # make call
  cll <- paste0("7za x ", first_file)  
  
  # run call
  system(cll)
  
  # read RDS
  output <- readRDS(gsub("\\.RDSX$", ".RDS", rdsx.file))
  
  # remove 
  unlink(rdsxs)
  
  return(output)      
  
  
}

## example
# object <- readRDS("test_10.RDS")
# 
# save_rdsx(object, rdsx.file = "t10XX.RDSX", size = 6, verbose =  TRUE)
# 
# obj2 <- read_rdsx(rdsx.file = "t10XX.RDSX")
# 
# identical(object, obj2)

##########################################################

# function to save an file into several zip files within a folder ending with .zipx (.zipx format)
# it uses p7zip (sudo apt install p7zip)
#size of each zip file in MB
# file is the name of the folder containing zip files
save_zipx <- function(file, path, size = 49, rm.file = TRUE){
  
  # make zipx folder name
  zipx.file <- paste0(file, ".zipx")
  
  # make path
  if (is.null(path)) path <- getwd()
  
  # set wd to new folder
  pth <- getwd()
  on.exit(setwd(pth), add = TRUE)
  setwd(file.path(path))
  
  # create folder if doesn't exists, if exists delete previous files (to avoid errors when rewriting)
  if (!dir.exists(zipx.file))
    dir.create(zipx.file)
  #else unlink(list.files(pattern = "rdsx."))
  
  # copy file
  message("copy temporary file")
  out <- file.copy(from = file, to  =  file.path(zipx.file, file))
  
  # set wd to new folder
  setwd(zipx.file)
  
  #make call i.e. 7z a output input
  cll <- paste0("7z -v", size, "M a zipx.")
  
  # run call
  message("zipping files")
  system(cll)
  
  # remove copy
  unlink(file)
  
  # remove original
  if (rm.file){
    setwd("..")
    unlink(file)
  }
    
  
}

##########################################################

# function to "unzip" a zipx file (.zipx format)
# it uses p7zip (sudo apt install p7zip)
# file is the name of the folder containing zip files
unzipx <- function(zipx.file, path, size = 49, rm.zipx = FALSE){
  
  # set wd to new folder
  pth <- getwd()
  on.exit(setwd(pth))
  setwd(file.path(path, zipx.file))
  
  zipxs <- list.files(pattern = "zipx") 
  
  # get name of first file to put it in call
  first_file <- sort(zipxs)[1]
  #7za x rds.001
  
  # make call
  cll <- paste0("7za x ", first_file)  
  
  # run call
  system(cll)
  
  # read RDS
  output <- file.copy(from = gsub("\\.zipx$", "", zipx.file), to = "..")
  
  unlink(gsub("\\.zipx$", "", zipx.file))
  
  if (rm.zipx){
    # remove folder
    unlink(list.files())
    
    setwd("..")
    file.remove(zipx.file)
  }
}

# # example
# save_zipx(file = "hum_MT_logcomb_reID.trees", path = "./data/raw/trees/", rm.file = TRUE)
# 
# unzipx(zipx.file = "hum_MT_logcomb_reID.trees.zipx", path = "./data/raw/trees/", rm.zipx = TRUE)

