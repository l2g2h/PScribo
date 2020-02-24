function OutWordBlankLine
{
<#
    .SYNOPSIS
        Output formatted Word xml blank line (paragraph).
#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [System.Management.Automation.PSObject] $BlankLine,

        [Parameter(Mandatory)]
        [System.Xml.XmlDocument] $XmlDocument,

        [Parameter(Mandatory)]
        [System.Xml.XmlElement] $Element
    )
    process
    {
        $xmlnsMain = 'http://schemas.openxmlformats.org/wordprocessingml/2006/main'
        for ($i = 0; $i -lt $BlankLine.LineCount; $i++) {
            [ref] $null = $Element.AppendChild($XmlDocument.CreateElement('w', 'p', $xmlnsMain))
        }
    }
}
