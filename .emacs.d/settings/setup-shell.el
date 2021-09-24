(if (string= system-type "windows-nt")
    (setq
     shell-file-name "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe"
     explicit-powershell.exe-args '("-InputFormat" "Text" "-NoLogo")))

(provide 'setup-shell)
