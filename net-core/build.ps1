$ErrorActionPreference = "Stop"


function clean() {
    dotnet clean
    if ($LASTEXITCODE) {
        throw "Error cleaning"
    }
}

function restore() {
    dotnet restore
    if ($LASTEXITCODE) {
        throw "Error restore"
    }
}

function build() {
    dotnet msbuild Ical.Net.sln /p:Configuration=Release
    if ($LASTEXITCODE) {
        throw "Error build"
    }
}

function package() {
    dotnet pack Ical.Net/Ical.Net.csproj -p:NuspecFile=../Ical.Net.nuspec -p:NuspecBasePath=../ -p:NuspecProperties=\"version=0.0.1\"
    if ($LASTEXITCODE) {
        throw "Error package"
    }
}

try {
    clean
    restore
    build
    package
}
catch {
    Write-Host "Exception: $_"
    exit $LASTEXITCODE
}
