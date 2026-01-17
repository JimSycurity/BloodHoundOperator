<#
.Synopsis
    Get BloodHound Operator Help
.DESCRIPTION
    Get BloodHound Operator Help
.EXAMPLE
    BHHelp
#>

function Get-BHOperatorHelp{
    [CmdletBinding(DefaultParameterSetName='BH')]
    [Alias('BHHelp')]
    Param(
        [Parameter(Mandatory=0,ParameterSetName='BH')][Switch]$ReadTheDocs,
        [Parameter(ParameterSetName='T0')][Switch]$TierZero,
        [Parameter()][Switch]$Online
        )
    if($ReadTheDocs){Start-Process 'https://support.bloodhoundenterprise.io/hc/en-us/categories/1260801932169-General'}
    elseif($Online){
        if($TierZero){Start-Process 'https://specterops.github.io/TierZeroTable/'}
        else{Start-Process 'https://gist.github.com/SadProcessor/f996c01b57e1f11c67f91de2070d45fe'}
        }
    else{if($TierZero){
        $TZ = irm 'https://raw.githubusercontent.com/SpecterOps/TierZeroTable/main/TierZeroTable.csv' | ConvertFrom-Csv -Delimiter ';'
        $TZ | %{[PSCustomObject]@{
            Provider = Switch($_.IdP){'Active Directory'{'AD'}Default{$_}}
            Type = $_.Type
            Name = $_.name
            Identifier = $_.Identification
            IsTierZero  = Switch($_.'Is Tier Zero'){NO{$False}YES{$true}Default{$_}}
            Description = $_.Description
            Reasoning = $_.Reasoning
            CanCompromise          = if($_.'Known Tier Zero compromise by common (mis)configuration'-match"^YES" -OR $_.'Known Tier Zero compromise by default configuration'-match"^YES"){$true}else{'??'}
            DefaultConfig          = if($_.'Known Tier Zero compromise by common (mis)configuration'-match"^YES" -OR $_.'Known Tier Zero compromise by default configuration'-match"^YES"){if($_.'Known Tier Zero compromise by default configuration'-match"^YES"){$true}else{$false}}else{}
            CompromiseType         = $(if($_.'Known Tier Zero compromise by common (mis)configuration'-match"^YES"){
                                        $_.'Known Tier Zero compromise by common (mis)configuration'.split('-')[1].trim()
                                        }
                                     elseif($_.'Known Tier Zero compromise by default configuration'-match"^YES"){
                                        $_.'Known Tier Zero compromise by default configuration'.split('-')[1].trim()
                                        })
            IsAdminSDHolder  = Switch($_.'AdminSDHolder protected'){NO{$False}YES{$true}}
            IsPrivAccessRole = Switch($_.'Microsoft: Privileged access security roles'){NO{$False}YES{$true}}
            Links = ($_.'External Links'-split("`r`n")).trim()
            }}
        }
        else{$CmdletList = @(
            Get-Command *-BHComposer*   | sort-object Noun,Verb
            Get-Command *-BHSession*    | sort-object Noun,Verb
            Get-Command *-BHAPI*        | sort-object Noun,Verb
            Get-Command *-BHServer*     | sort-object Noun,Verb
            Get-Command *-BHOperator*   | sort-object Noun,Verb
            Get-Command *-BHData*       | sort-object Noun,Verb
            Get-Command *-BHNode*       | sort-object Noun,Verb
            Get-Command *-BHPath*       | sort-object Noun,Verb
            Get-Command *-BHClient*     | sort-object Noun,Verb
            Get-Command *-BHEvent*      | sort-object Noun,Verb
            Get-Command *-BHRRule*      | sort-object Noun,Verb
            Get-Command *-BHDate*       | sort-object Noun,Verb
            Get-Command *-BHAssetGroup* | sort-object Noun,Verb
            Get-Command *-BHOpenGraph*  | sort-object Noun,Verb
            )
        $Out = Foreach($Cmdlet in $CmdletList){
            $Als = Get-Alias -Definition $Cmdlet.name -ea 0 | Select -first 1
            [PSCustomObject]@{
                Cmdlet   = $Cmdlet.Name
                Alias    = $Als
                Description = (Get-Help $Cmdlet.Name).synopsis
                Examples = "Help $(if($Als){$Als}else{$Cmdlet.Name}) -Example"
                }}
        if($BHCE){$Out|? description -notmatch "^\[BHE\]"}else{$Out}
        }}}
