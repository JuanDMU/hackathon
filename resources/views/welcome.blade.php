<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Database Connection Test</title>
</head>
<body>
    <h1>Hola</h1>

    <h2>Estado de la base de datos:</h2>
    <p>
        @php
            try {
                \DB::connection()->getPdo();
                echo "Conexión exitosa a la base de datos.";
            } catch (\Exception $e) {
                echo "Error de conexión: " . $e->getMessage();
            }
        @endphp
    </p>

    <h3>Autores:</h3>
    <ul>
        <li>Juan Diego Miranda Ureña</li>
        <li>Aaron Diaz Garay</li>
    </ul>
</body>
</html>
