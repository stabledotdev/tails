ARG LANGUAGE_VERSION=9.0
FROM mcr.microsoft.com/dotnet/runtime:${LANGUAGE_VERSION}-alpine AS base
WORKDIR /bot

FROM mcr.microsoft.com/dotnet/sdk:${LANGUAGE_VERSION}-alpine AS build

ARG PROJECT_FILE=Bot

WORKDIR /src
COPY repo/${PROJECT_FILE}.csproj .
RUN dotnet restore ${PROJECT_FILE}.csproj
COPY repo/ .
RUN dotnet build ${PROJECT_FILE}.csproj -c Release -o /bot/build

FROM build AS publish
RUN dotnet publish ${PROJECT_FILE}.csproj -c Release -o /bot/publish

FROM base AS final
WORKDIR /bot
COPY --from=publish /bot/publish .
RUN ENTRY_DLL=$(ls *.deps.json | head -n1 | awk -F. '{print $1}').dll && \
    echo "#!/bin/sh" > /entrypoint.sh && \
    echo "exec dotnet $ENTRY_DLL \"\$@\"" >> /entrypoint.sh && \
    chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]