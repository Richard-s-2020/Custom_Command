function ChatGPT {
    param (
        [string]$chatPrompt 
    )

    $SCV = Import-Csv .\Private.csv -Delimiter ";"
    $url = "https://api.openai.com/v1/chat/completions"
    
    function csv {
        foreach ($info in $SCV) {
            $name = $info.name
            $priavte = $info.key
            if ($name = "CHatgtp") {

                return $priavte
            }
        }
    }

    if (!($chatPrompt = "")) {$chatPrompt = Read-Host "ask me everthing" }
    $priavte = csv
    $requestBody = @{
        "model" = "gpt-3.5-turbo"
        "messages" = @(
            @{
                "role" = "system"
                "content" = "You are"
            },
            @{
                "role" = "user"
                "content" = $chatPrompt
            }
        )
        "max_tokens" = 50
    }
    
    $headers = @{
        "Authorization" = "Bearer $priavte"
        "Content-Type" = "application/json"
    }
    
    $response = Invoke-RestMethod -Uri $url -Method Post -Headers $headers -Body ($requestBody | ConvertTo-Json)
    
    $chatReply = $response.choices[0].message.content
    Write-Host "ChatGPT: $chatReply"
    
}
