library(tidyverse)
wgs <- readxl::read_xlsx("WGS Samples sheet.xlsx", sheet = 1)
wgs
class(wgs)
write_csv(wgs, path = "colon_cancer.csv")
wgs <- read_csv("colon_cancer.csv")
wgs

wgs %>%
  summarise(n())

wgs %>%
  summarize(n())

wgs %>%
  group_by(`PA/NPA`) %>%
  summarise(n())

wgs %>%
  group_by(`PA/NPA`) 

wgs %>%
  mutate(Tissue = as.character(Tissue),
         Patient = as.factor(Patient))

wgs %>%
  summarise(n())

wgs %>% 
  group_by(Patient) %>%
  summarise(n())

wgs %>% 
  group_by(`Polyp type`) %>%
  summarise(n())

wgs %>% 
  group_by(`Polyp type`, Patient) %>%
  summarise(n())

qpcr <- read_csv("qpcr.csv")
qpcr
set.seed(1)
mapping <- sample(1:nrow(qpcr))
colnames(qpcr)
pcr <- qpcr %>%
  mutate(SampleID = mapping) %>%
  arrange(SampleID) %>%
  select(SampleID:`Lactobacillus crispatus`) 

pcr %>% 
  gather(key = SampleID, 
         value = Taxon, 
         `Lactobacillus jensenii`:`Lactobacillus crispatus`)

pcr %>% 
  gather(key = s1, 
         value = t1)

pcr %>% 
  gather(key = s1, 
         value = t1, 
         -SampleID)

pcr %>% 
  gather(key = SampleID, 
         value = Taxon, 
         -SampleID)

pcr %>% 
  gather(key = taxon, 
         value = total, 
         -SampleID) %>%
  group_by(SampleID) %>%
  summarise(sum(total))

