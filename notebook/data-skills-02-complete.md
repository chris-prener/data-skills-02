Data Skills 02 - Introduction to dplyr for Data Wrangling - Complete
================
Christopher Prener, Ph.D.
(October 05, 2022)

## R Projects and Working Directories

R Projects are a special type of file associated with RStudio. They
create self-contained directories and environments that increase the
reproducibility of your work. When you set a R project up, it will
change the **working directory** to the project’s directory. This means
that all of the data you save from RStudio will be saved there by
default. It also means that you can open files saved in that directory
without needing to worry about file paths.

I’ll give you an R project directory to download for each session.
However, if you want to create a new project for your own work, go to
`File > New Project...` and follow the prompts. You can create a new
project directory, associate a project with an existing directory, and
even add `git` version control!

## Dependencies

This notebook requires two packages from the `tidyverse` as well as two
additional packages:

``` r
# tidyverse packages
library(dplyr)     # data wrangling
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
library(readr)     # read and write csv files

# data wrangling
library(janitor)   # data wrangling
```

    ## 
    ## Attaching package: 'janitor'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     chisq.test, fisher.test

``` r
# manage file paths
library(here)      # manage file paths
```

    ## here() starts at /Users/prenec/Documents/GitHub/data_skills/data-skills-02

## Reading Data

Today, we’ll review how to read `.csv` files into `R`. We have to files
in the `data/` sub-directory of our project:

1.  `penguins.csv` - a cleaner version of the `penguins` data from
    `palmerpenguins`
2.  `penguins_raw.csv` - a messier version of the `penguins` data from
    `palmerpenguins`

To read `.csv` files into `R`, we’ll use the `readr` package’s
`read_csv()` function. **This is different from `utils::read.csv()`!**

``` r
penguins <- read_csv(here("data", "penguins.csv"))
```

    ## Rows: 344 Columns: 8
    ## ── Column specification ─────────────────────────────────────────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (3): species, island, sex
    ## dbl (5): bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g, year
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

Now, read in `penguins_raw.csv` into an object called `penguins_raw`:

``` r
penguins_raw <- read_csv(here("data", "penguins_raw.csv"))
```

    ## Rows: 344 Columns: 17
    ## ── Column specification ─────────────────────────────────────────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr  (9): studyName, Species, Region, Island, Stage, Individual ID, Clutch Completion, Sex, Comments
    ## dbl  (7): Sample Number, Culmen Length (mm), Culmen Depth (mm), Flipper Length (mm), Body Mass (g), Delta 15 N (o...
    ## date (1): Date Egg
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

There is also a package called `readxl` that works well for Excel files
and another package called `haven` that can read SPSS, Stata, and SAS
data files. Both packages are installed when you install the
`tidyverse`.

## Fixing Variable Names

### With `janitor`

One of the issues with both data sets are the variable names. If you
have a data set with a large number of columns that you’ll want to
retain, but many of which need to be renamed, the `janitor` package’s
`clean_names()` function can help jump start the process.

We’ll try out `clean_names()` on the `mpg` data:

``` r
penguins_raw %>%
  clean_names() -> penguins_raw
```

This is a *pipeline*. We can read it like a paragraph, inserting the
word *then* every time we see the pipe operator (`%>%`):

1.  First, we take the `penguins_raw` data, *then*
2.  we clean its names, *then*
3.  we store the resulting data in the object `penguins_raw`.

We use pipelines to make our code easier to read.

### With `dplyr`

Ideally, our need to rename variables is more targeted. In that case, we
can use `dplyr`’s `rename()` function to modify these names manually:

``` r
penguins_raw %>%
  rename(
    sid = study_name,
    sample = sample_number,
    iid = individual_id
  ) -> penguins_raw
```

The `rename()` function sets *new* variable names equal to *old*
variable names. I personally find this confusing, but here we are!

Now, you try on the `penguins` data. Rename `bill_length_mm`,
`bill_depth_mm` and `body_mass_g`, ideally removing the units of
measure:

``` r
penguins %>%
  rename(
    bill_length = bill_length_mm,
    bill_depth = bill_depth_mm,
    mass = body_mass_g
  ) -> penguins
```

## Subsetting Columns

We often only want a selection of columns from our data. We can use the
`select()` function from `dplyr` to help get us a subset of our data.

``` r
penguins_raw %>%
  select(species, region, iid, body_mass_g)
```

    ## # A tibble: 344 × 4
    ##    species                             region iid   body_mass_g
    ##    <chr>                               <chr>  <chr>       <dbl>
    ##  1 Adelie Penguin (Pygoscelis adeliae) Anvers N1A1         3750
    ##  2 Adelie Penguin (Pygoscelis adeliae) Anvers N1A2         3800
    ##  3 Adelie Penguin (Pygoscelis adeliae) Anvers N2A1         3250
    ##  4 Adelie Penguin (Pygoscelis adeliae) Anvers N2A2           NA
    ##  5 Adelie Penguin (Pygoscelis adeliae) Anvers N3A1         3450
    ##  6 Adelie Penguin (Pygoscelis adeliae) Anvers N3A2         3650
    ##  7 Adelie Penguin (Pygoscelis adeliae) Anvers N4A1         3625
    ##  8 Adelie Penguin (Pygoscelis adeliae) Anvers N4A2         4675
    ##  9 Adelie Penguin (Pygoscelis adeliae) Anvers N5A1         3475
    ## 10 Adelie Penguin (Pygoscelis adeliae) Anvers N5A2         4250
    ## # … with 334 more rows

Now, you try on the `penguins` data. Select only the columns for
species, bill length, and bill depth:

``` r
penguins %>%
  select(species, bill_length, bill_depth)
```

    ## # A tibble: 344 × 3
    ##    species bill_length bill_depth
    ##    <chr>         <dbl>      <dbl>
    ##  1 Adelie         39.1       18.7
    ##  2 Adelie         39.5       17.4
    ##  3 Adelie         40.3       18  
    ##  4 Adelie         NA         NA  
    ##  5 Adelie         36.7       19.3
    ##  6 Adelie         39.3       20.6
    ##  7 Adelie         38.9       17.8
    ##  8 Adelie         39.2       19.6
    ##  9 Adelie         34.1       18.1
    ## 10 Adelie         42         20.2
    ## # … with 334 more rows

The order here matters! `select()` will reorder your columns to match
whatever order you enter them in. You can also remove columns:

``` r
penguins_raw %>%
  select(-region)
```

    ## # A tibble: 344 × 16
    ##    sid     sample species island stage iid   clutc…¹ date_egg   culme…² culme…³ flipp…⁴ body_…⁵ sex   delta…⁶ delta…⁷
    ##    <chr>    <dbl> <chr>   <chr>  <chr> <chr> <chr>   <date>       <dbl>   <dbl>   <dbl>   <dbl> <chr>   <dbl>   <dbl>
    ##  1 PAL0708      1 Adelie… Torge… Adul… N1A1  Yes     2007-11-11    39.1    18.7     181    3750 MALE    NA       NA  
    ##  2 PAL0708      2 Adelie… Torge… Adul… N1A2  Yes     2007-11-11    39.5    17.4     186    3800 FEMA…    8.95   -24.7
    ##  3 PAL0708      3 Adelie… Torge… Adul… N2A1  Yes     2007-11-16    40.3    18       195    3250 FEMA…    8.37   -25.3
    ##  4 PAL0708      4 Adelie… Torge… Adul… N2A2  Yes     2007-11-16    NA      NA        NA      NA <NA>    NA       NA  
    ##  5 PAL0708      5 Adelie… Torge… Adul… N3A1  Yes     2007-11-16    36.7    19.3     193    3450 FEMA…    8.77   -25.3
    ##  6 PAL0708      6 Adelie… Torge… Adul… N3A2  Yes     2007-11-16    39.3    20.6     190    3650 MALE     8.66   -25.3
    ##  7 PAL0708      7 Adelie… Torge… Adul… N4A1  No      2007-11-15    38.9    17.8     181    3625 FEMA…    9.19   -25.2
    ##  8 PAL0708      8 Adelie… Torge… Adul… N4A2  No      2007-11-15    39.2    19.6     195    4675 MALE     9.46   -24.9
    ##  9 PAL0708      9 Adelie… Torge… Adul… N5A1  Yes     2007-11-09    34.1    18.1     193    3475 <NA>    NA       NA  
    ## 10 PAL0708     10 Adelie… Torge… Adul… N5A2  Yes     2007-11-09    42      20.2     190    4250 <NA>     9.13   -25.1
    ## # … with 334 more rows, 1 more variable: comments <chr>, and abbreviated variable names ¹​clutch_completion,
    ## #   ²​culmen_length_mm, ³​culmen_depth_mm, ⁴​flipper_length_mm, ⁵​body_mass_g, ⁶​delta_15_n_o_oo, ⁷​delta_13_c_o_oo

## Subsetting Observations

Just like we want only a selection of columns, we may only want a
selection of variables. We can use `dplyr`’s `filter()` function to
subset our data based on the values observations. To do this, we need
one or more of the following operators:

-   `>` - greater than
-   `>=` -greater than or equal to
-   `<` - less than
-   `<=` - less than or equal to
-   `!=` - not equal to
-   `==` - equal to
-   `&` - and
-   `|` - or
-   `!` - not

For example, let’s pull out all observations in `penguins_raw` that
occur either on Biscoe or Dream islands:

``` r
penguins_raw %>%
  filter(island == "Biscoe" | island == "Dream")
```

    ## # A tibble: 292 × 17
    ##    sid     sample species  region island stage iid   clutc…¹ date_egg   culme…² culme…³ flipp…⁴ body_…⁵ sex   delta…⁶
    ##    <chr>    <dbl> <chr>    <chr>  <chr>  <chr> <chr> <chr>   <date>       <dbl>   <dbl>   <dbl>   <dbl> <chr>   <dbl>
    ##  1 PAL0708     21 Adelie … Anvers Biscoe Adul… N11A1 Yes     2007-11-12    37.8    18.3     174    3400 FEMA…    8.74
    ##  2 PAL0708     22 Adelie … Anvers Biscoe Adul… N11A2 Yes     2007-11-12    37.7    18.7     180    3600 MALE     8.66
    ##  3 PAL0708     23 Adelie … Anvers Biscoe Adul… N12A1 Yes     2007-11-12    35.9    19.2     189    3800 FEMA…    9.22
    ##  4 PAL0708     24 Adelie … Anvers Biscoe Adul… N12A2 Yes     2007-11-12    38.2    18.1     185    3950 MALE     8.43
    ##  5 PAL0708     25 Adelie … Anvers Biscoe Adul… N13A1 Yes     2007-11-10    38.8    17.2     180    3800 MALE     9.64
    ##  6 PAL0708     26 Adelie … Anvers Biscoe Adul… N13A2 Yes     2007-11-10    35.3    18.9     187    3800 FEMA…    9.21
    ##  7 PAL0708     27 Adelie … Anvers Biscoe Adul… N17A1 Yes     2007-11-12    40.6    18.6     183    3550 MALE     8.94
    ##  8 PAL0708     28 Adelie … Anvers Biscoe Adul… N17A2 Yes     2007-11-12    40.5    17.9     187    3200 FEMA…    8.08
    ##  9 PAL0708     29 Adelie … Anvers Biscoe Adul… N18A1 No      2007-11-10    37.9    18.6     172    3150 FEMA…    8.38
    ## 10 PAL0708     30 Adelie … Anvers Biscoe Adul… N18A2 No      2007-11-10    40.5    18.9     180    3950 MALE     8.90
    ## # … with 282 more rows, 2 more variables: delta_13_c_o_oo <dbl>, comments <chr>, and abbreviated variable names
    ## #   ¹​clutch_completion, ²​culmen_length_mm, ³​culmen_depth_mm, ⁴​flipper_length_mm, ⁵​body_mass_g, ⁶​delta_15_n_o_oo

Here, we set up a Boolean rule that is `TRUE` if an island is one name
*or* the other. Note that we cannot used *and* here because an island
cannot simultaneously have two names.

Now you try! Let’s pull out all observations from `penguins` for Adelie
penguins that have a body mass of at least 3700 grams:

``` r
penguins %>%
  filter(species == "Adelie" & mass >= 3700)
```

    ## # A tibble: 77 × 8
    ##    species island    bill_length bill_depth flipper_length_mm  mass sex     year
    ##    <chr>   <chr>           <dbl>      <dbl>             <dbl> <dbl> <chr>  <dbl>
    ##  1 Adelie  Torgersen        39.1       18.7               181  3750 male    2007
    ##  2 Adelie  Torgersen        39.5       17.4               186  3800 female  2007
    ##  3 Adelie  Torgersen        39.2       19.6               195  4675 male    2007
    ##  4 Adelie  Torgersen        42         20.2               190  4250 <NA>    2007
    ##  5 Adelie  Torgersen        37.8       17.3               180  3700 <NA>    2007
    ##  6 Adelie  Torgersen        38.6       21.2               191  3800 male    2007
    ##  7 Adelie  Torgersen        34.6       21.1               198  4400 male    2007
    ##  8 Adelie  Torgersen        36.6       17.8               185  3700 female  2007
    ##  9 Adelie  Torgersen        42.5       20.7               197  4500 male    2007
    ## 10 Adelie  Torgersen        46         21.5               194  4200 male    2007
    ## # … with 67 more rows

## Modifying Variables

If we want to modify an existing variable, or create a new variable, we
can use `dplyr`’s `mutate()` function. There are many possible
permutations that could build on this, but a simple use case is to
create a binary flag for penguins that are over 3700 grams in size:

``` r
penguins_raw %>%
  mutate(big_size = ifelse(body_mass_g >= 3700, TRUE, FALSE)) %>%
  select(body_mass_g, big_size)
```

    ## # A tibble: 344 × 2
    ##    body_mass_g big_size
    ##          <dbl> <lgl>   
    ##  1        3750 TRUE    
    ##  2        3800 TRUE    
    ##  3        3250 FALSE   
    ##  4          NA NA      
    ##  5        3450 FALSE   
    ##  6        3650 FALSE   
    ##  7        3625 FALSE   
    ##  8        4675 TRUE    
    ##  9        3475 FALSE   
    ## 10        4250 TRUE    
    ## # … with 334 more rows

The `ifelse()` function takes a Boolean condition and then specifies
what value to return when it is true and what value to return when it is
false. The result of this for each observation is stored in a new
variable called `big_size`.

I’ve added the `select()` function to make it easier to see the changes
our `mutate()` function made. In reality, you wouldn’t want to add this
step unless these were the only two columns you wanted!

Now you try to create a binary indicator variable that is `TRUE` when
penguins have a bill length greater than 40mm a mass greater than or
equal to 3700 grams:

``` r
penguins %>%
  mutate(big_penguin = ifelse(mass >= 3700 & bill_length > 40, TRUE, FALSE)) %>% 
  select(mass, bill_length, big_penguin)
```

    ## # A tibble: 344 × 3
    ##     mass bill_length big_penguin
    ##    <dbl>       <dbl> <lgl>      
    ##  1  3750        39.1 FALSE      
    ##  2  3800        39.5 FALSE      
    ##  3  3250        40.3 FALSE      
    ##  4    NA        NA   NA         
    ##  5  3450        36.7 FALSE      
    ##  6  3650        39.3 FALSE      
    ##  7  3625        38.9 FALSE      
    ##  8  4675        39.2 FALSE      
    ##  9  3475        34.1 FALSE      
    ## 10  4250        42   TRUE       
    ## # … with 334 more rows

With a bit of extra complexity, we might want rename the categories for
`species` to be something simpler:

``` r
unique(penguins_raw$species)
```

    ## [1] "Adelie Penguin (Pygoscelis adeliae)"       "Gentoo penguin (Pygoscelis papua)"        
    ## [3] "Chinstrap penguin (Pygoscelis antarctica)"

If we wanted to simplify these to `adelie`, `gentoo`, and `chinstrap`,
we could do the following:

``` r
penguins_raw %>% 
  mutate(species_simple = case_when(
    species == "Adelie Penguin (Pygoscelis adeliae)" ~ "adelie",
    species == "Gentoo penguin (Pygoscelis papua)" ~ "gentoo",
    species == "Chinstrap penguin (Pygoscelis antarctica)" ~ "chinstrap"
  )) %>%
  select(species, species_simple)
```

    ## # A tibble: 344 × 2
    ##    species                             species_simple
    ##    <chr>                               <chr>         
    ##  1 Adelie Penguin (Pygoscelis adeliae) adelie        
    ##  2 Adelie Penguin (Pygoscelis adeliae) adelie        
    ##  3 Adelie Penguin (Pygoscelis adeliae) adelie        
    ##  4 Adelie Penguin (Pygoscelis adeliae) adelie        
    ##  5 Adelie Penguin (Pygoscelis adeliae) adelie        
    ##  6 Adelie Penguin (Pygoscelis adeliae) adelie        
    ##  7 Adelie Penguin (Pygoscelis adeliae) adelie        
    ##  8 Adelie Penguin (Pygoscelis adeliae) adelie        
    ##  9 Adelie Penguin (Pygoscelis adeliae) adelie        
    ## 10 Adelie Penguin (Pygoscelis adeliae) adelie        
    ## # … with 334 more rows

## Putting It All Together

The ideal with pipes is that we can string all of our functions together
into a single run:

``` r
read_csv(here("data", "penguins_raw.csv")) %>%
  clean_names() %>%
  rename(
    sid = study_name,
    sample = sample_number,
    iid = individual_id
  ) %>%
  select(species, island, body_mass_g) %>%
  filter(island == "Biscoe" | island == "Dream") %>%
  mutate(big_size = ifelse(body_mass_g >= 3700, TRUE, FALSE)) %>% 
  mutate(species_simple = case_when(
    species == "Adelie Penguin (Pygoscelis adeliae)" ~ "adelie",
    species == "Gentoo penguin (Pygoscelis papua)" ~ "gentoo",
    species == "Chinstrap penguin (Pygoscelis antarctica)" ~ "chinstrap"
  )) -> penguins_clean
```

    ## Rows: 344 Columns: 17
    ## ── Column specification ─────────────────────────────────────────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr  (9): studyName, Species, Region, Island, Stage, Individual ID, Clutch Completion, Sex, Comments
    ## dbl  (7): Sample Number, Culmen Length (mm), Culmen Depth (mm), Flipper Length (mm), Body Mass (g), Delta 15 N (o...
    ## date (1): Date Egg
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

If we want to write our data, we can use `write_csv()` from the `readr`
package:

``` r
write_csv(penguins_clean, here("data", "penguins_clean.csv"))
```
