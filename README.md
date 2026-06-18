# TIS Docker

TIS (The Integration Service) 企业级数据集成服务平台 Docker 镜像。

## 快速开始

### 构建镜像

```bash
docker build -t tis-console .
```

### 运行容器

```bash
docker run -d \
  --name tis \
  -p 8080:8080 \
  -v tis-data:/opt/data \
  tis-console
```

### 使用 Docker Compose

```bash
cd docker-compose
docker-compose up -d
```

## 配置说明

### 环境变量

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `TZ` | `Asia/Shanghai` | 时区设置 |
| `JAVA_JVM_OPTS` | `-Xms512m -Xmx1G ...` | JVM 内存参数 |

### 端口

| 端口 | 说明 |
|------|------|
| `8080` | Web 服务端口 |
| `56432` | 内部服务端口 |

### 数据卷

| 路径 | 说明 |
|------|------|
| `/opt/data` | 数据存储目录 |

## 目录结构

```
tis-docker/
├── Dockerfile          # 镜像构建文件
├── docker-compose/     # Docker Compose 配置
├── tis-uber/           # TIS 应用目录
│   ├── bin/            # 启动脚本
│   ├── web-start/      # Web 应用
│   └── ...
└── README.md
```

## 常用命令

```bash
# 查看日志
docker logs -f tis

# 进入容器
docker exec -it tis bash

# 停止服务
docker stop tis

# 启动服务
docker start tis
```

## License

[Apache License 2.0](LICENSE)
