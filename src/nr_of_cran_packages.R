# Downloads and saves Available CRAN_Packages By Date of Publication from CRAN

library(rvest) # if missing run install.packages(c("xml2", "rvest"))

url <- "https://cran.r-project.org/web/packages/available_packages_by_date.html"
h <- read_html(url)
t <- html_table(h)
save(t, file = paste0("data/Available_CRAN_Packages_By_Date_of_Publication_",Sys.Date(),".RData"))
