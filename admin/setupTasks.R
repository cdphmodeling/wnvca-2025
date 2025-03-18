setwd('~/wnvca-2025')
library(hubAdmin); options(hubAdmin.schema_version="v5.0.0")
##########################################################################
# Target
##########################################################################
target = create_task_id(
  "target", 
  required="cases pm", 
  optional=NULL
)
target_metadata = create_target_metadata(
  create_target_metadata_item(
    target_id="cases pm",
    target_name="Monthly reported symptomatic WNV cases per million",
    target_units="rate per 1,000,000 population",
    target_keys=list(target="cases pm"),
    target_type="discrete",
    is_step_ahead=TRUE,
    time_unit="month"
  )
)
##########################################################################
# Date and Location
##########################################################################
origin_date = create_task_id(
  "origin_date",
  required=NULL,
  optional=c(
    "2024-04-30", "2024-05-31", "2024-06-30", "2024-07-31", 
    "2024-08-31", "2024-09-30", "2024-10-31", "2024-11-30"
  )
)
target_date = create_task_id(
  "target_date", 
  required=NULL, 
  optional=c(
                  "2024-05-31", "2024-06-30", "2024-07-31", 
    "2024-08-31", "2024-09-30", "2024-10-31", "2024-11-30",
    "2024-12-31"
  )
)
location = create_task_id(
  "location",
  required=c(
    "Fresno", "Kern", "Los Angeles", "Merced", "Orange", 
    "Placer", "Riverside", "Sacramento", "San Bernardino", 
    "San Joaquin", "Solano", "Stanislaus", "Tulare"
  ),
  optional=NULL
)

task_ids = create_task_ids(
  origin_date, location, target_date, target
)

cdf_output_type = create_output_type(
  create_output_type_cdf(
    required=c(0, 1, 2, 3, 4, 5, 6, 8, 10, 15, 200),
    is_required=TRUE,
    value_type="double"
  )
)
##########################################################################
#
##########################################################################
model_task = create_model_tasks(
  create_model_task(
    task_ids=task_ids,
    output_type=cdf_output_type,
    target_metadata=target_metadata
  )
)
##########################################################################
#
##########################################################################
rounds = create_rounds(
  create_round(
    round_id_from_variable=TRUE,
    round_id="origin_date",
    round_name="Round 1",
    model_tasks=model_task,
    submissions_due=list(
      relative_to="origin_date",
      start=-30L,
      end=1L
    )
  )
)
##########################################################################
#
##########################################################################
config = create_config(rounds, output_type_id_datatype="double")
write_config(config, overwrite=TRUE)
