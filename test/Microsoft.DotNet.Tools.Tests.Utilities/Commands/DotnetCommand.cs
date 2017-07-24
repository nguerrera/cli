// Copyright (c) .NET Foundation and contributors. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

using Microsoft.DotNet.Cli.Utils;
using System.IO;

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
            // and if so, make sure it's on the PATH.
            var containingDirectory = Path.GetDirectoryName(dotnetUnderTest);
            if (!string.IsNullOrEmpty(containingDirectory))
            {
                // if it's already set, use that
                string path;
                if (!Environment.TryGetValue("PATH", out path))
                {
                    // otherwise grab it from the environment
                    path = System.Environment.GetEnvironmentVariable("PATH");
                }
                // if it's the only item in the path, set it
                if (string.IsNullOrEmpty(path))
                {
                    path = containingDirectory;
                }
                else
                {
                    // otherwise, join it with the rest of the path,
                    // putting it in front so it takes priority
                    path = containingDirectory + Path.PathSeparator + path;
                }
                Environment["PATH"] = path;
            }
        }
    }
}
