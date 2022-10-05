library(palmerpenguins)
library(readr)

penguins <- penguins
penguins_raw <- penguins_raw

write_csv(penguins, "data/penguins.csv")
write_csv(penguins_raw, "data/penguins_raw.csv")