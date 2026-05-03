# 1. Build Stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Step 2: Copy the project file from the subfolder
COPY ["WorkingOutHobby/WorkingOutHobby.csproj", "WorkingOutHobby/"]
RUN dotnet restore "WorkingOutHobby/WorkingOutHobby.csproj"

# Step 3: Copy all files from the root into the container
COPY . .

# Step 4: Move into the project folder to publish
WORKDIR "/src/WorkingOutHobby"
RUN dotnet publish "WorkingOutHobby.csproj" -c Release -o /app/publish

# 2. Runtime Stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "WorkingOutHobby.dll"]