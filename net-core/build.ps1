param ($version='0.0.0')

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
    dotnet pack --output nupkgs /p:Configuration=Release Ical.Net/Ical.Net.csproj -p:NuspecFile=../Ical.Net.nuspec -p:NuspecBasePath=../ -p:NuspecProperties="version=${version}"
    if ($LASTEXITCODE) {
        throw "Error package"
    }
}

try {
    clean
    restore
    build
    package $version
}
catch {
    Write-Host "Exception: $_"
    exit $LASTEXITCODE
}
