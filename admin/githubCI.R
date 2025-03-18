library(hubAdmin); options(hubAdmin.schema_version="v5.0.0")
install.packages("hubCI", repos = c("https://hubverse-org.r-universe.dev", "https://cloud.r-project.org"))
library(hubCI)

use_hub_github_action(name = "validate-submission")
