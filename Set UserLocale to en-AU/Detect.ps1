try {
    $UILanguage = 'en-US';
    $output = 'Detected';
    $CurrentUILanguage = (Get-WinUILanguageOverride -ErrorAction SilentlyContinue)

    if ($CurrentUILanguage.Name -eq $UILanguage ) {
        return $output
		exit 0
        }
	else {
		exit 1
	}
}
catch { exit }    
