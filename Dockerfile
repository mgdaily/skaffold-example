FROM python:3.10-slim as base

SHELL ["/bin/bash", "-c"]

# upgrade pip and install poetry
RUN pip install --upgrade pip && pip install poetry

COPY ./README.md ./pyproject.toml ./poetry.lock ./

RUN pip install -r <(poetry export --without-hashes)

COPY ./my-app ./

FROM base as prod

# add a non-root user to run the app
RUN useradd appuser

# switch to non-root user
USER appuser

CMD ["uvicorn", "app:app", "--port", "8080", "--workers", "4"]

EXPOSE 8080/tcp
