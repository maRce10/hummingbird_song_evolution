# prepare project to send to github

# list all files
fls <- list.files(recursive = TRUE, full.names = TRUE)

# size in MB
sizes <- round(file.size(fls) / 1048576, 2)

# put in data frame
df <- data.frame(dir = dirname(fls),  file = basename(fls), sizes, full.name = fls)

if (any(df$sizes > 99.9))
  df[df$sizes > 99.9, ] else print("all files are smaller than 100MB")

system("git add .")

system('git commit -m "add est all data by element 2"')

system("git push origin master")


source("./scripts/saveRDSX.R")


save_rdsx(est, rdsx.file = "extended_selection_table_hummingbirds_swifts_nightjars.RDSX", path = "./data/raw/")
# 
# 
# est <- read_rdsx(rdsx.file  = "extended_selection_table_hummingbirds_swifts_nightjars.RDSX", path = "./data/raw/")

