function Menu{

    $Menu = @(
        "1. Add",
        "2. Subtract",
        "3. Multiply",
        "4. Divide",
        "5. Exit"
    )

    $Menu | ForEach-Object { Write-Host $_ }
    $Choice = Read-Host "Enter your choice"

    switch ($Choice) {
        1 { Add }
        2 { Subtract }
        3 { Multiply }
        4 { Divide }
        5 { Exit }
        default { Write-Host "Invalid choice" }
    }
}
Menu