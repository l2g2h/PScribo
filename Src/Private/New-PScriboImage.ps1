function New-PScriboImage
{
<#
    .SYNOPSIS
        Initializes a new PScribo Image object.
    .NOTES
        This is an internal function and should not be called directly.
#>
    [CmdletBinding(DefaultParameterSetName = 'UriSize')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions','')]
    [OutputType([System.Management.Automation.PSCustomObject])]
    param
    (
        [Parameter(Mandatory, ParameterSetName = 'UriSize')]
        [Parameter(Mandatory, ParameterSetName = 'UriPercent')]
        [System.String] $Uri,

        [Parameter(Mandatory, ParameterSetName = 'Base64Size')]
        [Parameter(Mandatory, ParameterSetName = 'Base64Percent')]
        [System.String] $Base64,

        [Parameter(ParameterSetName = 'UriSize')]
        [Parameter(ParameterSetName = 'Base64Size')]
        [System.UInt32] $Height,

        [Parameter(ParameterSetName = 'UriSize')]
        [Parameter(ParameterSetName = 'Base64Size')]
        [System.UInt32] $Width,

        [Parameter(Mandatory, ParameterSetName = 'UriPercent')]
        [Parameter(Mandatory, ParameterSetName = 'Base64Percent')]
        [System.UInt32] $Percent,

        [Parameter()]
        [ValidateSet('Left','Center','Right')]
        [System.String] $Align = 'Left',

        [Parameter(Mandatory, ParameterSetName = 'Base64Size')]
        [Parameter(Mandatory, ParameterSetName = 'Base64Percent')]
        [Parameter(ParameterSetName = 'UriSize')]
        [Parameter(ParameterSetName = 'UriPercent')]
        [System.String] $Text = $Uri,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String] $Id = [System.Guid]::NewGuid().ToString()
    )
    process
    {
        $imageNumber = [System.Int32] $pscriboDocument.Properties['Images']++;

        if ($PSBoundParameters.ContainsKey('Uri'))
        {
            $imageBytes = GetImageUriBytes -Uri $Uri
        }
        elseif ($PSBoundParameters.ContainsKey('Base64'))
        {
            $imageBytes = [System.Convert]::FromBase64String($Base64)
        }

        $image = GetImageFromBytes -Bytes $imageBytes

        if ($PSBoundParameters.ContainsKey('Percent'))
        {
            $Width = ($image.Width / 100) * $Percent
            $Height = ($image.Height / 100) * $Percent
        }
        elseif (-not ($PSBoundParameters.ContainsKey('Width')) -and (-not $PSBoundParameters.ContainsKey('Height')))
        {
            $Width = $image.Width
            $Height = $image.Height
        }

        $pscriboImage = [PSCustomObject] @{
            Id          = $Id;
            ImageNumber = $imageNumber;
            Text        = $Text
            Type        = 'PScribo.Image';
            Bytes       = $imageBytes;
            Uri         = $Uri;
            Name        = 'Img{0}' -f $imageNumber;
            Align       = $Align;
            MIMEType    = GetImageMimeType -Image $image
            WidthEm     = ConvertPxToEm -Pixel $Width;
            HeightEm    = ConvertPxToEm -Pixel $Height;
            Width       = $Width;
            Height      = $Height;
        }
        return $pscriboImage;
    }
}
