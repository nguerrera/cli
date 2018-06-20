:: Before this can work incrementally, build core-setup completely for x86 and x64
::   build -SkipTests
::   build -TargetArchitecture=x86 -Platform=x86 -SkipTests=true

@setlocal
@cd /d %~dp0
SET NUGET_PACKAGES=%CD%\.nuget\packages
rd /s /q .nuget\packages\microsoft.netcore.dotnethostresolver
rd /s /q .nuget\packages\runtime.win-x86.microsoft.netcore.dotnethostresolver
rd /s /q .nuget\packages\runtime.win-x64.microsoft.netcore.dotnethostresolver
msbuild build\NugetConfigFile.targets /p:GeneratedNuGetConfig=%CD%\NuGet.config || goto :eof
msbuild ..\core-setup\Bin\obj\win-x86.Debug\corehost\ALL_BUILD.vcxproj /nologo /v:m /p:Configuration=Debug /p:Platform=x86 /p:PlatformToolset="v141" || goto :eof
msbuild ..\core-setup\Bin\obj\win-x64.Debug\corehost\ALL_BUILD.vcxproj /nologo /v:m /p:Configuration=Debug /p:Platform=x64 /p:PlatformToolset="v141" || goto :eof
copy ..\core-setup\Bin\obj\win-x64.Debug\corehost\cli\fxr\Debug\hostfxr.dll ..\core-setup\Bin\win-x64.Debug\corehost\hostfxr.dll || goto :eof
copy ..\core-setup\Bin\obj\win-x64.Debug\corehost\cli\fxr\Debug\hostfxr.pdb ..\core-setup\Bin\win-x64.Debug\corehost\hostfxr.pdb || goto :eof
copy ..\core-setup\Bin\obj\win-x86.Debug\corehost\cli\fxr\Debug\hostfxr.dll ..\core-setup\Bin\win-x86.Debug\corehost\hostfxr.dll || goto :eof
copy ..\core-setup\Bin\obj\win-x86.Debug\corehost\cli\fxr\Debug\hostfxr.pdb ..\core-setup\Bin\win-x86.Debug\corehost\hostfxr.pdb || goto :eof
msbuild ..\core-setup\src\pkg\projects\Microsoft.NETCore.DotNetHostResolver\Microsoft.NETCore.DotNetHostResolver.pkgproj /nologo /v:m || goto :eof
msbuild ..\core-setup\src\pkg\projects\Microsoft.NETCore.DotNetHostResolver\Microsoft.NETCore.DotNetHostResolver.pkgproj /nologo /v:m /p:TargetArchitecture=x86 /p:PackageTargetRuntime=win-x86 || goto :eof
msbuild ..\core-setup\src\pkg\projects\Microsoft.NETCore.DotNetHostResolver\Microsoft.NETCore.DotNetHostResolver.pkgproj /nologo /v:m /p:TargetArchitecture=x64 /p:PackageTargetRuntime=win-x64 || goto :eof
dotnet build /nologo src\Microsoft.DotNet.MSBuildSdkResolver\Microsoft.DotNet.MSBuildSdkResolver.sln || goto :eof
dotnet test -f net461 --no-restore --no-build  test\Microsoft.DotNet.MSBuildSdkResolver.Tests\Microsoft.DotNet.MSBuildSdkResolver.Tests.csproj || goto :eof