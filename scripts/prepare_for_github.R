# prepare project to send to github

# list all files
fls <- list.files(recursive = TRUE, full.names = TRUE)

# size in MB
sizes <- round(file.size(fls) / 1048576, 2)

# put in data frame
df <- data.frame(dir = dirname(fls),  file = basename(fls), sizes, full.name = fls, stringsAsFactors = FALSE)

if (any(df$sizes > 99.9))
  df[df$sizes > 99.9, ] else print("all files are smaller than 100MB")

# add them to gitignore
if (any(df$sizes > 99.9)) {
  print('adding large files to .gitignore')
  
 gi <- readLines(".gitignore")
 gi <- c(gi, df$full.name[df$sizes > 99.9])
  
 writeLines(text = gi, con = ".gitignore")
}


# push to github

system("git add .")

system('git commit -m "brachwise rates rmd"')

system("git push origin master")

  source("./scripts/saveRDSX.R")

# save_rdsx(est, rdsx.file = "extended_selection_table_hummingbirds_swifts_nightjars.RDSX", path = "./data/raw/")
# 
# 
# est <- read_rdsx(rdsx.file  = "extended_selection_table_hummingbirds_swifts_nightjars.RDSX", path = "./data/raw/")

