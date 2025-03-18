setwd('~/wnvca-2025')
library(hubAdmin); options(hubAdmin.schema_version="v5.0.0"); 
library(hubValidations)

validate_config(config="tasks")
validate_config(config="admin")
###############################################################################
# Validate Model YML files
###############################################################################
# Validate all YML files ------------------------------------------------------
details = file.info(list.files(path="./model-metadata", pattern="*.yml"))
details = details[with(details, order(as.POSIXct(mtime))), ]
cFiles = rownames(details)
sapply(cFiles, hubValidations::validate_model_metadata, hub_path='.')
# Examine individual file -----------------------------------------------------
file_path = 'CDPH-VBDS.yml'
hubValidations::validate_model_metadata(
  file_path=file_path,
  hub_path='.'
)
###############################################################################
# Validate Submissions
###############################################################################
# Validate full CSV set -------------------------------------------------------
details = file.info(list.files(
  path="./model-output", pattern="*-*-*.csv", recursive=TRUE
))
details = details[with(details, order(as.POSIXct(mtime))), ]
cFiles = rownames(details)
# print(cFiles)
sapply(cFiles, hubValidations::validate_submission, hub_path='.')
# Examine individual files ----------------------------------------------------
file_path = "CDPH-VBDS/2025-04-30-CDPH-VBDS.csv"
hubValidations::validate_submission(
  file_path=file_path,
  hub_path='.'
)


# submission_tmpl(
#   '~/wnvca-2025/tasks.json',
#   '2025-04-30',
#   required_vals_only = FALSE,
#   force_output_types = FALSE,
#   complete_cases_only = TRUE,
#   compound_taskid_set = NULL,
#   output_types = NULL,
#   derived_task_ids = NULL,
# )
