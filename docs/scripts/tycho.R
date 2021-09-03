library(rvest)
library(httr)
library(reshape2)
library(lubridate)
library(dplyr)
library(purrr)

## US population
# because we are going to use project tycho level 2 data we need us pop census
pop <- lapply(states, function(usstate) GET(sprintf("https://fred.stlouisfed.org/graph/fredgraph.csv?id=%sPOP", usstate)))
uspop <- lapply(pop, content)
uspop_i <- sapply(uspop, function(x) !is.null(dim(x)))
uspop <- uspop[uspop_i] %>% 
  lapply(function(x) melt(x, id.vars = "DATE")) %>% 
  do.call(rbind,.) %>% 
  mutate(state = sub("POP","", variable),
         year = year(DATE)) %>% 
  select(year, state, value)

uspop %>% group_by(state) %>% summarise(start = min(year), end = max(year))

# Project Tycho level 2 data
apikey <- my_secret_apikey <- "c2cd45b36c570150ecd4"

tycho_listings <- function(listing = c("diseases", "cities", "states"), apikey){
  q <- GET(sprintf("http://www.tycho.pitt.edu/api/%s?apikey=%s", listing, apikey)) 
  if(listing %in% c("diseases", "states")) {
    nodes <- sub("s$", "", listing)
  } else {
      nodes <- c("loc", "state")
    }
  cont <- content(q) 
  get_nodes <- function(node) html_nodes(cont, node) %>% lapply(html_text) %>% unlist
  result <- sapply(nodes, get_nodes)
  if(ncol(result)==1) c(result) else as.data.frame(result)
  }

states <- tycho_listings("states", my_secret_apikey)
diseases <- tycho_listings("diseases", my_secret_apikey)
cities <- tycho_listings("cities", my_secret_apikey)
diseases


disease_cases <- function(loc, state, disease){
  query <- sprintf("http://www.tycho.pitt.edu/api/query?loc_type=city&loc=%s&state=%s&disease=%s&event=cases&apikey=c2cd45b36c570150ecd4.csv", loc, state, disease)
  read.csv(query)
}


measles <- map2(cities$loc, cities$state, disease_cases, disease = "measles")
polio <- map2(cities$loc, cities$state, disease_cases, disease = "POLIOMYELITIS")


munge_disease <- function(disease){ 
  bind_rows(disease) %>% 
  select(year, week, loc, state, number) %>% 
  group_by(year, state) %>% 
  summarise(cases = sum(number)) %>%
    arrange(state, year)
    }

bind_rows(measles) %>% 
  filter(state=="UT") %>% 
  group_by(year) %>% 
  summarise(cases = sum(number, na.rm = TRUE))

meas <- munge_disease(measles)
pol <- munge_disease(polio)
head(pol)
pol %>% group_by(state) %>% summarise(start = min(year), end = max(year))

# merge disease and population data
meas_year <- full_join(meas, uspop) %>% 
filter(meas, state=="UT")  %>%  data.frame()
  
  mutate(inc = (cases/value)*100)
pol_year <- left_join(pol, uspop) %>% 
  mutate(inc = (cases/value)*100)

head(pol_year)
max(pol_year$inc)

# plot results
library(ggplot2)
ggplot(pol_year, aes(year, state, fill = cases*100/value)) + 
  geom_tile() + xlim(range(meas_year$year))

ggplot(meas_year, aes(year, state, fill = log(inc))) + 
  geom_tile(colour = "white", width = .9, height = .9) + 
  theme_minimal() +
  scale_fill_gradientn(colours = heat.colors(4000), limits = c(0, 4000),
                       breaks = seq(0, 4e3, by = 1e3), 
                       na.value = rgb(246, 246, 246, max = 255),
                       labels = c("0k", "1k", "2k", "3k", "4k"),
                       guide = guide_colourbar(ticks = T, nbin = 50,
                                             barheight = .5, label = T, 
                                             barwidth = 10)) +
  scale_x_continuous(expand=c(0,0), 
                     breaks=seq(1930, 2010, by=10)) +
  geom_segment(x=1963, xend=1963, y=0, yend=51.5, size=.9) +
  labs(x="", y="", fill="") +
  ggtitle("Measles") +
  theme(legend.position=c(.5, -.13),
        legend.direction="horizontal",
        legend.text=element_text(colour="grey20"),
        plot.margin=grid::unit(c(.5,.5,1.5,.5), "cm"),
        axis.text.y=element_text(size=6, family="Helvetica", 
                                 hjust=1),
        axis.text.x=element_text(size=8),
        axis.ticks.y=element_blank(),
        panel.grid=element_blank(),
        title=element_text(hjust=-.07, face="bold", vjust=1, 
                           family="Helvetica"),
        text=element_text(family="URWHelvetica")) +
  annotate("text", label="Vaccine introduced", x=1963, y=53, 
           vjust=1, hjust=0, size=I(3), family="Helvetica")