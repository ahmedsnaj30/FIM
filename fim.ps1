
Write-Host ""

# Function to calc file hash
Function Calc-Hash($filepath) {
    $filehash = Get-FileHash $filepath -Algorithm SHA512
    return $filehash
}

# Function to delete baseline if it already exists
Function Erase-Existing-Baseline() {
    $exists = Test-Path -Path .\baseline.txt
    if($exists) {
        Remove-Item -Path .\baseline.txt
    }
}

# Function if user picks A or B
Function FIM($response) {
    if($response -eq "A".ToUpper()) {
        # Calc Hash and store in baseline.txt
        Write-Host "Calc Hashes, make new baseline.txt" -ForegroundColor Magenta

        Erase-Existing-Baseline

        # cd path and collect all files in target folder
        $files = Get-ChildItem -Path .\files

        # Calc hash for each file + store into baseline.txt
        foreach($i in $files) {
            $hash = Calc-Hash $i.FullName
            "$($hash.Path)|$($hash.Hash)" | Out-File -FilePath .\baseline.txt -Append
        }
    }
    elseif($response -eq "B".ToUpper()) {
        Write-Host "Read existing baseline.txt, start/continue monitoring files." -ForegroundColor Green

        # Load file|hash from baseline.txt and store in dictionary
        $dict = @{}
        $PathsAndHashes = Get-Content -Path .\baseline.txt

        # Splitting File Paths and Hashes into keys and values in dictionary
        foreach ($f in $PathsAndHashes) {
            $dict.add($f.Split("|")[0],$f.Split("|")[1])
        }

        # Begin/continue monitoring file with saved Baseline
        while ($true) {
            Start-Sleep -Seconds 1
            $files = Get-ChildItem -Path .\files

            foreach($f in $files) {
                $hash = Calc-Hash $f.FullName

                # If new file created
                if ($dict[$hash.Path] -eq $null) {
                    Write-Host "$($hash.Path) has been created" -Foreground Green
                }
                else {
                    # If file matches dictionary 
                    if ($dict[$hash.Path] -eq $hash.Hash) {
                    # file hasn't changed
                    } else {
                        Write-Host "$($hash.Path) has been modified!" -ForegroundColor Cyan
                    }
                }
            }
            # If file is deleted
            foreach($k in $dict.Keys) {
                $StillExists = Test-Path -Path $k
                if (-Not $StillExists) {
                    Write-Host "$($k) has been deleted!" -ForegroundColor Red
                }
            }
        }
    }
}

# $hash = Calc-Hash "C:\Users\Ahmed Shaheen\Desktop\Programming stuff\FIM\files\a.txt"

Write-Host "What would you like to do? `n"
Write-Host "    A. Collect new Baseline?"
Write-Host "    B. Begin monitoring file with saved Baseline? `n"

$response = Read-Host -Prompt "Please enter 'A' or 'B'"

FIM $response

# Edge Case
while ($response -ne "A" -and $response -ne "B") {

    $response = Read-Host -Prompt "Please enter 'A' or 'B'"

    FIM $response
}
