# Design notes

## Decisions

| Decision | Reason |
|---|---|
| Medallion layers as separate schemas (`bronze`, `silver`, `gold`) | Clear contracts and permissions per layer; `generate_schema_name` uses the custom schema as-is. |
| `raw()` macro switches between seeds and Lakehouse sources | One codebase runs locally, in CI and on Fabric. |
| DuckDB for CI | Runs the entire DAG and all tests in seconds with no cloud cost or credentials. |
| Incremental on `updated_at`, `merge` on Fabric | Reprocesses only changed rows; Delta supports merge. `delete+insert` is used on DuckDB. |
| Latest version wins (`row_number()` over `updated_at`) | The source delivers multiple versions of the same incident. |
| Cross-database macros (`dbt.datediff`, `dbt.date_trunc`, `dbt.type_string`) | Same SQL on DuckDB and Spark SQL. |
| Tests next to every model | Every key, relationship and accepted-value rule is enforced on each run. |

## Known limits

- Synthetic data: figures such as SLA compliance are illustrative.
- `dbt-fabricspark` runs over Livy and is slower than DuckDB; large production loads would also use Fabric pipelines and notebooks for ingestion.
- Seeds stand in for raw tables locally; in Fabric the raw tables are landed by ingestion pipelines.

## Possible next steps

- Add a Power BI semantic model (TMDL) on top of the Gold layer.
- Add dbt exposures and contracts for Gold models.
- Add Slim CI (`state:modified+`) and a nightly full run.
