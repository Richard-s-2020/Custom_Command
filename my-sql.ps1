function MY-SQL {
    $previousNumber = -1
    $scores = -1
    $max_Score = 15
    
    function Random {
        $currentNumber = Get-Random -Minimum 0 -Maximum $max_Score
    
        while ($currentNumber -eq $previousNumber) {
            $currentNumber = Get-Random -Minimum 0 -Maximum $max_Score
        }
    
        $previousNumber = $currentNumber

        $question = $Vraag[$currentNumber]
        $expectedAnswer = $antwere[$currentNumber]
        return $currentNumber, $question, $expectedAnswer, $previousNumber
    }
    
    function Vraag {
        Write-Host "Stop : reload : Help : ansere |                  Your Score =" $scores
        Write-Host "----------------------------------------------------------------------"
        $Antwoord = Read-Host $question
        if ($Antwoord -ieq $expectedAnswer) {
            $currentNumber, $question, $expectedAnswer,  $previousNumber = Random
            $scores = 1 + $scores
            Write-Host "Well done! Next question."
            Clear-Host
            Vraag
        }
        else {
            if ($Antwoord -ieq "Stop") { 
                Clear-Host
                return
            }
            elseif ($Antwoord -ieq "reload") {
                $scores = $scores - 1
                Write-Host "Incorrect answer. Try again."
                Clear-Host
                Vraag
            }
            elseif ($Antwoord -ieq "Help") {
                # Add your help functionality here if needed
            }
            elseif ($Antwoord -ieq "ansere") {
                Write-Host $expectedAnswer
                Vraag
            }
            else {
                Write-Host "Try again."
                Clear-Host
                Vraag
            }
        }
    }
    
    $antwere = @{
        #Select
        0 = "select * from Customers;"
        1 = "select City from Customers;"
        2 = "select Distinct Country from Customers;"
        
        #Where
        3 = "select * from Customers where City = 'berlin';"
        4 = "select * from customers where not city = 'Berlin';"
        5 = "select * from Customers where CustomerID = 32;"
        6 = "select * from Customers where City = 'Berlin' and Postalcode = 12209;"
        7 = "select * from customers where city = 'Berlin' or City = 'London';"
        
        # Order by
        8 = "Select * from customers order by City;"
        9 = "select * from Customers order by City DESC;"
        10 = "select * from customers order by Country, City;"
        
        #null
        11 = "Select * from Customers where PostalCode is null;"
        12 = "select * from customers where PostalCode is not null;"

        #update
        13 = "update Customers set City = 'Oslo';"
        14 = "update customers set City = 'Oslo where Country = 'Norway';"
        15 = "Update customers set city = 'Oslo', Country = 'Norway' where customerID = 32;"
    }
    
    $Vraag = @{
        #Select
        0 = "get all the columns from the Customers table."
        1 = "get the City column from the Customers table"
        2 = "get all the different values from the Country column in the Customers table"

        #Where
        3 = "Select all records where the City column has the value 'Berlin'."
        4 = "Select all records where the City column has not the value 'Berlin'."
        5 = "Select all records where the CustomerID column has the value 32."
        6 = "Select all records where the City column has the value 'Berlin' and the PostalCode column has the value 12209."
        7 = "Select all records where the City column has the value 'Berlin' or 'London'."

        # Order by
        8 = "Select all records from the Customers table, sort the result alphabetically by the column City."
        9 = "Select all records from the Customers table, sort the result reversed alphabetically by the column City."
        10 = "Select all records from the Customers table, sort the result alphabetically, first by the column Country, then, by the column City."

        #null
        11 = "Select all records from the Customers where the PostalCode column is empty."
        12 = "Select all records from the Customers where the PostalCode column is NOT empty."

        #update
        13 = "Update the City column of all records in the Customers table."
        14 = "update Customers Set the value of the City columns to 'Oslo', but only the ones where the Country column has the value 'Norway'."
        15 = "update Customers Set the value of the City columns to 'Oslo' and country is norway where customerID = 32"
    }
    Vraag
}

MY-SQL
