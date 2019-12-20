# 使用 spark-submit 将 spark 任务提交到 Kubernetes

1. 从 [download](https://spark.apache.org/downloads.html) 下载 spark 安装包 `spark-2.4.4-bin-hadoop2.7.tgz` 到本地。

2. 解压 spark 安装包，参考 [kubernetes-client](https://github.com/fabric8io/kubernetes-client) 以及 kubernetes-client 与 kubernetes 版本之间的关系，替换 `${SPARK_HOME}/jars/` 目录中的 `kubernetes-client-*.jar`, `kubernetes-model-*.jar`。

3. 参考 [running-on-kubernetes](https://spark.apache.org/docs/latest/running-on-kubernetes.html) 提交 spark 任务到 kubernetes 集群。
