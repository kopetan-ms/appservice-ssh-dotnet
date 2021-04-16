#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443
EXPOSE 2222

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["DotnetContainers/DotnetContainers.csproj", "DotnetContainers/"]
RUN dotnet restore "DotnetContainers/DotnetContainers.csproj"
COPY . .
WORKDIR "/src/DotnetContainers"
RUN dotnet build "DotnetContainers.csproj" -c Debug -o /app/build
RUN curl -sSL https://aka.ms/getvsdbgsh | bash /dev/stdin -v vs2019 -l /app/vsdbg

FROM build AS publish
RUN dotnet publish "DotnetContainers.csproj" -c Debug -o /app/publish

FROM base AS final

# Install OpenSSH and set the password for root to "Docker!". In this example, "apk add" is the install instruction for an Alpine Linux-based image.
RUN apt-get update \
    && apt install -y openssh-server \
    && echo "root:Docker!" | chpasswd 

# Copy the sshd_config file to the /etc/ssh/ directory
COPY sshd_config /etc/ssh/

COPY init_container.sh /bin/
RUN chmod 755 /bin/init_container.sh

COPY ssh_setup.sh /tmp
RUN chmod -R +x /tmp/ssh_setup.sh \
    && (sleep 1;/tmp/ssh_setup.sh 2>&1 > /dev/null)

WORKDIR /app
COPY --from=publish /app/publish .
COPY --from=publish /app/vsdbg /vsdbg

ENTRYPOINT ["/bin/init_container.sh"]