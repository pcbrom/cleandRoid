# DO AT YOUR OWN RISK
# MAY BE REQUIRED TO REBOOT THE MOBILE PHONE AFTER CLEANING
# TESTED ONLY IN GNU/LINUX

library(tidyverse)
library(lubridate)

path <- paste0('/run/user/1000/gvfs/mtp', gsub( '.*mtp', '', system('ls -ltr /run/user/1000/gvfs', intern = T)[2]))
location <- list.dirs(path)


# whatsapp --------------------------------------------------------------------

whats <- location[grepl("(W|w)hats", location)]
for (i in 1:length(whats)) {
  tmp <- list.files(whats[i], recursive = T)
  delme <- paste0(whats[i], "/", tmp[grepl("(\\.mp4|\\.opus|\\.jpg|\\.jpeg|\\.pdf)$", tmp)])
  lapply(delme, file.remove)
  print(whats[i])
}

today <- Sys.Date()
for (i in 1:length(whats)) {
  tmp <- list.files(whats[i], recursive = T)
  delme <- paste0(whats[i], "/", tmp[grepl("msgstore", tmp)]) %>% 
    enframe() %>% 
    mutate(data = value %>% 
             str_extract("[0-9]{4}-[0-9]{2}-[0-9]{2}") %>% 
             ymd(),
           tempo = today - data) %>% 
    na.omit() %>% 
    filter(tempo > min(tempo))
  lapply(delme$value, file.remove) 
  print(whats[i])
}


# cache -----------------------------------------------------------------------

cache <- location[grepl("(C|c)ache", location)]
tmp <- sapply(cache, function(x) list.files(x, full.names = T)) %>% 
  unlist() %>% 
  str_subset('(\\.[a-z]{3,5})$')
lapply(tmp, file.remove)


# thumbnails ------------------------------------------------------------------

thumb <- location[grepl("\\.thumbnails", location)]
tmp <- sapply(thumb, function(x) list.files(x, full.names = T)) %>% 
  unlist() %>% 
  str_subset('(\\.[a-z]{3,5})$')
lapply(tmp, file.remove)


# downloads -------------------------------------------------------------------

down <- location[grepl("(D|d)ownload", location)]
for (i in 1:length(down)) {
  tmp <- list.files(down[i], recursive = T)
  delme <- paste0(down[i], "/", tmp[grepl("(\\.mp4|\\.opus|\\.jpg|\\.jpeg|\\.pdf)$", tmp)])
  lapply(delme, file.remove)
  print(down[i])
}


# camscanner ------------------------------------------------------------------

camscanner <- location[grepl("CamScanner", location)]
for (i in 1:length(camscanner)) {
  tmp <- list.files(camscanner[i], recursive = T)
  delme <- paste0(camscanner[i], "/", tmp[grepl("(\\.pdf)$", tmp)])
  lapply(delme, file.remove)
  print(camscanner[i])
}
