FROM docker.1ms.run/python:3.13-slim-bullseye

# 使用华为云 PyPI 镜像源
ENV PIP_INDEX_URL=https://repo.huaweicloud.com/repository/pypi/simple/

# 升级 pip 到最新版
RUN pip install --upgrade pip

# 安装依赖
RUN pip install --no-cache-dir akshare fastapi uvicorn gunicorn --upgrade
RUN pip install --no-cache-dir aktools --upgrade

# 特供版 akshare 包
COPY akshare-1.20.65+local-py3-none-any.whl /tmp/
RUN pip uninstall -y akshare \
    && pip install /tmp/akshare-1.20.65+local-py3-none-any.whl

# 设置工作目录
ENV APP_HOME=/usr/local/lib/python3.13/site-packages/aktools
WORKDIR $APP_HOME

# gunicorn 日志格式：时间 + 请求路径 + 状态码 + 耗时
# 访问日志和错误日志都输出到 stdout，便于 docker logs 收集
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "main:app", \
    "-k", "uvicorn.workers.UvicornWorker", \
    "--workers", "2", \
    "--timeout", "120", \
    "--graceful-timeout", "30", \
    "--log-level", "info"]
