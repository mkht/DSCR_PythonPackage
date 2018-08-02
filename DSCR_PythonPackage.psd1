@{
    # Script module or binary module file associated with this manifest.
    RootModule           = 'DSCR_PythonPackage.psm1'

    DscResourcesToExport = 'pip'

    # Version number of this module.
    ModuleVersion        = '0.2.0'

    # ID used to uniquely identify this module
    GUID                 = 'cde27ce5-de79-429f-821f-25bb9562bdc7'

    # Author of this module
    Author               = 'mkht'

    # Company or vendor of this module
    CompanyName          = ''

    # Copyright statement for this module
    Copyright            = '(c) 2018 mkht All rights reserved.'

    # Description of the functionality provided by this module
    Description          = 'PowerShell DSC Resource for Python Package management (pip)'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion    = '5.0'

    # Name of the Windows PowerShell host required by this module
    # PowerShellHostName = ''

    PrivateData          = @{
        PSData = @{
            Tags       = ('DesiredStateConfiguration', 'DSC', 'Python', 'pip')

            LicenseUri = 'https://github.com/mkht/DSCR_PythonPackage/blob/master/LICENSE'

            ProjectUri = 'https://github.com/mkht/DSCR_PythonPackage'

            # IconUri = ''

            # ReleaseNotes = ''
        }
    }
}
