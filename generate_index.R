library(quarto)
library(deeptime)
library(tidyverse)
library(googlesheets4)

# Get data and merge
data("stages")
colnames(stages)[which(colnames(stages) == "name")] <- "interval"
df <- read_sheet("https://docs.google.com/spreadsheets/d/1lPn72Zc40iH6mqjmkhGZdqt1RBm5ESmwO0xndNUsI_I/edit?usp=sharing")
df <- merge(x = stages, y = df, by = "interval", all.x = TRUE)
df <- df[order(df$min_age), ]

# Unique intervals (number of slides)
intervals <- unique(df$interval)

# Function for writing
write_grid <- function(x) {
  for (i in 1:nrow(x)) {
    # Extract row
    tmp <- x[i, ]
    # Extract caption
    cap <- tmp$caption
    # Extract image loc
    img <- tmp$file
    # Extract reference doi
    doi <- tmp$doi
    # Extract image author
    cre <- tmp$creator
    # Extract license
    lic <- tmp$license
    # Extract
    # Build content
    lic <- paste0(' Image created by ', cre, ' (', lic, ').')
    cont <- paste0(
      '[![*', cap, lic, '*](./assets/images/', img, ')](', doi,')')
    # Create image col
    cat('::: {.column width="30%"}', file = "index.qmd", append = TRUE)
    # Add space
    cat(paste0('\n\n'), file = "index.qmd", append = TRUE)
    # Add content
    cat(cont, file = "index.qmd", append = TRUE)
    # Add space
    cat(paste0('\n\n'), file = "index.qmd", append = TRUE)
    # Close image col
    cat(':::', file = "index.qmd", append = TRUE)
    # Add space
    cat(paste0('\n\n'), file = "index.qmd", append = TRUE)
  }
}


# Create file
file.create("index.qmd")
cat('---
format:
  revealjs:
    include-in-header:
      text: |
        <meta name="github-repo" content="LewisAJones/origins"/>
        <meta name="twitter:title" content="Origins."/>
        <meta name="twitter:description" content="Origins of geological events. "/>
        <meta name="twitter:url" content="https://origins.palaeobiology.org/"/>
        <meta name="twitter:image" content="assets/favicon.png"/>
        <meta name="twitter:card" content="summary_large_image"/>
        <meta name="twitter:creator" content="@LewisAlanJones"/>
        <meta name="twitter:site" content="@LewisAlanJones"/>
        <meta property="og:title" content="Origins"/>
        <meta property="og:description" content="Origins of geological events. "/>
        <meta property="og:url" content="https://origins.palaeobiology.org/"/>
        <meta property="og:image" content="assets/favicon.png"/>
        <meta property="og:type" content="website"/>
        <meta property="og:locale" content="en_GB"/>
        <meta property="article:author" content="Lewis A. jones"/>
    menu: true
    progress: true
    width: 1300
    scrollable: true
    controls: true
    controls-tutorial: true
    transition: slide
    theme: [default, style.scss]
    parallax-background-size: "28px 6000px"
    self-contained: true
    footer: "[Do you want to contribute an event?](https://www.google.com/?client=safari)"
---
    ', file = "index.qmd", sep = "\n")

cat(paste0('# Origins {background-color="white"}\n\n'), file = "index.qmd", append = TRUE)
cat(paste0('Lewis A. Jones & Miranta Kouvari\n\n'), file = "index.qmd", append = TRUE)

for (i in intervals) {
  # Subset file
  tmp <- subset(df, interval == i)
  # Create slide
  cat(paste0('## {data-menu-title="', tmp$interval[1],'" background-color="', tmp$color[1], '"}\n\n'), file = "index.qmd", append = TRUE)

  # Add name column
  cat('::: {.column width="30%"}', file = "index.qmd", append = TRUE)
  # Add space
  cat(paste0('\n\n'), file = "index.qmd", append = TRUE)
  # Add emphasis
  cat(paste0('::: {.emphasized}'), file = "index.qmd", append = TRUE)
  # Add space
  cat(paste0('\n\n'), file = "index.qmd", append = TRUE)
  # Add name
  cat(tmp$interval[1], file = "index.qmd", append = TRUE)
  # Add space
  cat(paste0('\n\n'), file = "index.qmd", append = TRUE)
  # Close emphasis
  cat(paste0(':::'), file = "index.qmd", append = TRUE)
  # Add space
  cat(paste0('\n\n'), file = "index.qmd", append = TRUE)
  # Add font style
  cat(paste0('::: {style="font-size:30px"}'), file = "index.qmd", append = TRUE)
  # Add space
  cat(paste0('\n\n'), file = "index.qmd", append = TRUE)
  # Add age
  cat(paste0(tmp$min_age[1], "--", tmp$max_age[1], " Ma\n\n"), file = "index.qmd", append = TRUE)
  # Close age
  cat(paste0(':::\n\n'), file = "index.qmd", append = TRUE)
  # Close name col
  cat(paste0(':::\n\n'), file = "index.qmd", append = TRUE)

  if (!any(is.na(tmp$file))) {
    write_grid(x = tmp)
  }

}

#quarto_render(input = "index.qmd")
#quarto_preview(file = "index.qmd")
