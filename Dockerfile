FROM docker.1ms.run/python:3.13-slim-bullseye

# 升级 pip 到最新版
RUN pip install --upgrade pip

# 安装依赖
RUN pip install --no-cache-dir akshare fastapi uvicorn gunicorn -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host=mirrors.aliyun.com --upgrade
RUN pip install --no-cache-dir aktools -i https://pypi.org/simple --upgrade

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
