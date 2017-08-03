// Copyright (c) .NET Foundation and contributors. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

using Microsoft.DotNet.Cli.Utils;
using System.IO;
using System.Linq;

namespace Microsoft.DotNet.Tools.Test.Utilities
{
    public class DotnetCommand : TestCommand
    {
        public DotnetCommand()
            : this(DotnetUnderTest.FullName)
        {
        }

        public DotnetCommand(string dotnetUnderTest)
            : base(dotnetUnderTest)
        {
            // Some scripts (e.g. RunCsc/RunVbc) depend on the correct `dotnet`
            // being in the PATH. When tests use `DotnetUnderTest.WithBackwardsCompatibleRuntimes`,
            // this means that the up-to-date dotnet command is resolved by the
            // old-runtime-targeting RunCsc/Roslyn, causing compatability issues.
            // So, detect if we're running a dotnet that's not just a plain "dotnet",
            // and if so, set DOTNET_HOST_PATH, which is recognized as an override
            // for the location of dotnet.
            var containingDirectory = Path.GetDirectoryName(dotnetUnderTest);
            if (!string.IsNullOrEmpty(containingDirectory))
            {
                Environment["DOTNET_HOST_PATH"] = containingDirectory;
            }
        }
    }
}
