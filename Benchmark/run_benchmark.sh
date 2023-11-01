# !/bin/sh
# 仅限在166.111.80.243上执行
# 登录用户名
ACCOUNT=dqadmin
IOTDB_IP=166.111.80.243
# 初始环境存放路径

INIT_PATH=/home/${ACCOUNT}
TEST_IOTDB_PATH=${INIT_PATH}/2023-IoTDB-Flush/apache-iotdb-1.3.0-SNAPSHOT-bin-all
TEST_IOTDB_BENCHMARK_PATH=${INIT_PATH}/2023-IoT-Benchmark/1029-iot-benchmark-iotdb-1.1

DATASETS=(0 "BotIoT.csv_BigBatch_0.csv" "Samsung.csv_BigBatch_0.csv" "W1.csv_BigBatch_0.csv" "W2.csv_BigBatch_0.csv")
OPERATION_PROPORTIONS=(0 "100:0:0:0:0:0:0:0:0:0:0" "90:0:2:2:2:2:2:0:0:0:0" "75:0:5:5:5:5:5:0:0:0:0" "50:0:10:10:10:10:10:0:0:0:0" "25:0:15:15:15:15:15:0:0:0:0" "10:0:18:18:18:18:18:0:0:0:0")
LOG_FILES=(0 "100" "90" "75" "50" "25" "10")

################### 公用函数 ###################
test_operation() {
  for ((j = 1; j <= 4; j++)); do
    for ((m = 1; m <= 6; m++)); do
      DATASET=${DATASETS[${j}]}
      OPERATION_PROPORTION=${OPERATION_PROPORTIONS[${m}]}
      rm -rf "${TEST_IOTDB_BENCHMARK_PATH}/data/test/d_0/"
      mkdir "${TEST_IOTDB_BENCHMARK_PATH}/data/test/d_0/"
      cp "${TEST_IOTDB_BENCHMARK_PATH}/data/syn/${DATASET}" "${TEST_IOTDB_BENCHMARK_PATH}/data/test/d_0/"
      echo "测试配置：数据集${DATASET}, 读写比例${OPERATION_PROPORTION}"
      # 杀死当前服务器上的Java进程
      # 修改Benchmark配置
      sed -i "s/^OPERATION_PROPORTION=.*$/OPERATION_PROPORTION=${OPERATION_PROPORTION}/g" ${TEST_IOTDB_BENCHMARK_PATH}/conf/config.properties
      # 启动测试
      cd ${TEST_IOTDB_BENCHMARK_PATH}
      bash benchmark.sh 2>&1 | tee ${TEST_IOTDB_BENCHMARK_PATH}/data/logs/${DATASET}_${LOG_FILES[${m}]}.log >/dev/null
      sleep 5
      echo "测试完成：数据集${DATASET}, 读写比例${OPERATION_PROPORTION}"
    done
  done
}

###############################普通时间序列###############################
start_time=$(date +"%m-%d-%H-%M-%S")
echo "${start_time}开始测试！"
test_operation
end_time=$(date +"%m-%d-%H-%M-%S")
echo "${end_time}测试结束！"
