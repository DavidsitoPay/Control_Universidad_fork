# =====================================================
# Etapa 1: Build
# =====================================================
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# 1) Copiar la solución
COPY test1.sln ./

# 2) Copiar los .csproj referenciados por la solución (mínimo: app + tests)
COPY UniversityGrades.csproj ./
COPY Tests/UniversityGrades.Tests.csproj ./Tests/

# 3) Restore usando la solución (como pide el laboratorio)
RUN dotnet restore "./test1.sln"

# 4) Copiar el resto del código
COPY . ./

# 5) Publicar SOLO el proyecto principal (no el de tests)
RUN dotnet publish "./UniversityGrades.csproj" -c Release -o /app/publish --no-restore

# =====================================================
# Etapa 2: Runtime
# =====================================================
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

COPY --from=build /app/publish ./

EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080
ENV ASPNETCORE_ENVIRONMENT=Production

ENTRYPOINT ["dotnet", "UniversityGrades.dll"]
