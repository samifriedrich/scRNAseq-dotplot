# scRNAseq-dotplot
Interactively explore gene expression across cell classes and create publication quality figures

## Running the app locally
1. If not already on your system, install the [`renv` package](https://rstudio.github.io/renv/index.html) in RStudio with:
```r
install.packages("renv")
```
2. Download or clone this repository. 
3. Place your Large Seurat object (`runs_combined.rds`) into the main project folder.
4. To launch the app, open the `app.R` file in RStudio, then click the "Run App" button in the top right of the editing panel. That's it!


## Deploying the app to shinyapps.io

Follow [these instructions](https://shiny.rstudio.com/articles/shinyapps.html) to create an account, install the `rsconnect` package, and configure your account. Then just click the "Publish" button in the RStudio editing panel to deploy.

## A note on `renv`
`renv` is a dependency manager for R that stores environment info in `renv.lock` and the `renv/` directory. It should automatically detect the environment and load packages associated with this project. If this fails (i.e. you get a "there is no package called 'XXX'" error message), check that you are in the correct project directory with `getwd()`.
