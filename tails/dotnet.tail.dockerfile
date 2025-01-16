FROM mcr.microsoft.com/dotnet/runtime:9.0-alpine AS base
WORKDIR /app

ARG PROJECT_FILE=Bot

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY ${PROJECT_FILE}.csproj .
RUN dotnet restore ${PROJECT_FILE}.csproj
COPY . .
RUN dotnet build ${PROJECT_FILE}.csproj -c Release -o /app/build

FROM build AS publish
RUN dotnet publish ${PROJECT_FILE}.csproj -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
RUN ENTRY_DLL=$(ls *.dll | grep -v '^Microsoft\|^System\|^Discord') && \
    echo "#!/bin/sh" > /entrypoint.sh && \
    echo "exec dotnet $ENTRY_DLL \"\$@\"" >> /entrypoint.sh && \
    chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]