library(tidyverse)
df <- read_csv("data/crime.csv")

colnames(df)

#get summary table by content type
test<- df %>%
group_by(year, crm_cd_desc) %>%
  summarise(
    total_crimes = n(),
    avg_age=as.integer(mean(vict_age)),
    num_f = 
    #avg_year_built =as.integer(mean(year_built)),
    #avg_living_area =as.integer(mean(gr_liv_area)),
    #avg_price =as.integer(mean(saleprice)),
    #total_sales = n()
  ) %>%  
  filter(year == 2019) %>%
  arrange(-total_crimes) %>%
  head(5)


df %>%
  group_by(vict_sex) %>%
  summarise(
    n(vict_sex == 'F')
  ) %>%
  head()
