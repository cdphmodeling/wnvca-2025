# Model outputs folder

This folder contains a set of subdirectories, one for each model, that contains submitted model output files for that model. The structure of these directories and their contents follows [the model output guidelines in the hubverse's documentation](https://hubdocs.readthedocs.io/en/latest/user-guide/model-output.html).


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
hubValidations::validate_submission(
  hub_path='.',
  file_path='CDPH-AZO/2025-05-31-CDPH-AZO.csv'
)
```

where the `file_path` should be replaced with your submission file. If the validation ran correctly, you should see something like:

```
✔ WNVCA-2025: All hub config files are valid.
✔ 2025-05-31-CDPH-AZO.csv: File exists at path model-output/CDPH-AZO/2025-05-31-CDPH-AZO.csv.
✔ 2025-05-31-CDPH-AZO.csv: File name "2025-05-31-CDPH-AZO.csv" is valid.
✔ 2025-05-31-CDPH-AZO.csv: File directory name matches `model_id` metadata in file name.
✔ 2025-05-31-CDPH-AZO.csv: `round_id` is valid.
✔ 2025-05-31-CDPH-AZO.csv: File is accepted hub format.
✔ 2025-05-31-CDPH-AZO.csv: Metadata file exists at path model-metadata/CDPH-AZO.yml.
✔ 2025-05-31-CDPH-AZO.csv: File could be read successfully.
✔ 2025-05-31-CDPH-AZO.csv: `round_id_col` name is valid.
✔ 2025-05-31-CDPH-AZO.csv: `round_id` column "origin_date" contains a single, unique round ID value.
✔ 2025-05-31-CDPH-AZO.csv: All `round_id_col` "origin_date" values match submission `round_id` from file name.
✔ 2025-05-31-CDPH-AZO.csv: Column names are consistent with expected round task IDs and std column names.
✔ 2025-05-31-CDPH-AZO.csv: Column data types match hub schema.
✔ 2025-05-31-CDPH-AZO.csv: `tbl` contains valid values/value combinations.
✔ 2025-05-31-CDPH-AZO.csv: All combinations of task ID column/`output_type`/`output_type_id` values are unique.
✔ 2025-05-31-CDPH-AZO.csv: Required task ID/output type/output type ID combinations all present.
✔ 2025-05-31-CDPH-AZO.csv: Values in column `value` all valid with respect to modeling task config.
✔ 2025-05-31-CDPH-AZO.csv: Values in `value` column are non-decreasing as output_type_ids increase for all unique task ID value/output type combinations of
  quantile or cdf output types.
ℹ 2025-05-31-CDPH-AZO.csv: No pmf output types to check for sum of 1. Check skipped.
! 2025-05-31-CDPH-AZO.csv: Submission time must be within accepted submission window for round.  Current time 2025-03-26 09:09:58.40993 is outside window
  2025-05-16 PDT--2025-06-08 23:59:59 PDT.
```

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
