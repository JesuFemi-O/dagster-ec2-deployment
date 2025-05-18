from dagster import asset, get_dagster_logger
import time

logger = get_dagster_logger()

@asset(group_name="elt", compute_kind="python")
def long_running_asset():
    for i in range(12):
        logger.info(f"Running batch {i+1}/12...")
        # simulate some work
        time.sleep(30)
    logger.info("✅ long_running_asset completed.")


@asset(group_name="elt", compute_kind="python")
def simple_asset():
    logger.info("✅ simple_asset completed.")
    return "simple_asset"


@asset(group_name="elt", compute_kind="python", deps=[simple_asset])
def another_simple_asset():
    logger.info("✅ another_simple_asset completed.")
    return "another_simple_asset"