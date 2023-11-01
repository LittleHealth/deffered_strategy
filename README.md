# Overview

- **Paper**: Flushing Rate Optimization for Out-of-Order Time Series Arrivals in Apache IoTDB.(TBA)
- **Implementation**: The code for deffered strategy can be found in the repository of Apache IoTDB, https://github.com/apache/iotdb/tree/research/deffered_strategy
- **Datasets**: All datasets used in the paper are list in the datasets
- **Evaluation**: The benchmark will execute the test in the default read-write mixed mode.
___ 
 
## Prerequisites

Clone this Apache IoTDB repository of [`deferred_strategy`](https://github.com/apache/iotdb/tree/research/deffered_strategy), to use IoTDB, you need to have:
- Java >= 1.8 (1.8, 11 to 17 are verified. Please make sure the environment path has been set accordingly).
- Maven >= 3.6 (If you want to compile and install IoTDB from source code).

Clone this IoT-Benchmark repository of [IoT-Benchmark](https://github.com/thulab/iot-benchmark)
the prerequisites is the same as Apach IoTDB.
___

## Build

Build IoTDB from source
Under the root path of iotdb:
```
> mvn clean package -pl distribution -am -DskipTests
```
After being built, the IoTDB distribution is located at the folder: "distribution/target".

Build iot-benchmark from source:
```
> mvn clean package -Dmaven.test.skip=true
```
You can also just download the released version.
___

## Execution

#### Server configuration
Get into the folder "conf", and modify the `seq_memtable_topk_size` to your favorite size.

the important configuration is as follows:
```
seq_memtable_topk_size=?
avg_series_point_number_threshold=10000
enable_mem_control=true
```

then get into the folder "sbin", run the following command to start server.

```bash
bash start-confignode.sh
bash start-datanode.sh
```
#### Client configuration
After configuring the settings in the "conf" folder, and upload the datasets in the "data/test/d_0" folder,
you can begin to do testing.

Get into the folder "sbin", run the following command to start the test.

```bash
bash benchmark.sh
```

To run more tests on different datasets or write percentages, you can just run the "run_benchmark.sh"
```
bash run_benchmark.sh
```

Remember the modify your folder path in the `run_benchmark.sh`.
