from dagster import asset
import time

@asset
def long_running_asset():
    for i in range(12):
        print(f"Running batch {i+1}/12...")
        # simulate some work
        time.sleep(30)
    print("✅ long_running_asset completed.")


@asset
def simple_asset():
    print("✅ simple_asset completed.")
    return "simple_asset"

