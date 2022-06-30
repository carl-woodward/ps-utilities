
function Get-ErrorText {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string] $Value
    )

    [Flags()] enum FORMAT_MESSAGE{
        ALLOCATE_BUFFER = 0x00000100;
        IGNORE_INSERTS = 0x00000200;
        FROM_SYSTEM = 0x00001000;
        ARGUMENT_ARRAY = 0x00002000;
        FROM_HMODULE = 0x00000800;
        FROM_STRING = 0x00000400;
    }
    
    $FunctionSig = @"
[DllImport("Kernel32.dll", SetLastError=true)]
public static extern uint FormatMessage( uint dwFlags, IntPtr lpSource,
   uint dwMessageId, uint dwLanguageId, ref IntPtr lpBuffer,
   uint nSize, IntPtr pArguments);
[DllImport("kernel32.dll", SetLastError=true)]
public static extern IntPtr LocalFree(IntPtr hMem);
[DllImport("kernel32", SetLastError=true, CharSet = CharSet.Ansi)]
public static extern IntPtr LoadLibrary([MarshalAs(UnmanagedType.LPStr)]string lpFileName);
[DllImport("kernel32.dll", SetLastError=true)]
[return: MarshalAs(UnmanagedType.Bool)]
public static extern bool FreeLibrary(IntPtr hModule);
"@

    [System.IntPtr] $buffer = [System.IntPtr]::Zero
    $flags = [FORMAT_MESSAGE]::ALLOCATE_BUFFER + [FORMAT_MESSAGE]::FROM_SYSTEM + [FORMAT_MESSAGE]::IGNORE_INSERTS + [FORMAT_MESSAGE]::FROM_HMODULE
    $flagsValue = [int]$flags; 
    $kernel32 = Add-Type -MemberDefinition $FunctionSig -Name "Errors" -Namespace Win32Functions -PassThru -ErrorAction SilentlyContinue

    $ntdll = $kernel32::LoadLibrary("ntdll.dll")
    $result = $kernel32::FormatMessage($flagsValue, $ntdll, $Value, 0, [ref] $buffer, 0, 0)
    if ($ntdll) {
        $null = $kernel32::FreeLibrary($ntdll)
    }    

    if ($result) {
        $valueString = [System.Runtime.InteropServices.Marshal]::PtrToStringAnsi($buffer)
        Write-Output ('{0} -> {1}' -f $Value, $valueString)  
    }
    else {
        Write-Output ("Failed to get error text")
    }

    if ($buffer) {
        $null = $kernel32::LocalFree($buffer)
    }
 
}

Export-ModuleMember -Function Get-ErrorText