FROM mcr.microsoft.com/dotnet/aspnet:5.0-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0-buster-slim AS build
WORKDIR /src
COPY ["Deliverability.EmailAddressValidator/Deliverability.EmailAddressValidator.csproj", "Deliverability.EmailAddressValidator/"]
RUN dotnet restore "Deliverability.EmailAddressValidator/Deliverability.EmailAddressValidator.csproj"
COPY . .
WORKDIR "/src/Deliverability.EmailAddressValidator"
RUN dotnet build "Deliverability.EmailAddressValidator.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Deliverability.EmailAddressValidator.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Deliverability.EmailAddressValidator.dll"]