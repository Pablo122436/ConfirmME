# Use the official .NET 8.0 runtime as base image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE $PORT

# Use the .NET SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy the project file and restore dependencies
COPY ["ConfirmMe.csproj", "./"]
RUN dotnet restore "ConfirmMe.csproj"

# Copy the rest of the application files
COPY . .

# Build the application
RUN dotnet build "ConfirmMe.csproj" -c Release -o /app/build

# Publish the application
FROM build AS publish
RUN dotnet publish "ConfirmMe.csproj" -c Release -o /app/publish

# Final stage
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

# Set environment variables
ENV ASPNETCORE_URLS=http://0.0.0.0:$PORT
ENV ASPNETCORE_ENVIRONMENT=Production

# Set the entry point
ENTRYPOINT ["dotnet", "ConfirmMe.dll"]
