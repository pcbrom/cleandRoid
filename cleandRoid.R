library(tidyverse)
library(lubridate)

endereco <- "/run/user/1000/gvfs/mtp:host=MediaTek_Wieppo_S5_0123456789ABCDEF"
locais <- list.dirs(endereco)

# faxina no whats -------------------------------------------------------------

whats <- locais[grepl("(W|w)hats", locais)]
for (i in 1:length(whats)) {
  tmp <- list.files(whats[i], recursive = T)
  deletar <- paste0(whats[i], "/", tmp[grepl("(\\.mp4|\\.opus|\\.jpg|\\.jpeg|\\.pdf)$", tmp)])
  lapply(deletar, file.remove)
}
hoje <- Sys.Date()
for (i in 1:length(whats)) {
  tmp <- list.files(whats[i], recursive = T)
  deletar <- paste0(whats[i], "/", tmp[grepl("msgstore", tmp)]) %>% 
    enframe() %>% 
    mutate(data = value %>% 
             str_extract("[0-9]{4}-[0-9]{2}-[0-9]{2}") %>% 
             ymd(),
           tempo = hoje - data) %>% 
    na.omit() %>% 
    filter(tempo > min(tempo))
  lapply(deletar$value, file.remove) 
}

# faxina no cache -------------------------------------------------------------

cache <- locais[grepl("(C|c)ache", locais)]

# downloads -------------------------------------------------------------------

down <- locais[grepl("(D|d)ownload", locais)]
for (i in 1:length(down)) {
  tmp <- list.files(down[i], recursive = T)
  deletar <- paste0(down[i], "/", tmp[grepl("(\\.mp4|\\.opus|\\.jpg|\\.jpeg|\\.pdf)$", tmp)])
  lapply(deletar, file.remove)
}
