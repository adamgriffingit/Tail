# This script is meant to perform similar to the *nix "tail" command.
# It should watch a file and output any new lines added to it until killed by the user.
# Typical use is for watching a log file.

# Every second, compare file size and line array count to previous measures.
# If changed, then output the lines and update the measures.

function Tail
{
    param( [String]$FilePath )

    # Test if the file exists
    If(Test-Path $FilePath)
    {
        "Starting to tail the file. Press Cntrl+C to end tail."

        # Declare what we track.
        [int]$FileSize = (Get-Item($FilePath)).Length
        $Lines = Get-Content $FilePath
        [int]$LineCount = $Lines.Length
        [bit]$DoLoop = $true

        While($DoLoop)
        {
            [int]$LoopFileSize = (Get-Item($FilePath)).Length
            # Check for decreased file size (shouldn't happen).
            If( $FileSize -gt $LoopFileSize)
            {
                "Err: File size DECREASED! I can not handle that. Exiting."
                $DoLoop = $false
            }
            # Check for increased file size.
            If( $FileSize -lt $LoopFileSize)
            {
                # Check for increased line count.
                $LoopLines = Get-Content $FilePath
                [int]$LoopLineCount = $LoopLines.Length
                If( $LineCount -lt $LoopLineCount )
                {
                    #Ouput the new lines.
                    For( $i=$LineCount; $i -lt $LoopLineCount; $i=$i+1)
                    {
                        $LoopLines[$i]
                    }
                    $LineCount = $LoopLineCount
                }
                $FileSize = $LoopFileSize
            }
            Start-Sleep 2 
        }
    }
    else
    {
        "Err: File not found."
    }
}