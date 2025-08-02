# Debugging container configuration for Visual Studio: https://aka.ms/customizecontainer

# Base image used during fast debug in Visual Studio
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

# Build stage: restore and compile the frontend project
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# ✅ FIXED: correct path to .csproj file based on context "."
COPY ["Heuberg.Frontend/HeubergFrontend.csproj", "Heuberg.Frontend/"]

# ✅ Set working dir to project folder for restore and build
WORKDIR /src/Heuberg.Frontend
RUN dotnet restore "HeubergFrontend.csproj"
COPY ["Heuberg.Frontend/", "./"]

RUN dotnet build "HeubergFrontend.csproj" -c $BUILD_CONFIGURATION -o /app/build

# Publish stage
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "HeubergFrontend.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# Final production image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "HeubergFrontend.dll"]