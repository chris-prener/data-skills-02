# knit complete notebook
rmarkdown::render("notebook/data-skills-02-complete.Rmd")

# copy
fs::file_copy(path = "notebook/data-skills-02-complete.html", new_path = "docs/index.html", overwrite = TRUE)
