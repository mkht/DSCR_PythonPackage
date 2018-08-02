Enum Ensure{
    Present
    Absent
}


[DscResource()]
Class pip {

    [DSCProperty(Key)]
    [String]
    $Package

    [DSCProperty()]
    [Ensure]
    $Ensure = [Ensure]::Present

    # [DSCProperty()]
    # [String]
    # $PackageFile

    [DSCProperty()]
    [String]
    $Version

    [DSCProperty()]
    [String]
    $PipPath


    [pip] Get() {
        $pip = $this.TestPipPath($this.PipPath)

        if (-not $pip) {
            throw 'pip.exe is not found!'
        }

        $result = [pip]::new()
        $result.Package = $this.Package
        $result.PipPath = $pip

        $listOfPackage = & $pip list --disable-pip-version-check | Select-Object -Skip 2 | ForEach-Object { $t = ($_ -split '\s+'); [PsCustomObject]@{Name = $t[0]; Version = $t[1]} }

        $targetPackage = $listOfPackage | Where-Object {$_.Name -eq $this.Package}
        if ($targetPackage.Version) {
            Write-Verbose ('The package "{0}" found. Version is "{1}"' -f $targetPackage.Name, $targetPackage.Version)
            $result.Version = $targetPackage.Version
        }

        if ($this.Version) {
            $targetPackage = $targetPackage | Where-Object {$_.Version -eq $this.Version}
        }

        if ($targetPackage) {
            $result.Ensure = [Ensure]::Present
        }
        else {
            $result.Ensure = [Ensure]::Absent
        }

        return $result
    }


    [bool] Test() {
        $result = ($this.Ensure -eq $this.Get().Ensure)
        Write-Verbose ("Test result is $result")
        return $result
    }


    [void] Set() {
        $pip = $this.TestPipPath($this.PipPath)

        if (-not $pip) {
            throw 'pip.exe is not found!'
        }

        if ($this.Ensure -eq [Ensure]::Present) {
            # if ($this.PackageFile) {
            #     $query = $this.PackageFile
            # }
            if ($this.Version) {
                $query = $this.Package + '==' + $this.Version
            }
            else {
                $query = $this.Package
            }

            Write-Verbose ('Start package installation : {0}' -f $this.Package)
            & $pip install --disable-pip-version-check --no-warn-script-location --no-cache-dir --force-reinstall --progress-bar off $query
        }
        elseif ($this.Ensure -eq [Ensure]::Absent) {
            $query = $this.Package

            Write-Verbose ('Start package uninstallation : {0}' -f $this.Package)
            & $pip uninstall --disable-pip-version-check -y $query
        }
    }


    Hidden [string] TestPipPath([string]$Path) {
        if ($Path) {
            if (-not (Test-Path $Path -PathType Leaf)) {
                return ''
            }

            if ((Split-Path $Path -Leaf) -ne 'pip.exe') {
                return ''
            }

            return (Resolve-Path $Path).Path
        }
        else {
            $Command = Get-Command 'pip' -CommandType Application -ErrorAction SilentlyContinue
            if (-not $Command) {
                return ''
            }

            return $Command.Source
        }
    }

}
