# Model outputs folder

This folder contains a set of subdirectories, one for each model, that contains submitted model output files for that model. The structure of these directories and their contents follows [the model output guidelines in the hubverse's documentation](https://hubdocs.readthedocs.io/en/latest/user-guide/model-output.html).

## Forecast file format

### `location`

Values in the `location` column must be one of the California regions in the following list: `ScV_N`, `ScV_S`, `SnJ_N`, `SnJ_S`, `Cal_S`, `LAO_G`; where each region codes maps to a group of counties in the following way:

* North Sacramento Valley [`ScV_N`]: Glenn, Butte, Colusa, Sutter, Yuba
* South Sacramento Valley [`ScV_S`]: Yolo, Sacramento, Placer
* North San Joaquin [`SnJ_N`]: San Joaquin, Stanislaus, Merced
* South San Joaquin [`SnJ_S`]: Madera, Fresno, Kings, Tulare, Kern
* Southern California  [`Cal_S`]: San Bernardino, Riverside
* Greater LA [`LAO_G`]: Los Angeles, Orange
  

### `origin_date` 

Values in the `origin_date` column must be a date in the ISO format

    YYYY-MM-DD

This is the date from which all forecasts should be considered. This date must be equal or lower to the submission date for each of the challenge's deadlines. 

### `target_date`

Values in the `target_date` column must be a date in the format

    YYYY-MM-DD
    
This is the last date of the forecast target for each month. This date should match the submission target date.

### `output_type`

The output_type for this challenge can take two values: `quantile` (**required**) and `cdf` (**optional but highly encouraged**):

* `quantile`: row entries for the quantiles of WNV cases predicted by the model.
* `cdf`: a single CDF entry per region-month is also accepted and should reflect the model's belief for "no WNV cases" reported in this region-month.

### `output_type_id`

The `output_type_id` column contains the identifiers for the prediction `value`, and they follow the form:

* `quantile`: this column must contain each one of the following entries for each region-month pair `0.01`, `0.05`, `0.1`, `0.15`, `0.2`, `0.25`, `0.3`, `0.35`, `0.4`, `0.45`, `0.5`, `0.55`, `0.6`, `0.65`, `0.7`, `0.75`, `0.8`, `0.85`, `0.9`, `0.95`, `0.99`
* `cdf`: a single entry of `0` can be provided for each region-month and, if provided, is used to improve the precision in scoring the model

An important note is that **these ids should match the pattern exactly**, so they should have not leading or trailing zeroes.

### `value`

This column contains the actual predicted values for the outputs.

* `quantile`: non-negative numbers with the predicted number of cases
* `cdf`: decimal number between 0 and 1 representing the probability of no WNV cases reported

### `target`

Two string constants are accepted depending on the output type:

* `quantile`: has the `WNV cases` target
* `cdf`: is `No WNV activity`

## Forecast validation 

To ensure proper data formatting, pull requests for new data in `model-output/` will be automatically run. It is highly recommended, however, that these validations are [run locally](#Local-Validation) before generating the pull request.


### Pull request forecast validation

When a pull request is submitted, the data are validated through [Github Actions](https://docs.github.com/en/actions) which runs the tests present in [the hubValidations
package](https://github.com/Infectious-Disease-Modeling-Hubs/hubValidations). The intent for these tests are to validate the requirements above. Please [let us know](https://github.com/cdphmodeling/wnvca-2025) if you are facing issues while running the tests.

### Local Validation

Teams are highly encouraged to validate their data locally before doing their pull request. To do this, install the `hubValidations` package:

```R
remotes::install_github("Infectious-Disease-Modeling-Hubs/hubValidations")
```

then set your working directory to the base repository path, and run:

```R
require(hubValidations)
file_path = "CDPH-NBB/2025-04-30-CDPH-NBB.csv"
hubValidations::validate_submission(
  file_path=file_path,
  hub_path='.'
)
```

where the `file_path` should be replaced with your submission file. If the validation ran correctly, you should see something like:

```
✔ [file_exists]: File exists at path model-output/CDPH-NBB/2025-04-30-CDPH-NBB.csv.
✔ [file_name]: File name "2025-04-30-CDPH-NBB.csv" is valid.
✔ [file_location]: File directory name matches `model_id` metadata in file name.
✔ [round_id_valid]: `round_id` is valid.
✔ [file_format]: File is accepted hub format.
✔ [file_n]: Number of accepted model output files per round met.
✔ [metadata_exists]: Metadata file exists at path model-metadata/CDPH-NBB.yml.
✔ [file_read]: File could be read successfully.
✔ [valid_round_id_col]: `round_id_col` name is valid.
✔ [unique_round_id]: `round_id` column "origin_date" contains a single, unique round ID value.
✔ [match_round_id]: All `round_id_col` "origin_date" values match submission `round_id` from file name.
✔ [colnames]: Column names are consistent with expected round task IDs and std column names.
✔ [col_types]: Column data types match hub schema.
✔ [valid_vals]: `tbl` contains valid values/value combinations.
ℹ [derived_task_id_vals]: No derived task IDs to check. Skipping derived task ID value check.
✔ [rows_unique]: All combinations of task ID column/`output_type`/`output_type_id` values are unique.
✔ [req_vals]: Required task ID/output type/output type ID combinations all present.
✔ [value_col_valid]: Values in column `value` all valid with respect to modeling task config.
✔ [value_col_non_desc]: Quantile or cdf `value` values increase when ordered by `output_type_id`.
ℹ [value_col_sum1]: No pmf output types to check for sum of 1. Check skipped.
ℹ [spl_compound_taskid_set]: No v3 samples found in model output data to check. Skipping `check_tbl_spl_compound_taskid_set` check.
ℹ [spl_compound_tid]: No v3 samples found in model output data to check. Skipping `check_tbl_spl_compound_tid` check.
ℹ [spl_non_compound_tid]: No v3 samples found in model output data to check. Skipping `check_tbl_spl_non_compound_tid` check.
ℹ [spl_n]: No v3 samples found in model output data to check. Skipping `check_tbl_spl_n` check.
```

## Policy on late or updated submissions 

To ensure that forecasting is done in real-time, all forecasts are required to be submitted to this repository by the listed deadlines. Late forecasts may be accepted on a case-by-case basis. 

## Evaluation criteria

When reported data for 2025 are available, an analysis will be conducted using multiple proper scoring metrics, with particular focus on the [weighted interval score (WIS)](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1008618), to assess and compare forecasts across all counties at each time point. A joint manuscript will be prepared to disseminate findings on this comparison and the general performance of submitted forecasts. Participants may publish their own forecasts and results at any time. 
